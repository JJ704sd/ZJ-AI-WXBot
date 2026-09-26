/*
 * Repeatable plain-text sender for the exact inspected Windows x64 module.
 * configure is read-only. construct builds one native payload per request;
 * submit requires explicit confirmation and is consumed before the native call.
 * The trusted host persists requestId before construct/submit and validates the
 * account's database owner, process start time and module hash before each send.
 *
 * Long UTF-8 strings use Weixin's own reallocation/assignment helper 3E150,
 * including its >=4096-byte aligned allocation convention. Frida buffers are
 * only copied from; they are never installed as native-owned heap pointers.
 * After send returns, 53120 releases our payload and token shared references.
 * The queued task owns independent references (19D0BC0 + 5F2B0).
 * Exceptions retain the possibly-live inputs and block further native calls.
 * The host must retain its inert keeper and eternalize this script on shutdown.
 * See evidence/windows-repeatable-text-2026-09-26/README.md.
 */
'use strict';

const PROFILE = Object.freeze({
    clientVersion: '4.1.15.13', arch: 'x64', moduleName: 'Weixin.dll',
    moduleSha256: '10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5'
});
const ENTRY = Object.freeze({
    textFactory: {rva: 0x6f4c70, bytes: '555657534883ec38488d6c243048c74500feffffff4889ceb9a8070000e80a6c'},
    textConstructor: {rva: 0x766680, bytes: '5556574883ec50488d6c245048c745f8feffffff4889ce488d7dd84889f9e8ed'},
    optionsConstructor: {rva: 0xf910, bytes: '554157415641545657534883ec40488d6c244048c745f8feffffff4c894de84c'},
    sendMessage: {rva: 0x19d0bc0, bytes: '5541565657534881ece0010000488dac248000000048c78558010000feffffff'},
    stringAssign: {rva: 0x3e150, bytes: '4157415641545657534883ec284885d20f88e50000004c89cb4889d74889ce4c'},
    releaseShared: {rva: 0x53120, bytes: '564883ec204885c97423f0ff4908751d488b014889ceff10f0ff4e0c750f488b'}
});
const VT = Object.freeze({text: 0x8e53588, control: 0x8e534f8, param: 0x9112308, token: 0x8d47048});
const MAX_TEXT_UNITS = 2000, MAX_TEXT_BYTES = 8000;
const requests = new Map();
let phase = 'disabled', configured = null, current = null, sequence = 0;

function requireThat(ok, code) { if (!ok) throw new Error(code); }
function normalizedPath(value) { return String(value || '').replace(/\//g, '\\').toLowerCase(); }
function hex(address, size) {
    return Array.from(new Uint8Array(address.readByteArray(size)), b => b.toString(16).padStart(2, '0')).join('');
}
function zero(record, size) {
    const result = Memory.alloc(size);
    result.writeByteArray(new Uint8Array(size)); record.roots.push(result); return result;
}
function uintEquals(address, value) { return address.readU64().toString() === String(value); }
function freezeBinding(value) {
    requireThat(value && value.pid === Process.id && Number.isInteger(value.pid), 'process_mismatch');
    requireThat(typeof value.processStarted === 'string' && /^\d{16,20}$/.test(value.processStarted), 'invalid_process_identity');
    requireThat(typeof value.selfId === 'string' && /^wxid_[A-Za-z0-9_]+$/.test(value.selfId), 'invalid_account_identity');
    requireThat(typeof value.sourceRoot === 'string' && /^[A-Za-z]:\\/.test(value.sourceRoot), 'invalid_source_identity');
    for (const key of ['clientVersion', 'arch', 'moduleSha256']) requireThat(value[key] === PROFILE[key], 'binding_profile_mismatch');
    return Object.freeze({pid: value.pid, processStarted: value.processStarted,
        selfId: value.selfId, sourceRoot: normalizedPath(value.sourceRoot),
        clientVersion: value.clientVersion, arch: value.arch, moduleSha256: value.moduleSha256});
}
function authorize(request) { requireThat(configured && request && request.nonce === configured.nonce, 'not_authorized'); }
function validateLiveCode() {
    requireThat(Process.platform === 'windows' && Process.arch === 'x64' && Process.pointerSize === 8, 'unsupported_platform');
    requireThat(Process.id === configured.binding.pid, 'process_mismatch');
    const module = Process.getModuleByName(PROFILE.moduleName);
    requireThat(module.base.equals(configured.base) && normalizedPath(module.path) === configured.modulePath, 'module_changed');
    for (const item of Object.values(ENTRY)) {
        const address = module.base.add(item.rva), range = Process.findRangeByAddress(address);
        requireThat(range !== null && range.protection.includes('x') && hex(address, item.bytes.length / 2) === item.bytes, 'live_code_mismatch');
    }
    requireThat(module.base.add(VT.param + 0x10).readPointer().equals(module.base.add(ENTRY.sendMessage.rva)), 'dispatch_vtable_mismatch');
}
function native(name, returns, args) { return new NativeFunction(configured.base.add(ENTRY[name].rva), returns, args, 'win64'); }
function utf8(value) {
    const bytes = [];
    for (const character of value) {
        const c = character.codePointAt(0);
        requireThat(c !== 0 && !(c >= 0xd800 && c <= 0xdfff), 'invalid_text_unicode');
        if (c <= 0x7f) bytes.push(c);
        else if (c <= 0x7ff) bytes.push(0xc0 | (c >> 6), 0x80 | (c & 63));
        else if (c <= 0xffff) bytes.push(0xe0 | (c >> 12), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63));
        else bytes.push(0xf0 | (c >> 18), 0x80 | ((c >> 12) & 63), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63));
    }
    return new Uint8Array(bytes);
}
function emptySso(address) {
    return uintEquals(address.add(0x10), 0) && uintEquals(address.add(0x18), 15) && address.readU8() === 0;
}
function stringData(address) { return address.add(0x18).readU64().toNumber() < 16 ? address : address.readPointer(); }
function writeString(record, address, bytes) {
    requireThat(emptySso(address), 'nonempty_string_field');
    if (bytes.length <= 15) {
        const inline = new Uint8Array(16); inline.set(bytes); address.writeByteArray(inline);
        address.add(0x10).writeU64(bytes.length);
    } else {
        const source = zero(record, bytes.length + 1); source.writeByteArray(bytes);
        requireThat(native('stringAssign', 'pointer', ['pointer', 'uint64', 'uint64', 'pointer'])(
            address, uint64(bytes.length), uint64(0), source).equals(address), 'string_assignment_failed');
    }
}
function matchesString(address, value, size) {
    return uintEquals(address.add(0x10), size) && address.add(0x18).readU64().toNumber() >= size &&
        stringData(address).readUtf8String(size) === value && stringData(address).add(size).readU8() === 0;
}
function readUuid(inner) {
    const address = inner.add(0x6f8), length = address.add(0x10).readU64().toNumber();
    requireThat(length === 36 && address.add(0x18).readU64().toNumber() >= length, 'factory_uuid_missing');
    const value = stringData(address).readUtf8String(length);
    requireThat(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value), 'factory_uuid_invalid');
    return value;
}
function inspectPayload(record) {
    const p = record.payload, base = configured.base;
    const checks = {
        pointerPair: p.inner.equals(p.control.add(0x10)) && p.pair.readPointer().equals(p.inner) && p.pair.add(8).readPointer().equals(p.control),
        contentVtable: p.inner.readPointer().equals(base.add(VT.text)),
        controlVtable: p.control.readPointer().equals(base.add(VT.control)),
        weakSelfReference: p.inner.add(8).readPointer().equals(p.inner) && p.inner.add(0x10).readPointer().equals(p.control),
        receiver: matchesString(p.inner.add(0xb0), record.targetId, record.targetBytes),
        content: matchesString(p.inner.add(0x758), record.text, record.utf8Bytes),
        messageType: p.inner.add(0x118).readU32() === 1 && p.inner.add(0x11c).readU32() === 0,
        messageLength: uintEquals(p.inner.add(0x1c8), record.utf8Bytes),
        emptyAtList: emptySso(p.inner.add(0x778)),
        tokenPair: p.options.readPointer().equals(p.token.add(0x10)) && p.token.readPointer().equals(base.add(VT.token)) && p.token.add(0x10).readU8() === 0,
        emptyCallbacks: [0x48, 0x88, 0xc8, 0xd8, 0xe0].every(offset => p.options.add(offset).readPointer().isNull()) && uintEquals(p.options.add(0xd0), 0),
        vector: p.arg.readPointer().equals(base.add(VT.param)) && p.arg.add(8).readPointer().equals(p.vector) &&
            p.arg.add(0x10).readPointer().equals(p.vector.add(16)) && p.arg.add(0x18).readPointer().equals(p.vector.add(16)) && uintEquals(p.arg.add(0x20), 1) &&
            p.vector.readPointer().equals(p.inner) && p.vector.add(8).readPointer().equals(p.control)
    };
    requireThat(Object.values(checks).every(Boolean) && readUuid(p.inner) === record.clientMessageId, 'constructed_payload_mismatch');
    return checks;
}
function result(record, extra) {
    return Object.assign({state: record ? record.state : phase, ready: phase === 'configured' && current === null,
        requestId: record ? record.requestId : null, constructionId: record ? record.constructionId : null,
        clientMessageId: record ? record.clientMessageId : null,
        submissionAttempted: !!(record && record.attempted), sendCalled: !!(record && record.attempted),
        nativeFunctionsCalled: !!(record && record.nativeFunctionsCalled), targetId: record ? record.targetId : null,
        textLength: record ? record.textLength : 0, utf8Bytes: record ? record.utf8Bytes : 0,
        nativeAllocationRetained: !!(record && record.roots.length), serverAccepted: false,
        localRecordConfirmed: false, delivered: false, retryAllowed: false}, extra || {});
}

rpc.exports = {
    configure(request) {
        requireThat(phase === 'disabled' && configured === null, 'already_configured');
        requireThat(request && /^[A-Za-z0-9_-]{32,128}$/.test(request.nonce || ''), 'invalid_nonce');
        const profile = request.profile;
        requireThat(profile && Object.keys(PROFILE).every(key => profile[key] === PROFILE[key]), 'unsupported_profile');
        requireThat(profile.expectedCode && Object.entries(ENTRY).every(([name, entry]) => profile.expectedCode[name] === entry.bytes), 'invalid_code_attestation');
        requireThat(typeof profile.modulePath === 'string' && /^[A-Za-z]:\\/.test(profile.modulePath), 'invalid_module_path');
        const binding = freezeBinding(request.binding), module = Process.getModuleByName(PROFILE.moduleName);
        configured = Object.freeze({binding, nonce: request.nonce, base: module.base, modulePath: normalizedPath(profile.modulePath)});
        try { validateLiveCode(); } catch (error) { phase = 'blocked'; throw error; }
        phase = 'configured';
        return result(null, {configured: true, maxTextUnits: MAX_TEXT_UNITS, maxTextBytes: MAX_TEXT_BYTES});
    },
    construct(request) {
        authorize(request);
        requireThat(phase === 'configured' && current === null, 'session_not_ready');
        requireThat(/^[A-Za-z0-9_-]{1,128}$/.test(request.requestId || ''), 'invalid_request_id');
        requireThat(!requests.has(request.requestId), 'request_already_consumed');
        requireThat(typeof request.targetId === 'string' && /^[A-Za-z0-9_.@-]{1,256}$/.test(request.targetId), 'invalid_target_id');
        requireThat(typeof request.text === 'string' && request.text.trim().length > 0 && request.text.length <= MAX_TEXT_UNITS, 'invalid_text_length');
        const bytes = utf8(request.text);
        requireThat(bytes.length <= MAX_TEXT_BYTES, 'invalid_text_bytes');
        validateLiveCode();
        const receiverBytes = utf8(request.targetId);
        const record = {requestId: request.requestId, targetId: request.targetId, targetBytes: receiverBytes.length, text: request.text,
            textLength: request.text.length, utf8Bytes: bytes.length, roots: [], payload: null,
            state: 'constructing', attempted: false, nativeFunctionsCalled: false, clientMessageId: null,
            constructionId: configured.nonce.slice(0, 24) + ':' + (++sequence)};
        requests.set(record.requestId, record); current = record;
        let constructionStep = 'allocate_wrappers';
        try {
            const pair = zero(record, 16), options = zero(record, 0xe8);
            const callbacks = [zero(record, 0x40), zero(record, 0x40), zero(record, 0x40)], weakPair = zero(record, 16);
            record.nativeFunctionsCalled = true;
            constructionStep = 'text_factory';
            requireThat(native('textFactory', 'pointer', ['pointer'])(pair).equals(pair), 'factory_return_mismatch');
            const inner = pair.readPointer(), control = pair.add(8).readPointer();
            requireThat(!inner.isNull() && !control.isNull() && inner.equals(control.add(0x10)), 'factory_pair_mismatch');
            requireThat(inner.readPointer().equals(configured.base.add(VT.text)) && control.readPointer().equals(configured.base.add(VT.control)), 'factory_vtable_mismatch');
            requireThat(control.add(8).readU32() === 1 && control.add(12).readU32() === 2, 'factory_reference_mismatch');
            record.clientMessageId = readUuid(inner);
            constructionStep = 'assign_text';
            writeString(record, inner.add(0xb0), receiverBytes); writeString(record, inner.add(0x758), bytes);
            inner.add(0x118).writeU32(1); inner.add(0x1c8).writeU64(bytes.length);
            constructionStep = 'options_factory';
            requireThat(native('optionsConstructor', 'pointer', ['pointer', 'pointer', 'pointer', 'pointer', 'pointer', 'uint64'])(
                options, callbacks[0], callbacks[1], callbacks[2], weakPair, uint64(0)).equals(options), 'options_return_mismatch');
            const token = options.add(8).readPointer();
            requireThat(!token.isNull() && token.add(8).readU32() === 1 && token.add(12).readU32() === 1, 'options_reference_mismatch');
            const vector = zero(record, 16), arg = zero(record, 0x28);
            vector.writePointer(inner); vector.add(8).writePointer(control);
            arg.writePointer(configured.base.add(VT.param)); arg.add(8).writePointer(vector);
            arg.add(0x10).writePointer(vector.add(16)); arg.add(0x18).writePointer(vector.add(16)); arg.add(0x20).writeU64(1);
            record.payload = {pair, inner, control, options, token, vector, arg};
            constructionStep = 'full_payload_readback';
            const checks = inspectPayload(record); record.state = 'constructed';
            return result(record, {checks});
        } catch (error) {
            record.state = 'construction_failed'; phase = 'blocked';
            return result(record, {issueCode: 'native_construction_failed', constructionStep});
        }
    },
    submit(request) {
        authorize(request);
        const record = requests.get(request.requestId);
        requireThat(record && record === current && record.state === 'constructed' && !record.attempted, 'submission_already_consumed_or_not_constructed');
        requireThat(request.confirmed === true && request.targetId === record.targetId && request.text === record.text, 'explicit_confirmation_mismatch');
        requireThat(request.constructionId === record.constructionId, 'construction_mismatch');
        requireThat(JSON.stringify(freezeBinding(request.binding)) === JSON.stringify(configured.binding), 'source_binding_changed');
        validateLiveCode(); inspectPayload(record);
        record.attempted = true; record.state = 'attempted';
        try {
            native('sendMessage', 'void', ['pointer', 'pointer'])(record.payload.arg, record.payload.options);
        } catch (error) {
            record.state = 'unknown'; phase = 'blocked';
            return result(record, {nativeReturned: false, issueCode: 'native_call_outcome_unknown'});
        }
        record.state = 'submitted_unconfirmed';
        try {
            const release = native('releaseShared', 'void', ['pointer']);
            release(record.payload.control); release(record.payload.token);
            record.payload = null; record.roots = []; record.text = null;
            current = null;
            return result(record, {nativeReturned: true, callerReferencesReleased: true});
        } catch (error) {
            phase = 'blocked';
            return result(record, {nativeReturned: true, callerReferencesReleased: false, issueCode: 'native_cleanup_failed'});
        }
    },
    status(request) {
        authorize(request);
        const record = request.requestId ? requests.get(request.requestId) : null;
        requireThat(!request.requestId || record, 'unknown_request');
        return result(record, {requestCount: requests.size});
    }
};
