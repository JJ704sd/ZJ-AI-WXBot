// Synthetic RPC/attempt-boundary tests only. This never loads Frida or Weixin.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync(__dirname + '/native_send_text.js', 'utf8');
const prefix = {
    textFactory: '555657534883ec38488d6c243048c74500feffffff4889ceb9a8070000e80a6c',
    textConstructor: '5556574883ec50488d6c245048c745f8feffffff4889ce488d7dd84889f9e8ed',
    optionsConstructor: '554157415641545657534883ec40488d6c244048c745f8feffffff4c894de84c',
    sendMessage: '5541565657534881ece0010000488dac248000000048c78558010000feffffff',
    stringAssign: '4157415641545657534883ec284885d20f88e50000004c89cb4889d74889ce4c',
    releaseShared: '564883ec204885c97423f0ff4908751d488b014889ceff10f0ff4e0c750f488b'
};
function fixture(failAt = null) {
    const segments = [], calls = [], baseAddress = 0x180000000n;
    let nextAddress = 0x100000n, uuidCounter = 0;
    const submitted = [], allocations = new Map(), released = [];
    class Pointer {
        constructor(value) { this.value = BigInt(value); }
        add(value) { return new Pointer(this.value + BigInt(value)); }
        equals(other) { return other instanceof Pointer && this.value === other.value; }
        isNull() { return this.value === 0n; }
        bytes(size) {
            const segment = segments.find(item => this.value >= item.start && this.value + BigInt(size) <= item.start + BigInt(item.data.length));
            if (!segment) throw new Error('synthetic invalid address');
            const offset = Number(this.value - segment.start);
            return segment.data.subarray(offset, offset + size);
        }
        readByteArray(size) { return Uint8Array.from(this.bytes(size)).buffer; }
        writeByteArray(value) { this.bytes(value.length).set(value); }
        readU8() { return this.bytes(1)[0]; }
        readU32() { return this.bytes(4).readUInt32LE(); }
        writeU32(value) { this.bytes(4).writeUInt32LE(value); }
        readU64() { const value = this.bytes(8).readBigUInt64LE(); return {toString: () => String(value), toNumber: () => Number(value)}; }
        writeU64(value) { this.bytes(8).writeBigUInt64LE(BigInt(value)); }
        readPointer() { return new Pointer(this.bytes(8).readBigUInt64LE()); }
        writePointer(value) { this.writeU64(value.value); }
        readUtf8String(size) { return this.bytes(size).toString('utf8'); }
    }
    function mapped(address, size) {
        segments.push({start: BigInt(address), data: Buffer.alloc(size)});
        return new Pointer(address);
    }
    function allocate(size, owner = 'frida') { const result = mapped(nextAddress, size); allocations.set(String(result.value), owner); nextAddress += BigInt(size + 16); return result; }
    const base = new Pointer(baseAddress);
    const entry = {textFactory: 0x6f4c70, textConstructor: 0x766680, optionsConstructor: 0xf910, sendMessage: 0x19d0bc0, stringAssign: 0x3e150, releaseShared: 0x53120};
    for (const [name, offset] of Object.entries(entry)) mapped(baseAddress + BigInt(offset), 32).writeByteArray(Buffer.from(prefix[name], 'hex'));
    mapped(baseAddress + 0x9112318n, 8).writePointer(base.add(entry.sendMessage));
    function native(address) {
        const rva = Number(address.value - baseAddress);
        return (...args) => {
            calls.push(rva);
            if (failAt === rva) throw new Error('synthetic native fault with private address');
            if (rva === entry.textFactory) {
                const control = allocate(0x7a8, 'native'), inner = control.add(16), out = args[0];
                control.writePointer(base.add(0x8e534f8)); control.add(8).writeU32(1); control.add(12).writeU32(2);
                inner.writePointer(base.add(0x8e53588)); inner.add(8).writePointer(inner); inner.add(16).writePointer(control);
                for (const offset of [0xb0, 0x758, 0x778]) inner.add(offset + 0x18).writeU64(15);
                const uuid = 'aaaaaaaa-bbbb-4ccc-8ddd-' + String(++uuidCounter).padStart(12, '0');
                const uuidData = allocate(48, 'native'); uuidData.writeByteArray(Buffer.from(uuid + '\0'));
                inner.add(0x6f8).writePointer(uuidData); inner.add(0x708).writeU64(36); inner.add(0x710).writeU64(47);
                out.writePointer(inner); out.add(8).writePointer(control); return out;
            }
            if (rva === entry.optionsConstructor) {
                const out = args[0], token = allocate(24, 'native');
                token.writePointer(base.add(0x8d47048)); token.add(8).writeU32(1); token.add(12).writeU32(1);
                out.writePointer(token.add(16)); out.add(8).writePointer(token); return out;
            }
            if (rva === entry.stringAssign) {
                const [out, length, unused, source] = args, size = Number(length), capacity = size | 15;
                assert.equal(unused, 0n);
                const storage = allocate(capacity + 1, 'native');
                storage.writeByteArray(new Uint8Array(source.readByteArray(size + 1)));
                out.writePointer(storage); out.add(0x10).writeU64(size); out.add(0x18).writeU64(capacity);
                return out;
            }
            if (rva === entry.releaseShared) {
                const control = args[0]; assert.equal(allocations.get(String(control.value)), 'native');
                const count = control.add(8).readU32(); assert.ok(count >= 2, 'queued task owns another reference');
                control.add(8).writeU32(count - 1); released.push(control); return;
            }
            assert.equal(rva, entry.sendMessage);
            const vector = args[0].add(8).readPointer(), inner = vector.readPointer(), control = vector.add(8).readPointer();
            const token = args[1].add(8).readPointer(), text = inner.add(0x758);
            const length = text.add(0x10).readU64().toNumber(), capacity = text.add(0x18).readU64().toNumber();
            const data = capacity < 16 ? text : text.readPointer();
            if (capacity >= 16) assert.equal(allocations.get(String(data.value)), 'native');
            submitted.push({text: data.readUtf8String(length), length: inner.add(0x1c8).readU64().toNumber()});
            control.add(8).writeU32(control.add(8).readU32() + 1);
            token.add(8).writeU32(token.add(8).readU32() + 1);
        };
    }
    const modulePath = 'D:\\Program Files\\Tencent\\Weixin\\4.1.15.13\\Weixin.dll';
    const context = {
        rpc: {exports: {}}, Memory: {alloc: allocate}, uint64: value => BigInt(value), NativeFunction: native,
        Process: {id: 123, platform: 'windows', arch: 'x64', pointerSize: 8,
            getModuleByName: () => ({base, path: modulePath}), findRangeByAddress: () => ({protection: 'r-x'})}
    };
    vm.runInNewContext(source, context);
    const binding = {pid: 123, processStarted: '134348766812095580', selfId: 'wxid_synthetic', sourceRoot: 'D:\\synthetic\\db_storage',
        clientVersion: '4.1.15.13', arch: 'x64', moduleSha256: '10f8e995453e2da46d4f2b5080cd6da1f13cc5147746adc119ceae38cb039de5'};
    const nonce = 'syntheticnonce01234567890123456789';
    const config = {profile: {clientVersion: binding.clientVersion, arch: binding.arch, moduleName: 'Weixin.dll', moduleSha256: binding.moduleSha256,
        modulePath, expectedCode: {...prefix}}, binding, nonce};
    return {api: context.rpc.exports, calls, config, nonce, binding, entry, submitted, released, corruptCode: () => base.add(entry.sendMessage).writeByteArray(new Uint8Array(32))};
}

let tests = 0;
function test(name, run) { run(); tests++; console.log('PASS ' + name); }
function construct(f, requestId, text, targetId = 'filehelper') { return f.api.construct({nonce: f.nonce, requestId, targetId, text}); }
function submit(f, built, text) { return f.api.submit({nonce: f.nonce, requestId: built.requestId,
    constructionId: built.constructionId, binding: f.binding, confirmed: true, targetId: built.targetId, text}); }
test('configure does not construct or send', () => {
    const f = fixture(); assert.equal(f.api.configure(f.config).ready, true); assert.equal(f.calls.length, 0);
});
test('Chinese, newline and emoji use native string ownership and UTF8 message length', () => {
    const f = fixture(); f.api.configure(f.config); const text = 'WeBridge中文收发\n第二行🙂';
    const built = construct(f, 'first', text);
    assert.equal(built.state, 'constructed'); assert.equal(built.sendCalled, false);
    assert.equal(Object.keys(built.checks).length, 12); assert.ok(Object.values(built.checks).every(Boolean));
    assert.match(built.clientMessageId, /^aaaaaaaa-bbbb-4ccc-8ddd-/);
    assert.equal(built.utf8Bytes, Buffer.byteLength(text));
    const sent = submit(f, built, text);
    assert.equal(sent.state, 'submitted_unconfirmed'); assert.equal(sent.nativeAllocationRetained, false);
    assert.equal(sent.callerReferencesReleased, true); assert.equal(f.released.length, 2);
    assert.deepEqual(f.submitted, [{text, length: Buffer.byteLength(text)}]);
});
test('second request sends independently while consumed request cannot repeat', () => {
    const f = fixture(); f.api.configure(f.config);
    const a = construct(f, 'a', 'short'); submit(f, a, 'short');
    assert.throws(() => submit(f, a, 'short'), /consumed/);
    assert.throws(() => construct(f, 'a', 'short'), /consumed/);
    const b = construct(f, 'b', '第二次文本'); submit(f, b, '第二次文本');
    assert.notEqual(a.clientMessageId, b.clientMessageId); assert.notEqual(a.constructionId, b.constructionId);
    assert.equal(f.submitted.length, 2); assert.equal(f.released.length, 4);
    assert.equal(f.api.status({nonce: f.nonce}).ready, true);
});
test('2000 Chinese characters delegate >4096-byte storage to the native allocator', () => {
    const f = fixture(); f.api.configure(f.config); const text = '中'.repeat(2000);
    const built = construct(f, 'long', text); assert.equal(built.utf8Bytes, 6000);
    assert.ok(f.calls.includes(f.entry.stringAssign)); submit(f, built, text);
    assert.equal(f.submitted[0].text, text); assert.equal(f.submitted[0].length, 6000);
});
test('long chatroom receiver uses native heap storage and remains frozen after construction', () => {
    const f = fixture(); f.api.configure(f.config);
    const targetId = '12345678901234567890@chatroom', text = 'room test';
    const built = construct(f, 'room', text, targetId);
    assert.equal(built.state, 'constructed'); assert.equal(built.targetId, targetId); assert.equal(built.checks.receiver, true);
    assert.equal(f.calls.filter(rva => rva === f.entry.stringAssign).length, 1);
    assert.throws(() => f.api.submit({nonce: f.nonce, requestId: built.requestId, constructionId: built.constructionId,
        binding: f.binding, confirmed: true, targetId: 'filehelper', text}), /confirmation_mismatch/);
    assert.equal(f.submitted.length, 0);
    const sent = submit(f, built, text); assert.equal(sent.targetId, targetId); assert.equal(sent.state, 'submitted_unconfirmed');
});
test('unknown native outcome consumes request and stops subsequent construction', () => {
    const f = fixture(0x19d0bc0); f.api.configure(f.config); const built = construct(f, 'fault', 'hello');
    const outcome = submit(f, built, 'hello');
    assert.equal(outcome.state, 'unknown'); assert.equal(outcome.submissionAttempted, true);
    assert.equal(outcome.nativeAllocationRetained, true); assert.equal(f.released.length, 0);
    assert.throws(() => submit(f, built, 'hello'), /consumed/);
    assert.throws(() => construct(f, 'later', 'hello'), /not_ready/);
});
console.log(`${tests} synthetic native contract checks passed; no real process accessed.`);
