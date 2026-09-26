// Synthetic RPC/attempt-boundary tests only. This never loads Frida or Weixin.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync(__dirname + '/native_send_once.js', 'utf8');
const prefix = {
    textFactory: '555657534883ec38488d6c243048c74500feffffff4889ceb9a8070000e80a6c',
    textConstructor: '5556574883ec50488d6c245048c745f8feffffff4889ce488d7dd84889f9e8ed',
    optionsConstructor: '554157415641545657534883ec40488d6c244048c745f8feffffff4c894de84c',
    sendMessage: '5541565657534881ece0010000488dac248000000048c78558010000feffffff'
};
function fixture(failAt = null) {
    const segments = [], calls = [], baseAddress = 0x180000000n;
    let nextAddress = 0x100000n;
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
    function allocate(size) { const result = mapped(nextAddress, size); nextAddress += BigInt(size + 16); return result; }
    const base = new Pointer(baseAddress);
    const entry = {textFactory: 0x6f4c70, textConstructor: 0x766680, optionsConstructor: 0xf910, sendMessage: 0x19d0bc0};
    for (const [name, offset] of Object.entries(entry)) mapped(baseAddress + BigInt(offset), 32).writeByteArray(Buffer.from(prefix[name], 'hex'));
    mapped(baseAddress + 0x9112318n, 8).writePointer(base.add(entry.sendMessage));
    function native(address) {
        const rva = Number(address.value - baseAddress);
        return (...args) => {
            calls.push(rva);
            if (failAt === rva) throw new Error('synthetic native fault with private address');
            if (rva === entry.textFactory) {
                const control = allocate(0x7a8), inner = control.add(16), out = args[0];
                control.writePointer(base.add(0x8e534f8)); control.add(8).writeU32(1); control.add(12).writeU32(2);
                inner.writePointer(base.add(0x8e53588)); inner.add(8).writePointer(inner); inner.add(16).writePointer(control);
                for (const offset of [0xb0, 0x758, 0x778]) inner.add(offset + 0x18).writeU64(15);
                inner.add(0x708).writeU64(36);
                out.writePointer(inner); out.add(8).writePointer(control); return out;
            }
            if (rva === entry.optionsConstructor) {
                const out = args[0], token = allocate(24);
                token.writePointer(base.add(0x8d47048)); token.add(8).writeU32(1); token.add(12).writeU32(1);
                out.writePointer(token.add(16)); out.add(8).writePointer(token); return out;
            }
            assert.equal(rva, entry.sendMessage);
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
    return {api: context.rpc.exports, calls, config, nonce, binding, entry, corruptCode: () => base.add(entry.sendMessage).writeByteArray(new Uint8Array(32))};
}

let tests = 0;
function test(name, run) { run(); tests++; console.log('PASS ' + name); }
test('load and configure never call native functions', () => {
    const f = fixture(); assert.equal(f.calls.length, 0);
    assert.equal(f.api.configure(f.config).state, 'configured'); assert.equal(f.calls.length, 0);
    assert.throws(() => f.api.submit({nonce: f.nonce}), /not_constructed/); assert.equal(f.calls.length, 0);
});
test('unsupported hash and changed live code refuse configuration', () => {
    const bad = fixture(); bad.config.profile.moduleSha256 = '0'.repeat(64);
    assert.throws(() => bad.api.configure(bad.config), /unsupported_profile/); assert.equal(bad.calls.length, 0);
    const changed = fixture(); changed.corruptCode();
    assert.throws(() => changed.api.configure(changed.config), /live_code_mismatch/); assert.equal(changed.calls.length, 0);
});
test('construction alone never calls send; frozen account and target guard final submit', () => {
    const f = fixture(); f.api.configure(f.config); const built = f.api.construct({nonce: f.nonce});
    assert.equal(built.state, 'constructed'); assert.equal(built.sendCalled, false); assert.equal(f.calls.length, 2);
    assert.throws(() => f.api.construct({nonce: f.nonce}), /consumed/);
    const request = {nonce: f.nonce, constructionId: built.constructionId, binding: f.binding, confirmed: true, targetId: 'filehelper', text: 'WB-HOOK-0926'};
    assert.throws(() => f.api.submit({...request, targetId: 'someone'}), /confirmation_mismatch/);
    assert.throws(() => f.api.submit({...request, binding: {...f.binding, selfId: 'wxid_changed'}}), /source_binding_changed/);
    assert.equal(f.calls.length, 2); assert.equal(f.api.submit(request).state, 'submitted_unconfirmed');
    assert.throws(() => f.api.submit(request), /consumed/); assert.equal(f.calls.length, 3);
});
test('native send fault becomes unknown and cannot retry or disclose raw exception', () => {
    const f = fixture(0x19d0bc0); f.api.configure(f.config); const built = f.api.construct({nonce: f.nonce});
    const request = {nonce: f.nonce, constructionId: built.constructionId, binding: f.binding, confirmed: true, targetId: 'filehelper', text: 'WB-HOOK-0926'};
    const outcome = f.api.submit(request);
    assert.equal(outcome.state, 'unknown'); assert.equal(outcome.submissionAttempted, true); assert.equal(outcome.delivered, false);
    assert.doesNotMatch(JSON.stringify(outcome), /private address/); assert.throws(() => f.api.submit(request), /consumed/);
});
test('partial constructor failure is terminal without send or raw exception', () => {
    const f = fixture(0xf910); f.api.configure(f.config); const outcome = f.api.construct({nonce: f.nonce});
    assert.equal(outcome.state, 'construction_failed'); assert.equal(outcome.constructionStep, 'options_factory');
    assert.equal(outcome.sendCalled, false); assert.doesNotMatch(JSON.stringify(outcome), /private address/);
    assert.throws(() => f.api.construct({nonce: f.nonce}), /consumed/); assert.equal(f.calls.length, 2);
});
console.log(`${tests} synthetic contract checks passed; no real process accessed.`);
