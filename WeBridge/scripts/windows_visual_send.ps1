#requires -Version 5.1
# Explicit, user-reviewed visual operations. No search, clipboard or retries.
[CmdletBinding()]
param([ValidateSet('preview','stage','submit','inspect')][string]$Mode='preview', [switch]$SelfTest)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
[Console]::InputEncoding=New-Object Text.UTF8Encoding($false)
[Console]::OutputEncoding=New-Object Text.UTF8Encoding($false)
$OutputEncoding=[Console]::OutputEncoding
$stage='before_input'
try {
    Add-Type -AssemblyName System.Drawing
    # Compile the existing physical-pixel geometry implementation only. Do not
    # execute the probe script, its window enumeration or its UIA reader.
    $probeSource=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'windows_probe.ps1') -Raw
    $definition=[regex]::Match($probeSource,"(?s)Add-Type -TypeDefinition @'\r?\n(.*?)\r?\n'@")
    if(-not $definition.Success) { throw 'helper_unavailable' }
    $visualSource=@'
namespace WeBridgeVisual {
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Threading;

public static class Native {
    const int PixelChannelTolerance=6;
    [StructLayout(LayoutKind.Sequential)] struct Point { public int x,y; }
    [StructLayout(LayoutKind.Sequential)] struct Rect { public int left,top,right,bottom; }
    [StructLayout(LayoutKind.Sequential)] struct FileTime { public uint low,high; }
    [StructLayout(LayoutKind.Sequential)] struct UniqueProcess { public uint pid; public FileTime start; }
    [StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] struct ProcessInfo {
        public UniqueProcess process;
        [MarshalAs(UnmanagedType.ByValTStr,SizeConst=256)] public string name;
        [MarshalAs(UnmanagedType.ByValTStr,SizeConst=64)] public string service;
        public int kind; public uint status,session; [MarshalAs(UnmanagedType.Bool)] public bool restartable;
    }
    [StructLayout(LayoutKind.Sequential)] struct MouseInput {
        public int dx,dy;public uint mouseData,flags,time;public UIntPtr extra;
    }
    [StructLayout(LayoutKind.Sequential)] struct KeyboardInput {
        public ushort key,scan;public uint flags,time;public UIntPtr extra;
    }
    [StructLayout(LayoutKind.Explicit)] struct InputData {
        [FieldOffset(0)]public MouseInput mouse;
        [FieldOffset(0)]public KeyboardInput keyboard;
    }
    [StructLayout(LayoutKind.Sequential)] struct Input { public uint type;public InputData data; }
    [StructLayout(LayoutKind.Sequential)] struct GuiThreadInfo {
        public uint size,flags;public IntPtr active,focus,capture,menuOwner,moveSize,caret;public Rect caretRect;
    }
    [DllImport("user32.dll")] static extern bool ShowWindow(IntPtr window,int command);
    [DllImport("user32.dll")] static extern bool SetForegroundWindow(IntPtr window);
    [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] static extern bool PrintWindow(IntPtr window,IntPtr dc,uint flags);
    [DllImport("user32.dll")] static extern IntPtr WindowFromPoint(Point point);
    [DllImport("user32.dll")] static extern IntPtr GetAncestor(IntPtr window,uint flags);
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr window,out uint pid);
    [DllImport("user32.dll")] static extern bool SetCursorPos(int x,int y);
    [DllImport("user32.dll")] static extern uint SendInput(uint count,Input[] events,int size);
    [DllImport("user32.dll")] static extern bool GetGUIThreadInfo(uint thread,ref GuiThreadInfo info);
    [DllImport("user32.dll")] static extern short GetAsyncKeyState(int key);
    [DllImport("user32.dll")] static extern int GetSystemMetrics(int index);
    [DllImport("user32.dll")] static extern IntPtr OpenInputDesktop(uint flags,bool inherit,uint access);
    [DllImport("user32.dll",CharSet=CharSet.Unicode)] static extern bool GetUserObjectInformation(IntPtr handle,int index,StringBuilder value,uint length,out uint needed);
    [DllImport("user32.dll")] static extern bool CloseDesktop(IntPtr desktop);
    [DllImport("rstrtmgr.dll",CharSet=CharSet.Unicode)] static extern uint RmStartSession(out uint session,uint flags,StringBuilder key);
    [DllImport("rstrtmgr.dll",CharSet=CharSet.Unicode)] static extern uint RmRegisterResources(uint session,uint files,string[] names,uint applications,IntPtr apps,uint services,IntPtr serviceNames);
    [DllImport("rstrtmgr.dll")] static extern uint RmGetList(uint session,out uint needed,ref uint count,[In,Out] ProcessInfo[] rows,out uint reason);
    [DllImport("rstrtmgr.dll")] static extern uint RmEndSession(uint session);

    public class Geometry { public int x,y,width,height;public uint dpi; }
    public class Binding {
        public int pid;public long hwnd;public string sourceRoot,processStarted,signature,captureMethod;
        public Geometry geometry;
        public bool ownerVerified=true,targetVerified=false;
        public string targetId="filehelper",verification="user-reviewed-image";
    }
    public class Capture {
        public Binding binding;public string png_base64;public int width,height;
    }
    public class Inspection {
        public bool signatureMatches,processStartedMatches,geometryMatches,sourceRootMatches,foregroundMatches;
        public Geometry expectedGeometry,currentGeometry;
    }
    public class WindowCheck {
        public int requestedPid;public long requestedHwnd;public uint actualPid;
        public bool visible,minimized,topLevel,processNameMatches,processStartedMatches;
        public Geometry currentGeometry;
    }
    static void Require(bool condition,string code) { if(!condition)throw new InvalidOperationException(code); }
    static void Desktop() {
        IntPtr desktop=OpenInputDesktop(0,false,1);Require(desktop!=IntPtr.Zero,"desktop_unavailable");
        try { uint needed;var name=new StringBuilder(256);
            Require(GetUserObjectInformation(desktop,2,name,512,out needed) && name.ToString().Equals("Default",StringComparison.OrdinalIgnoreCase),"desktop_unavailable");
        } finally {CloseDesktop(desktop);}
    }
    static void Owner(string root,int pid,long started) {
        string nested=Path.Combine(root,"session","session.db"),flat=Path.Combine(root,"session.db");
        Require(File.Exists(nested)^File.Exists(flat),"owner_unverified");
        string anchor=File.Exists(nested)?nested:flat;
        var names=new List<string>();names.Add(anchor);if(File.Exists(anchor+"-wal"))names.Add(anchor+"-wal");
        uint session;Require(RmStartSession(out session,0,new StringBuilder(33))==0,"owner_unverified");
        try {
            Require(RmRegisterResources(session,(uint)names.Count,names.ToArray(),0,IntPtr.Zero,0,IntPtr.Zero)==0,"owner_unverified");
            uint needed,count=0,reason;uint result=RmGetList(session,out needed,ref count,null,out reason);
            Require((result==0||result==234)&&needed>0&&needed<=128,"owner_unverified");
            for(int attempt=0;attempt<3;attempt++) {
                Require(needed>0&&needed<=128,"owner_unverified");
                var rows=new ProcessInfo[needed];count=needed;
                result=RmGetList(session,out needed,ref count,rows,out reason);
                if(result==234)continue;
                Require(result==0&&count==1,"owner_unverified");
                ulong created=((ulong)rows[0].process.start.high<<32)|rows[0].process.start.low;
                Require(rows[0].process.pid==pid&&created==(ulong)started,"owner_unverified");return;
            }
            throw new InvalidOperationException("owner_unverified");
        } finally {RmEndSession(session);}
    }
    static string Digest(string value) {
        using(var sha=SHA256.Create())return BitConverter.ToString(sha.ComputeHash(Encoding.UTF8.GetBytes(value))).Replace("-","").ToLowerInvariant();
    }
    static void WindowMetadata(WeBridgeWindowProbe.WindowInfo window,int pid) {
        Require(window.Pid==pid&&pid>0&&window.TopLevel&&window.Visible,"window_changed");
        Require(!window.Minimized,"window_minimized");
    }
    static Binding Inspect(int pid,long hwnd,string sourceRoot) {
        // Visual sending uses the full physical GetWindowRect because
        // PrintWindow renders the non-client frame as well as the client area.
        Desktop();var window=WeBridgeWindowProbe.Inspect(hwnd);
        WindowMetadata(window,pid);
        long started;
        using(var process=Process.GetProcessById(pid)) {
            Require(process.ProcessName.Equals("Weixin",StringComparison.OrdinalIgnoreCase)||process.ProcessName.Equals("WeChat",StringComparison.OrdinalIgnoreCase),"window_changed");
            started=process.StartTime.ToUniversalTime().ToFileTimeUtc();
        }
        string root=Path.GetFullPath(sourceRoot);Owner(root,pid,started);
        var geometry=new Geometry{x=window.Left,y=window.Top,width=window.Right-window.Left,height=window.Bottom-window.Top,dpi=window.Dpi};
        Require(geometry.width>0&&geometry.height>0&&geometry.width<=5000&&geometry.height<=5000,"capture_unavailable");
        Require(geometry.x>=GetSystemMetrics(76)&&geometry.y>=GetSystemMetrics(77)&&
                (long)geometry.x+geometry.width<=(long)GetSystemMetrics(76)+GetSystemMetrics(78)&&
                (long)geometry.y+geometry.height<=(long)GetSystemMetrics(77)+GetSystemMetrics(79),"window_outside_desktop");
        var binding=new Binding{pid=pid,hwnd=hwnd,sourceRoot=root,processStarted=started.ToString(),geometry=geometry};
        binding.signature=Digest(String.Join("|",new string[]{pid.ToString(),hwnd.ToString(),root,started.ToString(),window.Title,
            geometry.x.ToString(),geometry.y.ToString(),geometry.width.ToString(),geometry.height.ToString(),geometry.dpi.ToString()}));
        return binding;
    }
    public static Binding Verify(Binding expected,bool activate) {
        Require(expected!=null&&expected.geometry!=null,"invalid_input");
        if(activate) {
            // Explicit stage/submit may restore only this exact bound window.
            // Minimized geometry is intentionally not compared until restoration;
            // process identity and account ownership are checked before ShowWindow.
            var before=WeBridgeWindowProbe.Inspect(expected.hwnd);
            long expectedStarted;Require(Int64.TryParse(expected.processStarted,out expectedStarted),"invalid_input");
            long started;
            using(var process=Process.GetProcessById(expected.pid)) {
                Require(process.ProcessName.Equals("Weixin",StringComparison.OrdinalIgnoreCase)||process.ProcessName.Equals("WeChat",StringComparison.OrdinalIgnoreCase),"window_changed");
                started=process.StartTime.ToUniversalTime().ToFileTimeUtc();
            }
            RestoreIdentity(before,expected.pid,started,expectedStarted);
            Owner(Path.GetFullPath(expected.sourceRoot),expected.pid,expectedStarted);Desktop();
            bool needsForeground=GetForegroundWindow()!=new IntPtr(expected.hwnd);
            if(before.Minimized)ShowWindow(new IntPtr(expected.hwnd),9);
            if(needsForeground||before.Minimized) {
                SetForegroundWindow(new IntPtr(expected.hwnd));Thread.Sleep(150);
            }
        }
        var current=Inspect(expected.pid,expected.hwnd,expected.sourceRoot);
        Require(current.signature==expected.signature&&current.processStarted==expected.processStarted,"window_changed");
        Require(current.geometry.x==expected.geometry.x&&current.geometry.y==expected.geometry.y&&
                current.geometry.width==expected.geometry.width&&current.geometry.height==expected.geometry.height&&
                current.geometry.dpi==expected.geometry.dpi,"window_changed");
        Require(GetForegroundWindow()==new IntPtr(expected.hwnd),"foreground_mismatch");
        return current;
    }
    static void RestoreIdentity(WeBridgeWindowProbe.WindowInfo window,int pid,long actualStarted,long expectedStarted) {
        Require(window.Pid==pid&&pid>0&&window.TopLevel&&actualStarted==expectedStarted,"window_changed");
    }
    public static Inspection InspectBinding(Binding expected) {
        Require(expected!=null&&expected.geometry!=null,"invalid_input");
        var current=Inspect(expected.pid,expected.hwnd,expected.sourceRoot);
        return new Inspection {
            signatureMatches=current.signature==expected.signature,
            processStartedMatches=current.processStarted==expected.processStarted,
            sourceRootMatches=current.sourceRoot==expected.sourceRoot,
            foregroundMatches=GetForegroundWindow()==new IntPtr(expected.hwnd),
            geometryMatches=current.geometry.x==expected.geometry.x&&current.geometry.y==expected.geometry.y&&
                current.geometry.width==expected.geometry.width&&current.geometry.height==expected.geometry.height&&current.geometry.dpi==expected.geometry.dpi,
            expectedGeometry=expected.geometry,currentGeometry=current.geometry
        };
    }
    public static WindowCheck InspectWindowOnly(Binding expected) {
        var window=WeBridgeWindowProbe.Inspect(expected.hwnd);
        var result=new WindowCheck{requestedPid=expected.pid,requestedHwnd=expected.hwnd,actualPid=window.Pid,
            visible=window.Visible,minimized=window.Minimized,topLevel=window.TopLevel,
            currentGeometry=new Geometry{x=window.Left,y=window.Top,width=window.Right-window.Left,height=window.Bottom-window.Top,dpi=window.Dpi}};
        using(var process=Process.GetProcessById(expected.pid)) {
            result.processNameMatches=process.ProcessName.Equals("Weixin",StringComparison.OrdinalIgnoreCase)||process.ProcessName.Equals("WeChat",StringComparison.OrdinalIgnoreCase);
            result.processStartedMatches=process.StartTime.ToUniversalTime().ToFileTimeUtc().ToString()==expected.processStarted;
        }
        return result;
    }
    static bool Useful(Bitmap image) {
        int first=image.GetPixel(0,0).ToArgb();
        for(int y=0;y<image.Height;y+=Math.Max(1,image.Height/48))
            for(int x=0;x<image.Width;x+=Math.Max(1,image.Width/48))
                if(image.GetPixel(x,y).ToArgb()!=first)return true;
        return false;
    }
    static void Opaque(Bitmap image) {
        var bounds=new Rectangle(0,0,image.Width,image.Height);
        var data=image.LockBits(bounds,ImageLockMode.ReadWrite,PixelFormat.Format32bppArgb);
        try {
            var row=new byte[image.Width*4];
            for(int y=0;y<image.Height;y++) {
                IntPtr address=IntPtr.Add(data.Scan0,y*data.Stride);Marshal.Copy(address,row,0,row.Length);
                for(int x=3;x<row.Length;x+=4)row[x]=255;
                Marshal.Copy(row,0,address,row.Length);
            }
        } finally {image.UnlockBits(data);}
    }
    static Bitmap Print(Binding binding) {
        var outside=WeBridgeWindowProbe.Inspect(binding.hwnd);
        int width=outside.Right-outside.Left,height=outside.Bottom-outside.Top;
        if(width<=0||height<=0||width>5100||height>5100)return null;
        using(var full=new Bitmap(width,height,PixelFormat.Format32bppArgb)) {
            bool printed;
            using(var graphics=Graphics.FromImage(full)) {
                IntPtr dc=graphics.GetHdc();
                try {printed=PrintWindow(new IntPtr(binding.hwnd),dc,2);}finally {graphics.ReleaseHdc(dc);}
            }
            int left=binding.geometry.x-outside.Left,top=binding.geometry.y-outside.Top;
            if(!printed||left<0||top<0||left+binding.geometry.width>width||top+binding.geometry.height>height)return null;
            var visible=full.Clone(new Rectangle(left,top,binding.geometry.width,binding.geometry.height),PixelFormat.Format32bppArgb);
            Opaque(visible);
            if(Useful(visible))return visible;
            visible.Dispose();return null;
        }
    }
    static Bitmap Pixels(Binding expected,out string method) {
        Verify(expected,false);
        var image=Print(expected);method="printwindow";
        if(image==null) {
            method="screen";image=new Bitmap(expected.geometry.width,expected.geometry.height,PixelFormat.Format32bppArgb);
            try { using(var graphics=Graphics.FromImage(image))graphics.CopyFromScreen(expected.geometry.x,expected.geometry.y,0,0,
                    new Size(image.Width,image.Height),CopyPixelOperation.SourceCopy); }
            catch {image.Dispose();throw;}
        }
        try {Verify(expected,false);return image;}catch {image.Dispose();throw;}
    }
    static Capture Encoded(Binding binding,Bitmap image,string method) {
        using(var stream=new MemoryStream()) {
            Opaque(image);
            image.Save(stream,ImageFormat.Png);Require(stream.Length<=8*1024*1024,"capture_too_large");
            binding.captureMethod=method;
            return new Capture{binding=binding,png_base64=Convert.ToBase64String(stream.ToArray()),width=image.Width,height=image.Height};
        }
    }
    public static Capture Snapshot(Binding expected) {
        string method;using(var image=Pixels(expected,out method))return Encoded(expected,image,method);
    }
    public static Capture Preview(int pid,long hwnd,string sourceRoot) {
        var initial=WeBridgeWindowProbe.Inspect(hwnd);
        Require(initial.Pid==pid&&initial.TopLevel,"window_changed");
        // Verify the account's owner before bringing any window to the front.
        long started;using(var process=Process.GetProcessById(pid)) {
            Require(process.ProcessName.Equals("Weixin",StringComparison.OrdinalIgnoreCase)||process.ProcessName.Equals("WeChat",StringComparison.OrdinalIgnoreCase),"window_changed");
            started=process.StartTime.ToUniversalTime().ToFileTimeUtc();
        }
        Owner(Path.GetFullPath(sourceRoot),pid,started);Desktop();
        if(initial.Minimized)ShowWindow(new IntPtr(hwnd),9);
        SetForegroundWindow(new IntPtr(hwnd));Thread.Sleep(150);
        var binding=Inspect(pid,hwnd,sourceRoot);
        Require(binding.processStarted==started.ToString(),"window_changed");
        return Snapshot(binding);
    }
    static Bitmap Decode(string encoded,Geometry expected) {
        Require(encoded!=null&&encoded.Length>0&&encoded.Length<=12*1024*1024,"invalid_reference");
        byte[] data=Convert.FromBase64String(encoded);Require(data.Length<=8*1024*1024,"invalid_reference");
        using(var stream=new MemoryStream(data))using(var source=Image.FromStream(stream,true,true)) {
            Require(source.Width==expected.width&&source.Height==expected.height,"preview_changed");
            var image=new Bitmap(source.Width,source.Height,PixelFormat.Format32bppArgb);
            using(var graphics=Graphics.FromImage(image))graphics.DrawImageUnscaled(source,0,0);
            return image;
        }
    }
    public static bool EqualPixels(Bitmap a,Bitmap b) {
        if(a.Width!=b.Width||a.Height!=b.Height)return false;
        var bounds=new Rectangle(0,0,a.Width,a.Height);
        BitmapData left=null,right=null;
        try {
            left=a.LockBits(bounds,ImageLockMode.ReadOnly,PixelFormat.Format32bppArgb);
            right=b.LockBits(bounds,ImageLockMode.ReadOnly,PixelFormat.Format32bppArgb);
            var x=new byte[a.Width*4];var y=new byte[b.Width*4];
            for(int row=0;row<a.Height;row++) {
                Marshal.Copy(IntPtr.Add(left.Scan0,row*left.Stride),x,0,x.Length);
                Marshal.Copy(IntPtr.Add(right.Scan0,row*right.Stride),y,0,y.Length);
                // Compare every RGB channel of every pixel. Windows Mica and
                // shadow rendering showed measured per-channel jitter up to 5.
                // Permit only this fixed small color difference; no area masks,
                // changed-pixel ratios, or high-contrast character differences.
                // PrintWindow alpha is not meaningful; PNGs are made opaque.
                for(int column=0;column<x.Length;column+=4)
                    if(Math.Abs((int)x[column]-y[column])>PixelChannelTolerance||
                       Math.Abs((int)x[column+1]-y[column+1])>PixelChannelTolerance||
                       Math.Abs((int)x[column+2]-y[column+2])>PixelChannelTolerance)return false;
            }
            return true;
        } finally {if(left!=null)a.UnlockBits(left);if(right!=null)b.UnlockBits(right);}
    }
    public static void Match(Binding expected,string encoded) {
        Verify(expected,true);
        using(var reference=Decode(encoded,expected.geometry)) {
            // A later capture may match the other phase of a blinking caret.
            // No pixels are ignored, and no input occurs in these retries.
            for(int attempt=0;attempt<4;attempt++) {
                string method;
                using(var current=Pixels(expected,out method)) {
                    Require(String.IsNullOrEmpty(expected.captureMethod)||expected.captureMethod==method,"preview_changed");
                    if(EqualPixels(reference,current))return;
                }
                if(attempt<3)Thread.Sleep(140);
            }
        }
        throw new InvalidOperationException("preview_changed");
    }
    public static void CheckPoints(Binding binding,int[] compose,int[] send) {
        Require(compose!=null&&send!=null&&compose.Length==2&&send.Length==2,"invalid_point");
        foreach(var point in new int[][]{compose,send})
            Require(point[0]>=0&&point[1]>=0&&point[0]<binding.geometry.width&&point[1]<binding.geometry.height,"invalid_point");
        Require(Math.Abs((long)compose[0]-send[0])+Math.Abs((long)compose[1]-send[1])>=8,"invalid_point");
    }
    static void Hit(Binding binding,int[] point) {
        var physical=new Point{x=binding.geometry.x+point[0],y=binding.geometry.y+point[1]};
        IntPtr hit=WindowFromPoint(physical);uint pid;
        GetWindowThreadProcessId(hit,out pid);
        Require(hit!=IntPtr.Zero&&pid==binding.pid&&GetAncestor(hit,2)==new IntPtr(binding.hwnd),"point_occluded");
    }
    static void NeutralInput() {
        foreach(int key in new int[]{0x01,0x02,0x04,0x10,0x11,0x12,0x5b,0x5c})
            Require((GetAsyncKeyState(key)&0x8000)==0,"input_busy");
    }
    public static void ReadyForPoint(Binding binding,int[] point) {Verify(binding,false);Hit(binding,point);NeutralInput();}
    static void Dispatch(Input[] inputs) {
        Require(IntPtr.Size==8&&Marshal.SizeOf(typeof(Input))==40,"unsupported_input_abi");
        Require(SendInput((uint)inputs.Length,inputs,Marshal.SizeOf(typeof(Input)))==inputs.Length,"native_input_failed");
    }
    public static void Click(Binding binding,int[] point) {
        ReadyForPoint(binding,point);
        Require(SetCursorPos(binding.geometry.x+point[0],binding.geometry.y+point[1]),"native_input_failed");
        ReadyForPoint(binding,point);
        Dispatch(new Input[]{new Input{type=0,data=new InputData{mouse=new MouseInput{flags=2}}},
                             new Input{type=0,data=new InputData{mouse=new MouseInput{flags=4}}}});
    }
    public static void Type(Binding binding,string text) {
        Require(!String.IsNullOrWhiteSpace(text)&&text.Length<=4000,"invalid_input");
        foreach(char c in text)Require(!Char.IsControl(c),"invalid_input");
        Verify(binding,false);NeutralInput();
        uint pid;uint thread=GetWindowThreadProcessId(new IntPtr(binding.hwnd),out pid);
        var info=new GuiThreadInfo();info.size=(uint)Marshal.SizeOf(typeof(GuiThreadInfo));
        Require(GetGUIThreadInfo(thread,ref info)&&info.focus!=IntPtr.Zero,"focus_unverified");
        GetWindowThreadProcessId(info.focus,out pid);
        Require(pid==binding.pid&&GetAncestor(info.focus,2)==new IntPtr(binding.hwnd),"focus_unverified");
        var inputs=new List<Input>();
        foreach(char unit in text) {
            inputs.Add(new Input{type=1,data=new InputData{keyboard=new KeyboardInput{scan=unit,flags=4}}});
            inputs.Add(new Input{type=1,data=new InputData{keyboard=new KeyboardInput{scan=unit,flags=6}}});
        }
        Dispatch(inputs.ToArray());
    }
    public static string SelfTest() {
        Require(IntPtr.Size==8&&Marshal.SizeOf(typeof(Input))==40,"unsupported_input_abi");
        Require(Marshal.SizeOf(typeof(ProcessInfo))==668,"unsupported_owner_abi");
        using(var a=new Bitmap(8,8,PixelFormat.Format32bppArgb))using(var b=new Bitmap(8,8,PixelFormat.Format32bppArgb)) {
            Require(EqualPixels(a,b),"pixel_test_failed");b.SetPixel(2,3,Color.Red);
            Require(!EqualPixels(a,b),"pixel_test_failed");
            Opaque(a);Require(a.GetPixel(0,0).A==255,"pixel_test_failed");
            b.SetPixel(2,3,Color.FromArgb(255,6,6,6));
            Require(EqualPixels(a,b),"small_color_jitter_test_failed");
            foreach(var changed in new Color[]{Color.FromArgb(255,7,6,6),Color.FromArgb(255,6,7,6),Color.FromArgb(255,6,6,7),Color.White}) {
                b.SetPixel(2,3,changed);Require(!EqualPixels(a,b),"changed_pixel_test_failed");
            }
        }
        var binding=new Binding{geometry=new Geometry{width=8,height=8}};
        CheckPoints(binding,new int[]{0,0},new int[]{7,7});
        bool rejected=false;
        try {CheckPoints(binding,new int[]{8,0},new int[]{0,7});}catch(InvalidOperationException){rejected=true;}
        Require(rejected,"point_test_failed");
        bool minimizedRejected=false;
        try {WindowMetadata(new WeBridgeWindowProbe.WindowInfo{Pid=7,TopLevel=true,Visible=true,Minimized=true},7);}
        catch(InvalidOperationException failure){minimizedRejected=failure.Message=="window_minimized";}
        Require(minimizedRejected,"window_state_test_failed");
        var minimized=new WeBridgeWindowProbe.WindowInfo{Pid=7,TopLevel=true,Visible=true,Minimized=true};
        RestoreIdentity(minimized,7,123,123);
        bool replacedRejected=false;
        try {RestoreIdentity(minimized,7,124,123);}catch(InvalidOperationException){replacedRejected=true;}
        Require(replacedRejected,"restore_identity_test_failed");
        bool wrongPidRejected=false;
        try {RestoreIdentity(minimized,8,123,123);}catch(InvalidOperationException){wrongPidRejected=true;}
        Require(wrongPidRejected,"restore_identity_test_failed");
        return "compiled-and-synthetic-pixels";
    }
}
}
'@
    Add-Type -ReferencedAssemblies System.Drawing,System,System.Core -TypeDefinition ($definition.Groups[1].Value+[Environment]::NewLine+$visualSource)
    if($SelfTest) {
        @{ok=$true;abi=[WeBridgeVisual.Native]::SelfTest();mode='no-window-no-input'} | ConvertTo-Json -Compress
        exit 0
    }
    if([WeBridgeWindowProbe]::SetThreadDpiAwarenessContext([IntPtr](-4)) -eq [IntPtr]::Zero) { throw 'capture_unavailable' }
    $raw=[Console]::In.ReadToEnd()
    if($raw.Length -gt 13MB) { throw 'invalid_input' }
    $request=$raw | ConvertFrom-Json
    if($Mode -eq 'preview') {
        $result=[WeBridgeVisual.Native]::Preview([int]$request.pid,[long]$request.hwnd,[string]$request.sourceRoot)
        @{ok=$true;stage='before_input';binding=$result.binding;png_base64=$result.png_base64;width=$result.width;height=$result.height} | ConvertTo-Json -Depth 8 -Compress
        exit 0
    }
    $binding=[WeBridgeVisual.Native+Binding]::new()
    $binding.pid=[int]$request.binding.pid;$binding.hwnd=[long]$request.binding.hwnd
    $binding.sourceRoot=[string]$request.binding.sourceRoot;$binding.processStarted=[string]$request.binding.processStarted
    $binding.signature=[string]$request.binding.signature;$binding.captureMethod=[string]$request.binding.captureMethod
    $binding.geometry=[WeBridgeVisual.Native+Geometry]::new()
    $binding.geometry.x=[int]$request.binding.geometry.x;$binding.geometry.y=[int]$request.binding.geometry.y
    $binding.geometry.width=[int]$request.binding.geometry.width;$binding.geometry.height=[int]$request.binding.geometry.height
    $binding.geometry.dpi=[uint32]$request.binding.geometry.dpi
    if($Mode -eq 'inspect') {
        $windowCheck=[WeBridgeVisual.Native]::InspectWindowOnly($binding)
        $checks=$null;$comparisonUnavailable=$false
        try {$checks=[WeBridgeVisual.Native]::InspectBinding($binding)} catch {$comparisonUnavailable=$true}
        @{ok=$true;stage='before_input';readOnly=$true;window=$windowCheck;checks=$checks;comparisonUnavailable=$comparisonUnavailable} | ConvertTo-Json -Depth 6 -Compress
        exit 0
    }
    $compose=[int[]]$request.composePoint;$send=[int[]]$request.sendPoint
    [WeBridgeVisual.Native]::CheckPoints($binding,$compose,$send)
    if($Mode -eq 'stage') {
        $text=[string]$request.text
        if(-not $text.Trim() -or $text.Length -gt 4000 -or $text -match '[\x00-\x1f\x7f]') { throw 'invalid_input' }
    }
    [WeBridgeVisual.Native]::Match($binding,[string]$request.reference_png_base64)
    if($Mode -eq 'stage') {
        [WeBridgeVisual.Native]::ReadyForPoint($binding,$compose)
        $stage='input_started'
        [WeBridgeVisual.Native]::Click($binding,$compose)
        Start-Sleep -Milliseconds 100
        [WeBridgeVisual.Native]::Type($binding,$text)
        Start-Sleep -Milliseconds 250
        $result=[WeBridgeVisual.Native]::Snapshot($binding)
        @{ok=$true;stage='staged';binding=$result.binding;png_base64=$result.png_base64;width=$result.width;height=$result.height} | ConvertTo-Json -Depth 8 -Compress
    } else {
        [WeBridgeVisual.Native]::ReadyForPoint($binding,$send)
        $stage='submit_started'
        [WeBridgeVisual.Native]::Click($binding,$send)
        @{ok=$true;stage='submitted';delivered=$false} | ConvertTo-Json -Compress
    }
} catch {
    if($SelfTest) { throw }
    $message=[string]$_.Exception.Message
    $known=@('invalid_input','invalid_point','invalid_reference','window_changed','window_minimized','owner_unverified','desktop_unavailable',
        'capture_unavailable','capture_too_large','window_outside_desktop','foreground_mismatch','preview_changed','point_occluded',
        'input_busy','focus_unverified','unsupported_input_abi','native_input_failed','helper_unavailable')
    $code='native_failed'
    foreach($item in $known) {if($message.Contains($item)) {$code=$item;break}}
    @{ok=$false;stage=$stage;issueCode=$code;delivered=$false} | ConvertTo-Json -Compress
}
