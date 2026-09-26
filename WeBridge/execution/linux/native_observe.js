// Observation only: no NativeFunction calls, argument changes, or sends.
// Offsets apply only to the BuildID gated by native_observe.py.
const core = Process.getModuleByName('wechat');
const counts = {};
const member = '25984984017034815@openim';

function readable(p, size) {
    if (!p || p.isNull() || p.compare(ptr(0x10000)) < 0) return false;
    const range = Process.findRangeByAddress(p);
    return range !== null && range.protection[0] === 'r' &&
        p.add(size).compare(range.base.add(range.size)) <= 0;
}

function stringAt(p) {
    try {
        // Do not deliberately fault and rely on Frida's exception handler:
        // the first broad observer crashed inside libfrida-agent while reading
        // an invalid address. Mapping checks reduce that failure path, but
        // still do not guarantee an object's lifetime under concurrent frees.
        if (!readable(p, 24)) return null;
        const first = p.readU8();
        const n = first & 1 ? Number(p.add(8).readU64()) : first >>> 1;
        if (!n || n > 1024 || (!(first & 1) && n > 22)) return null;
        const data = first & 1 ? p.add(16).readPointer() : p.add(1);
        if (!readable(data, n)) return null;
        return data.readUtf8String(n);
    } catch (_) { return null; }
}
function count(name) { counts[name] = (counts[name] || 0) + 1; }
Interceptor.attach(core.base.add(0x6b5c7fc), {
    onEnter(args) {
        count('startTask');
        // +0x18 was observed on the authorized calibration task.
        const value=stringAt(args[1].add(0x18));
        if(value === '/cgi-bin/micromsg-bin/newsendmsg') {
            send({event:'textTask',cgi:value,cgiOffset:'0x18',thread:Process.getCurrentThreadId()});
        }
    }
});
for (const address of [0x4f65f78,0x4f62668]) {
    Interceptor.attach(core.base.add(address), {
        onEnter() {
            count('sendBuilder_'+address.toString(16));
            // Do not scan unknown C++ arguments; first recover their layout.
        }
    });
}
Interceptor.attach(core.base.add(0x4852f8c), {
    onEnter(args) {
        count('sourceGenerator');
        const ids=stringAt(args[0].add(0x18));
        this.matched=ids && ids.split(',').includes(member);
        this.output=this.context.x8;
    },
    onLeave() {
        if(this.matched) {
            const xml=stringAt(this.output);
            send({event:'targetMentionSource',xml:xml && xml.includes(member)?xml:null,thread:Process.getCurrentThreadId()});
        }
    }
});
rpc.exports.summary=()=>counts;
send({event:'observerReady',module:core.name,arch:Process.arch});
