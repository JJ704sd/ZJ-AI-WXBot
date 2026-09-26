// One target-scoped sample; no changes to arguments and no native send calls.
const core = Process.getModuleByName('wechat');
const nf = (offset, result, args) => new NativeFunction(core.base.add(offset), result, args);
const create = nf(0x5bbcad0, 'pointer', ['pointer']);
const copy = nf(0x5bbcf18, 'void', ['pointer', 'pointer']);
const byteSize = nf(0x5bbce64, 'int', ['pointer']);
const serialize = nf(0x6b24ca4, 'pointer', ['pointer', 'pointer']);
const destroy = nf(0x5bbcaac, 'void', ['pointer']);
let captured = null, failure = null;
function readable(p, size) {
    if (p.isNull() || p.compare(ptr(0x10000)) < 0) return false;
    const r = Process.findRangeByAddress(p);
    return r !== null && r.protection[0] === 'r' && p.add(size).compare(r.base.add(r.size)) <= 0;
}
function pointerAt(p) {
    if (!readable(p, 8)) throw new Error('Unreadable known pointer slot');
    return p.readPointer();
}
function stringAt(p) {
    if (!readable(p, 24)) throw new Error('Unreadable string descriptor');
    const first = p.readU8();
    const n = first & 1 ? Number(p.add(8).readU64()) : first >>> 1;
    if (n > 1024 || (!(first & 1) && n > 22)) throw new Error('String length rejected');
    if (!n) return '';
    const data = first & 1 ? p.add(16).readPointer() : p.add(1);
    if (!readable(data, n)) throw new Error('Unreadable string data');
    return data.readUtf8String(n);
}
function fields(bytes) {
    let pos = 0;
    const result = {};
    function varint() {
        let value = 0, scale = 1;
        for (let i = 0; i < 10 && pos < bytes.length; i++) {
            const b = bytes[pos++];
            value += (b & 127) * scale;
            if (!(b & 128)) return value;
            scale *= 128;
        }
        throw new Error('Invalid wire varint');
    }
    while (pos < bytes.length) {
        const tag = varint(), field = Math.floor(tag / 8), wire = tag % 8;
        let value;
        if (wire === 0) value = varint();
        else if (wire === 2) {
            const size = varint();
            if (size > bytes.length - pos) throw new Error('Invalid wire length');
            value = bytes.slice(pos, pos + size); pos += size;
        } else throw new Error('Unexpected wire type');
        (result[field] ||= []).push(value);
    }
    return result;
}
const ascii = bytes => String.fromCharCode(...bytes);
function codeOffset(p) {
    if (p.compare(core.base) < 0 || p.compare(core.base.add(core.size)) >= 0)
        throw new Error('Expected code/data within fixed client module');
    return p.sub(core.base).toString();
}
Interceptor.attach(core.base.add(0x4f65f78), {
    onEnter(args) {
        if (captured || failure) return;
        let own = ptr(0);
        try {
            if (!pointerAt(args[1]).equals(core.base.add(0x7fbab38))) return;
            own = create(ptr(0)); copy(own, args[1]);
            const size = byteSize(own);
            if (size < 1 || size > 8192) throw new Error('Request size rejected');
            const out = Memory.alloc(size);
            if (!serialize(own, out).equals(out.add(size))) throw new Error('Serialization end mismatch');
            const bytes = Array.from(new Uint8Array(out.readByteArray(size)));
            const request = fields(bytes);
            if (request[1]?.[0] !== 1 || request[2]?.length !== 1) return;
            const message = fields(request[2][0]);
            const to = ascii(fields(message[1][0])[1][0]);
            const text = ascii(message[2][0]);
            if (to !== '48437025209@chatroom' || !text.includes('NATIVE-CAL-004')) return;
            const serviceVtable = pointerAt(args[0]);
            const callback = pointerAt(args[4].add(0x20));
            const callbackVtable = pointerAt(callback);
            captured = {
                event: 'captured', pid: Process.id, moduleBase: core.base.toString(),
                thread: Process.getCurrentThreadId(), service: args[0].toString(),
                serviceVtable: codeOffset(serviceVtable),
                submitFunction: codeOffset(pointerAt(serviceVtable.add(0x28))),
                x2: stringAt(args[2]), cgiOverride: stringAt(args[3].add(8)),
                callbackVtable: codeOffset(callbackVtable),
                callbackSlots: Array.from({length:9}, (_,i) => codeOffset(pointerAt(callbackVtable.add(i*8)))),
                requestBytes: bytes
            };
            send({event:'captured',bytes:size,thread:captured.thread});
        } catch (error) {
            failure = String(error);
            send({event:'captureFailed',reason:failure});
        } finally {
            if (!own.isNull()) destroy(own);
        }
    }
});
rpc.exports.result = () => ({ captured, failure });
send({event:'ready'});
