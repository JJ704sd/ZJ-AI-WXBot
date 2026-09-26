/*
 * Explicit, single-message research harness for the exact inspected x64 DLL.
 * Loading/configuring this script never calls a native function or sends.
 * construct() DOES call native constructors and allocate inside Weixin. It is
 * not a read-only probe. submit() is separate and may run at most once.
 *
 * The trusted host must verify the DLL file hash, process creation time and
 * account's database ownership immediately before configure AND submit. They
 * cannot be independently established by this script's field checks. Never
 * expose these RPCs directly as unauthenticated/browser-controlled arguments.
 *
 * Ownership: factory 6F4C70 allocates the native shared_ptr payload/control.
 * F910 allocates the native cancellation token. These original references are
 * intentionally retained until process exit for this ONE bounded PoC; no
 * guessed destructor/free is called. Memory.alloc buffers are only input
 * wrappers; 19D0BC0 copies both vector and options into native-owned memory
 * before returning (5F2B0 increases token refs; vector copy increases refs).
 * No native code receives a Frida allocation it is expected to free.
 * The script must stay loaded through the synchronous submit RPC. No callback,
 * hook, automatic retry, account scan, UI manipulation or automatic send exists.
 *
 * Static evidence: evidence/windows-text-layout-2026-09-26/ and
 * evidence/windows-hook-send-offline-findings.md. Current-thread calling is
 * supported by the old reference's worker-thread entry, but must still be
 * validated dynamically for this DLL. Returning from send is NOT an ACK.
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
    sendMessage: {rva: 0x19d0bc0, bytes: '5541565657534881ece0010000488dac248000000048c78558010000feffffff'}
});
const VT = Object.freeze({text: 0x8e53588, control: 0x8e534f8, param: 0x9112308, token: 0x8d47048});
const TARGET = 'filehelper';
const TEXT = 'WB-HOOK-0926';
const roots = []; // Keep every Frida-owned input buffer alive across RPC calls.
let phase = 'disabled', configured = null, payload = null, attempted = false;
let constructionStarted = false, nativeFunctionsCalled = false;

function requireThat(ok, code) { if (!ok) throw new Error(code); }
function normalizedPath(value) { return String(value || '').replace(/\//g, '\\').toLowerCase(); }
function hex(address, size) {
    return Array.from(new Uint8Array(address.readByteArray(size)), b => b.toString(16).padStart(2, '0')).join('');
}
function zero(size) {
    const result = Memory.alloc(size);
    result.writeByteArray(new Uint8Array(size));
    roots.push(result);
    return result;
}
function uintEquals(address, value) { return address.readU64().toString() === String(value); }
function freezeBinding(value) {
    requireThat(value && value.pid === Process.id && Number.isInteger(value.pid), 'process_mismatch');
    requireThat(typeof value.processStarted === 'string' && /^\d{16,20}$/.test(value.processStarted), 'invalid_process_identity');
    requireThat(typeof value.selfId === 'string' && /^wxid_[A-Za-z0-9_]+$/.test(value.selfId), 'invalid_account_identity');
    requireThat(typeof value.sourceRoot === 'string' && /^[A-Za-z]:\\/.test(value.sourceRoot), 'invalid_source_identity');
    for (const key of ['clientVersion', 'arch', 'moduleSha256']) {
        requireThat(value[key] === PROFILE[key], 'binding_profile_mismatch');
    }
    return Object.freeze({pid: value.pid, processStarted: value.processStarted,
        selfId: value.selfId, sourceRoot: normalizedPath(value.sourceRoot),
        clientVersion: value.clientVersion, arch: value.arch, moduleSha256: value.moduleSha256});
}
function sameBinding(value) { return JSON.stringify(freezeBinding(value)) === JSON.stringify(configured.binding); }
function authorize(request) {
    requireThat(configured !== null && request && request.nonce === configured.nonce, 'not_authorized');
}
function validateLiveCode() {
    requireThat(Process.platform === 'windows' && Process.arch === 'x64' && Process.pointerSize === 8, 'unsupported_platform');
    requireThat(Process.id === configured.binding.pid, 'process_mismatch');
    const module = Process.getModuleByName(PROFILE.moduleName);
    requireThat(module.base.equals(configured.base) && normalizedPath(module.path) === configured.modulePath, 'module_changed');
    for (const item of Object.values(ENTRY)) {
        const address = module.base.add(item.rva);
        const range = Process.findRangeByAddress(address);
        requireThat(range !== null && range.protection.includes('x') && hex(address, 32) === item.bytes, 'live_code_mismatch');
    }
    requireThat(module.base.add(VT.param + 0x10).readPointer().equals(module.base.add(ENTRY.sendMessage.rva)), 'dispatch_vtable_mismatch');
}
function emptySso(address) {
    return uintEquals(address.add(0x10), 0) && uintEquals(address.add(0x18), 15) && address.readU8() === 0;
}
function writeSso(address, value) {
    requireThat(emptySso(address) && /^[\x20-\x7e]{1,15}$/.test(value), 'nonempty_or_non_sso_field');
    const bytes = new Uint8Array(16);
    for (let i = 0; i < value.length; i++) bytes[i] = value.charCodeAt(i);
    address.writeByteArray(bytes);
    address.add(0x10).writeU64(value.length);
    // The constructor's capacity remains 15. No string heap allocator needed.
}
function matchesSso(address, value) {
    return uintEquals(address.add(0x10), value.length) && uintEquals(address.add(0x18), 15) &&
        address.readUtf8String(value.length) === value && address.add(value.length).readU8() === 0;
}
function inspectPayload() {
    const p = payload, base = configured.base;
    const checks = {
        pointerPair: p.inner.equals(p.control.add(0x10)) && p.pair.readPointer().equals(p.inner) && p.pair.add(8).readPointer().equals(p.control),
        contentVtable: p.inner.readPointer().equals(base.add(VT.text)),
        controlVtable: p.control.readPointer().equals(base.add(VT.control)),
        weakSelfReference: p.inner.add(8).readPointer().equals(p.inner) && p.inner.add(0x10).readPointer().equals(p.control),
        receiver: matchesSso(p.inner.add(0xb0), TARGET),
        content: matchesSso(p.inner.add(0x758), TEXT),
        messageType: p.inner.add(0x118).readU32() === 1 && p.inner.add(0x11c).readU32() === 0,
        messageLength: uintEquals(p.inner.add(0x1c8), TEXT.length),
        emptyAtList: emptySso(p.inner.add(0x778)),
        tokenPair: p.options.readPointer().equals(p.token.add(0x10)) && p.token.readPointer().equals(base.add(VT.token)) && p.token.add(0x10).readU8() === 0,
        emptyCallbacks: [0x48, 0x88, 0xc8, 0xd8, 0xe0].every(offset => p.options.add(offset).readPointer().isNull()) && uintEquals(p.options.add(0xd0), 0),
        vector: p.arg.readPointer().equals(base.add(VT.param)) && p.arg.add(8).readPointer().equals(p.vector) &&
            p.arg.add(0x10).readPointer().equals(p.vector.add(16)) && p.arg.add(0x18).readPointer().equals(p.vector.add(16)) && uintEquals(p.arg.add(0x20), 1) &&
            p.vector.readPointer().equals(p.inner) && p.vector.add(8).readPointer().equals(p.control)
    };
    requireThat(Object.values(checks).every(Boolean), 'constructed_payload_mismatch');
    return checks;
}
function result(extra) {
    return Object.assign({state: phase, submissionAttempted: attempted, sendCalled: attempted,
        nativeFunctionsCalled: nativeFunctionsCalled, targetId: TARGET, textLength: TEXT.length,
        serverAccepted: false, localRecordConfirmed: false, delivered: false, retryAllowed: false}, extra || {});
}

rpc.exports = {
    configure(request) {
        requireThat(phase === 'disabled' && configured === null, 'already_configured');
        requireThat(request && /^[A-Za-z0-9_-]{32,128}$/.test(request.nonce || ''), 'invalid_nonce');
        const profile = request.profile;
        requireThat(profile && Object.keys(PROFILE).every(key => profile[key] === PROFILE[key]), 'unsupported_profile');
        requireThat(profile.expectedCode && Object.entries(ENTRY).every(([name, entry]) => profile.expectedCode[name] === entry.bytes), 'invalid_code_attestation');
        requireThat(typeof profile.modulePath === 'string' && /^[A-Za-z]:\\/.test(profile.modulePath), 'invalid_module_path');
        const binding = freezeBinding(request.binding);
        const module = Process.getModuleByName(PROFILE.moduleName);
        configured = Object.freeze({binding, nonce: request.nonce, base: module.base, modulePath: normalizedPath(profile.modulePath)});
        try { validateLiveCode(); } catch (error) { phase = 'blocked'; throw error; }
        phase = 'configured';
        return result({configured: true, nativeAllocationRetained: false});
    },
    construct(request) {
        authorize(request);
        requireThat(phase === 'configured' && !constructionStarted, 'construction_already_consumed');
        validateLiveCode();
        constructionStarted = true;
        phase = 'constructing';
        let constructionStep = 'allocate_wrappers';
        try {
            // These buffers are call parameters, NOT native-owned payloads.
            const pair = zero(16), options = zero(0xe8);
            const callbacks = [zero(0x40), zero(0x40), zero(0x40)], weakPair = zero(16);
            const factory = new NativeFunction(configured.base.add(ENTRY.textFactory.rva), 'pointer', ['pointer'], 'win64');
            nativeFunctionsCalled = true;
            constructionStep = 'text_factory';
            requireThat(factory(pair).equals(pair), 'factory_return_mismatch');
            constructionStep = 'text_factory_readback';
            const inner = pair.readPointer(), control = pair.add(8).readPointer();
            requireThat(!inner.isNull() && !control.isNull() && inner.equals(control.add(0x10)), 'factory_pair_mismatch');
            requireThat(inner.readPointer().equals(configured.base.add(VT.text)) && control.readPointer().equals(configured.base.add(VT.control)), 'factory_vtable_mismatch');
            requireThat(control.add(8).readU32() === 1 && control.add(12).readU32() === 2, 'factory_reference_mismatch');
            requireThat(inner.add(0x11c).readU32() === 0, 'message_subtype_mismatch');
            const uuidLength = inner.add(0x708).readU64().toNumber();
            requireThat(uuidLength > 0 && uuidLength <= 128, 'factory_uuid_missing');
            constructionStep = 'write_inline_fields';
            writeSso(inner.add(0xb0), TARGET);
            writeSso(inner.add(0x758), TEXT);
            inner.add(0x118).writeU32(1);
            inner.add(0x1c8).writeU64(TEXT.length);
            const makeOptions = new NativeFunction(configured.base.add(ENTRY.optionsConstructor.rva), 'pointer',
                ['pointer', 'pointer', 'pointer', 'pointer', 'pointer', 'uint64'], 'win64');
            constructionStep = 'options_factory';
            requireThat(makeOptions(options, callbacks[0], callbacks[1], callbacks[2], weakPair, uint64(0)).equals(options), 'options_return_mismatch');
            constructionStep = 'options_readback';
            const token = options.add(8).readPointer();
            requireThat(!token.isNull() && token.add(8).readU32() === 1 && token.add(12).readU32() === 1, 'options_reference_mismatch');
            const vector = zero(16), arg = zero(0x28);
            vector.writePointer(inner); vector.add(8).writePointer(control);
            arg.writePointer(configured.base.add(VT.param));
            arg.add(8).writePointer(vector); arg.add(0x10).writePointer(vector.add(16));
            arg.add(0x18).writePointer(vector.add(16)); arg.add(0x20).writeU64(1);
            payload = {pair, inner, control, options, token, vector, arg};
            constructionStep = 'full_payload_readback';
            const checks = inspectPayload();
            phase = 'constructed';
            return result({constructionId: configured.nonce.slice(0, 24) + ':1', checks,
                generatedUuidLength: uuidLength, nativeAllocationRetained: true});
        } catch (error) {
            phase = 'construction_failed';
            // Never guess cleanup after a partial native constructor failure.
            const safeCodes = ['factory_return_mismatch', 'factory_pair_mismatch', 'factory_vtable_mismatch',
                'factory_reference_mismatch', 'message_subtype_mismatch', 'factory_uuid_missing',
                'nonempty_or_non_sso_field', 'options_return_mismatch', 'options_reference_mismatch', 'constructed_payload_mismatch'];
            return result({issueCode: 'native_construction_failed', constructionStep,
                failedCheck: safeCodes.includes(error.message) ? error.message : 'native_exception', nativeAllocationRetained: true});
        }
    },
    submit(request) {
        authorize(request);
        requireThat(phase === 'constructed' && !attempted, 'submission_already_consumed_or_not_constructed');
        requireThat(request.confirmed === true && request.targetId === TARGET && request.text === TEXT, 'explicit_confirmation_mismatch');
        requireThat(request.constructionId === configured.nonce.slice(0, 24) + ':1', 'construction_mismatch');
        requireThat(sameBinding(request.binding), 'source_binding_changed');
        validateLiveCode();
        inspectPayload();
        // The HOST must durably mark this attempt before entering this RPC.
        // This latch is additional in-session protection, not crash persistence.
        attempted = true;
        phase = 'attempted';
        try {
            const submitNative = new NativeFunction(configured.base.add(ENTRY.sendMessage.rva), 'void', ['pointer', 'pointer'], 'win64');
            submitNative(payload.arg, payload.options);
            phase = 'submitted_unconfirmed';
            return result({nativeReturned: true, nativeAllocationRetained: true});
        } catch (error) {
            phase = 'unknown';
            return result({nativeReturned: false, issueCode: 'native_call_outcome_unknown', nativeAllocationRetained: true});
        }
    },
    status(request) { authorize(request); return result({nativeAllocationRetained: constructionStarted}); }
};
