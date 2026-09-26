// No send/service/UI calls. Exercise only independently owned protobuf objects.
const core = Process.getModuleByName('wechat');
const expectedVtable = core.base.add(0x7fbab38);
const nf = (offset, result, args) => new NativeFunction(core.base.add(offset), result, args);
const create = nf(0x5bbcad0, 'pointer', ['pointer']);
const parse = nf(0x6b24b94, 'uint', ['pointer', 'pointer', 'int']);
const initialized = nf(0x5bbcf58, 'uint', ['pointer']);
const byteSize = nf(0x5bbce64, 'int', ['pointer']);
const serialize = nf(0x6b24ca4, 'pointer', ['pointer', 'pointer']);
const copy = nf(0x5bbcf18, 'void', ['pointer', 'pointer']);
const destroy = nf(0x5bbcaac, 'void', ['pointer']);

rpc.exports.roundtrip = function (bytes) {
    if (Process.arch !== 'arm64' || bytes.length < 1 || bytes.length > 8192)
        throw new Error('Architecture or input bounds rejected');
    const input = Memory.alloc(bytes.length);
    input.writeByteArray(bytes);
    let source = ptr(0), duplicate = ptr(0), malformed = ptr(0);
    const result = { sent: false, inputBytes: bytes.length };
    try {
        source = create(ptr(0));
        if (source.isNull() || !source.readPointer().equals(expectedVtable))
            throw new Error('Unexpected allocated message type');
        result.parsed = parse(source, input, bytes.length) === 1;
        result.initialized = initialized(source) === 1;
        if (!result.parsed || !result.initialized) throw new Error('Valid request rejected');
        duplicate = create(ptr(0));
        if (duplicate.isNull() || !duplicate.readPointer().equals(expectedVtable))
            throw new Error('Unexpected duplicate message type');
        copy(duplicate, source);
        destroy(source);
        source = ptr(0);
        result.sourceDestroyedBeforeSerialize = true;
        const size = byteSize(duplicate);
        if (size < 1 || size > 8192) throw new Error('Output bounds rejected');
        const output = Memory.alloc(size);
        const end = serialize(duplicate, output);
        result.outputBytes = size;
        result.returnedEndMatches = end.equals(output.add(size));
        const actual = new Uint8Array(output.readByteArray(size));
        result.byteExactAfterDeepCopy = actual.length === bytes.length &&
            actual.every((value, index) => value === bytes[index]);
        malformed = create(ptr(0));
        result.truncatedInputRejected = parse(malformed, input, bytes.length - 1) === 0;
        result.passed = result.returnedEndMatches && result.byteExactAfterDeepCopy &&
            result.truncatedInputRejected;
        return result;
    } finally {
        if (!malformed.isNull()) destroy(malformed);
        if (!duplicate.isNull()) destroy(duplicate);
        if (!source.isNull()) destroy(source);
    }
};
