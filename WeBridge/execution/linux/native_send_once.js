// Exact-build, single-message PoC. No window, keyboard, pointer, or clipboard API.
const core = Process.getModuleByName('wechat');
const native = (offset, result, args) => new NativeFunction(core.base.add(offset), result, args);
const create = native(0x5bbcad0, 'pointer', ['pointer']);
const parse = native(0x6b24b94, 'uint', ['pointer','pointer','int']);
const destroy = native(0x5bbcaac, 'void', ['pointer']);
const submit = native(0x4f65f78, 'uint', ['pointer','pointer','pointer','pointer','pointer']);
let attempted = false, completion = null;
function readPointer(p) {
    const range=Process.findRangeByAddress(p);
    if(!range || range.protection[0]!=='r' || p.add(8).compare(range.base.add(range.size))>0)
        throw new Error('Known pointer slot is not fully readable');
    return p.readPointer();
}
function serviceNow() {
    const owner=readPointer(core.base.add(0x82bb2a8));
    const ownerVtable=readPointer(owner);
    if(!ownerVtable.equals(core.base.add(0x7f01f48)) ||
       !readPointer(ownerVtable.add(0x18)).equals(core.base.add(0x4830994)))
        throw new Error('Owner/getter mismatch');
    const service=readPointer(owner.add(0x250));
    const vtable=readPointer(service);
    if(!vtable.equals(core.base.add(0x7fb98f0)) ||
       !readPointer(vtable.add(0x28)).equals(core.base.add(0x5ba9164)) ||
       !readPointer(core.base.add(0x81f79b8)).equals(core.base.add(0x6b4e508)))
        throw new Error('Service/dispatch mismatch');
    return service;
}
function loadCompletion() {
    const dlopen=new NativeFunction(Module.getGlobalExportByName('dlopen'),'pointer',['pointer','int']);
    // GNU RTLD_NOW | RTLD_NODELETE. The callback survives script unloading.
    const handle=dlopen(Memory.allocUtf8String('/tmp/libwechat_lab_completion.so'),0x1002);
    if(handle.isNull()) throw new Error('Completion library load failed');
    const lib=Process.getModuleByName('libwechat_lab_completion.so');
    const fn=(name,result,args)=>new NativeFunction(lib.getExportByName(name),result,args);
    const configure=fn('lab_configure','int',['pointer','pointer','pointer']);
    const typeInfoVptr=readPointer(core.base.add(0x7f3e6b0));
    if(configure(typeInfoVptr,core.base.add(0x6b24ca4),core.base.add(0x7fbac28))!==1)
        throw new Error('Completion library already owns a pending callback');
    return {create:fn('lab_new','pointer',[]),release:fn('lab_release_unsubmitted','void',['pointer']),
        snapshot:fn('lab_snapshot','uint',['pointer'])};
}
rpc.exports.sendonce=function(bytes) {
    if(attempted) throw new Error('One-shot sender already attempted; no automatic retry');
    if(bytes.length<1 || bytes.length>8192) throw new Error('Input bounds rejected');
    const service=serviceNow();
    completion=loadCompletion();
    const input=Memory.alloc(bytes.length);input.writeByteArray(bytes);
    const zeroString=Memory.alloc(24);zeroString.writeByteArray(new Uint8Array(24));
    const options=Memory.alloc(32);options.writeByteArray(new Uint8Array(32));
    const wrapper=Memory.alloc(40);wrapper.writeByteArray(new Uint8Array(40));
    let request=ptr(0), callback=ptr(0), enteredSubmit=false;
    try {
        request=create(ptr(0));
        if(!request.readPointer().equals(core.base.add(0x7fbab38)) || parse(request,input,bytes.length)!==1)
            throw new Error('Owned request rejected');
        callback=completion.create();
        if(callback.isNull()) throw new Error('Completion allocation failed');
        wrapper.add(0x20).writePointer(callback);
        attempted=true;enteredSubmit=true;
        const taskId=submit(service,request,zeroString,options,wrapper);
        return {taskId,submitted:true,callbackTransferred:wrapper.add(0x20).readPointer().isNull(),
            thread:Process.getCurrentThreadId(),uiOperations:0};
    } finally {
        if(!request.isNull()) destroy(request);
        // Once entered, ownership is ambiguous if an exception occurs; never
        // free a callback that the asynchronous task may already own.
        if(!enteredSubmit && !callback.isNull()) completion.release(callback);
    }
};
rpc.exports.status=function() {
    if(!completion) return {submitted:false};
    const out=Memory.alloc(4128);
    if(completion.snapshot(out)!==4128) throw new Error('Snapshot ABI mismatch');
    const size=out.add(24).readU32();
    if(size>4096) throw new Error('Response bounds rejected');
    return {liveCallbacks:out.readU32(),invoked:out.add(4).readU32(),destroyed:out.add(8).readU32(),
        errorType:out.add(12).readS32(),errorCode:out.add(16).readS32(),taskId:out.add(20).readU32(),
        responseSkipped:out.add(28).readU32()!==0,responseBytes:Array.from(new Uint8Array(out.add(32).readByteArray(size)))};
};
