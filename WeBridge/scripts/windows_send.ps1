#requires -Version 5.1
# Explicit UIA operations only. No coordinates, activation, clipboard or keys.
[CmdletBinding()]
param([ValidateSet('inspect','submit')][string]$Mode='inspect', [switch]$SelfTest)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
[Console]::InputEncoding=New-Object Text.UTF8Encoding($false)
[Console]::OutputEncoding=New-Object Text.UTF8Encoding($false)
$OutputEncoding=[Console]::OutputEncoding
$stage='before_input'
try {
    Add-Type -AssemblyName UIAutomationClient
    Add-Type -AssemblyName UIAutomationTypes
    Add-Type -AssemblyName WindowsBase
    Add-Type -ReferencedAssemblies UIAutomationClient,UIAutomationTypes,WindowsBase -TypeDefinition @'
using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Windows.Automation;
public static class WeBridgeNativeSend {
    [StructLayout(LayoutKind.Sequential)] struct Rect { public int left,top,right,bottom; }
    [StructLayout(LayoutKind.Sequential)] struct FileTime { public uint low,high; }
    [StructLayout(LayoutKind.Sequential)] struct UniqueProcess { public uint pid; public FileTime start; }
    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)] struct ProcessInfo {
        public UniqueProcess process;
        [MarshalAs(UnmanagedType.ByValTStr,SizeConst=256)] public string name;
        [MarshalAs(UnmanagedType.ByValTStr,SizeConst=64)] public string service;
        public int kind; public uint status,session; [MarshalAs(UnmanagedType.Bool)] public bool restartable;
    }
    [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr window);
    [DllImport("user32.dll")] static extern bool IsIconic(IntPtr window);
    [DllImport("user32.dll")] static extern IntPtr GetAncestor(IntPtr window,uint flags);
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr window,out uint pid);
    [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr window,out Rect rect);
    [DllImport("user32.dll")] static extern IntPtr OpenInputDesktop(uint flags,bool inherit,uint access);
    [DllImport("user32.dll",CharSet=CharSet.Unicode)] static extern bool GetUserObjectInformation(IntPtr handle,int index,StringBuilder value,uint length,out uint needed);
    [DllImport("user32.dll")] static extern bool CloseDesktop(IntPtr desktop);
    [DllImport("rstrtmgr.dll",CharSet=CharSet.Unicode)] static extern uint RmStartSession(out uint session,uint flags,StringBuilder key);
    [DllImport("rstrtmgr.dll",CharSet=CharSet.Unicode)] static extern uint RmRegisterResources(uint session,uint files,string[] names,uint applications,IntPtr apps,uint services,IntPtr serviceNames);
    [DllImport("rstrtmgr.dll")] static extern uint RmGetList(uint session,out uint needed,ref uint count,[In,Out] ProcessInfo[] rows,out uint reason);
    [DllImport("rstrtmgr.dll")] static extern uint RmEndSession(uint session);
    public class Binding {
        public int pid; public long hwnd;
        public string processStarted,sourceRoot,targetId="filehelper",targetName;
        public string targetRuntimeId,editorRuntimeId,sendRuntimeId,signature;
        public bool draftEmpty=true,ownerVerified=true;
    }
    public class Context {
        public Binding binding;
        public AutomationElement target,editor,send;
        public ValuePattern value;
        public InvokePattern invoke;
    }
    static void Require(bool condition,string code) { if(!condition) throw new InvalidOperationException(code); }
    static void Desktop() {
        IntPtr desktop=OpenInputDesktop(0,false,1);
        Require(desktop!=IntPtr.Zero,"desktop_unavailable");
        try { uint needed; var name=new StringBuilder(256);
            Require(GetUserObjectInformation(desktop,2,name,512,out needed) && name.ToString().Equals("Default",StringComparison.OrdinalIgnoreCase),"desktop_unavailable");
        } finally { CloseDesktop(desktop); }
    }
    static void Owner(string root,int pid,long created) {
        string anchor=Path.Combine(root,"session","session.db");
        if(!File.Exists(anchor)) anchor=Path.Combine(root,"session.db");
        Require(File.Exists(anchor),"owner_unverified");
        uint session; Require(RmStartSession(out session,0,new StringBuilder(33))==0,"owner_unverified");
        try {
            Require(RmRegisterResources(session,1,new string[]{anchor},0,IntPtr.Zero,0,IntPtr.Zero)==0,"owner_unverified");
            uint needed,count=0,reason;
            uint result=RmGetList(session,out needed,ref count,null,out reason);
            Require((result==0 || result==234) && needed>0 && needed<=128,"owner_unverified");
            var rows=new ProcessInfo[needed];count=needed;
            Require(RmGetList(session,out needed,ref count,rows,out reason)==0 && count==1,"owner_unverified");
            ulong started=((ulong)rows[0].process.start.high<<32)|rows[0].process.start.low;
            Require(rows[0].process.pid==pid && started==(ulong)created,"owner_unverified");
        } finally { RmEndSession(session); }
    }
    static bool Visible(AutomationElement node) {
        var current=node.Current;var bounds=current.BoundingRectangle;
        return !current.IsOffscreen && bounds.Width>0 && bounds.Height>0;
    }
    static string RuntimeId(AutomationElement node) { return String.Join(".",node.GetRuntimeId()); }
    static bool TargetName(string name) { return name=="\u6587\u4ef6\u4f20\u8f93\u52a9\u624b" || name=="File Transfer"; }
    static List<AutomationElement> Descendants(AutomationElement root,int limit,int depthLimit) {
        var result=new List<AutomationElement>();var queue=new Queue<Tuple<AutomationElement,int>>();
        queue.Enqueue(Tuple.Create(root,0));var walker=TreeWalker.RawViewWalker;
        while(queue.Count>0) {
            var current=queue.Dequeue();Require(result.Count<limit,"uia_send_unavailable");result.Add(current.Item1);
            var child=walker.GetFirstChild(current.Item1);
            Require(current.Item2<depthLimit || child==null,"uia_send_unavailable");
            while(child!=null) { queue.Enqueue(Tuple.Create(child,current.Item2+1));Require(queue.Count<=limit,"uia_send_unavailable");child=walker.GetNextSibling(child); }
        }
        return result;
    }
    static string ContainerName(AutomationElement node,AutomationElement editor) {
        if(TargetName(node.Current.Name)) return node.Current.Name;
        // A direct header above the editor identifies the current conversation;
        // never search message text or the sidebar for a matching display name.
        var child=TreeWalker.RawViewWalker.GetFirstChild(node);string found=null;int count=0;
        while(child!=null && ++count<=100) {
            var type=child.Current.ControlType;
            if((type==ControlType.Text || type==ControlType.Button) && Visible(child)
               && child.Current.BoundingRectangle.Bottom<editor.Current.BoundingRectangle.Top
               && TargetName(child.Current.Name)) { if(found!=null)return null; found=child.Current.Name; }
            child=TreeWalker.RawViewWalker.GetNextSibling(child);
        }
        return found;
    }
    static void EmptyAttachments(AutomationElement editor) {
        var parent=TreeWalker.RawViewWalker.GetParent(editor);
        Require(parent!=null,"draft_unverifiable");
        foreach(var child in Descendants(parent,100,8)) {
            var type=child.Current.ControlType;
            if(Visible(child) && (type==ControlType.Image || type==ControlType.ListItem || type==ControlType.DataItem || type==ControlType.Document))
                throw new InvalidOperationException("draft_present");
        }
    }
    public static Context Inspect(int pid,long hwnd,string sourceRoot,string expectedText) {
        Desktop();IntPtr window=new IntPtr(hwnd);uint actual;GetWindowThreadProcessId(window,out actual);
        Require(actual==pid && IsWindowVisible(window) && !IsIconic(window) && GetAncestor(window,2)==window,"window_changed");
        var process=Process.GetProcessById(pid);
        Require(process.ProcessName.Equals("Weixin",StringComparison.OrdinalIgnoreCase)||process.ProcessName.Equals("WeChat",StringComparison.OrdinalIgnoreCase),"window_changed");
        long started=process.StartTime.ToUniversalTime().ToFileTimeUtc();string root=Path.GetFullPath(sourceRoot);
        Owner(root,pid,started);Rect rectangle;Require(GetWindowRect(window,out rectangle),"window_changed");
        var uiRoot=AutomationElement.FromHandle(window);Require(uiRoot!=null,"uia_send_unavailable");
        Context chosen=null;
        foreach(var editor in Descendants(uiRoot,400,12)) {
            if(editor.Current.ProcessId!=pid || editor.Current.ControlType!=ControlType.Edit || !Visible(editor) || !editor.Current.IsEnabled) continue;
            object pattern;if(!editor.TryGetCurrentPattern(ValuePattern.Pattern,out pattern))continue;
            var value=(ValuePattern)pattern;if(value.Current.IsReadOnly)continue;
            var ancestor=TreeWalker.RawViewWalker.GetParent(editor);
            for(int depth=0;ancestor!=null && depth<12 && !Automation.Compare(ancestor,uiRoot);depth++,ancestor=TreeWalker.RawViewWalker.GetParent(ancestor)) {
                if(ancestor.Current.ProcessId!=pid || !Visible(ancestor))continue;
                string name=ContainerName(ancestor,editor);if(name==null)continue;
                AutomationElement send=null;InvokePattern invoke=null;int sends=0;
                foreach(var candidate in Descendants(ancestor,250,10)) {
                    if(candidate.Current.ProcessId!=pid || candidate.Current.ControlType!=ControlType.Button || !Visible(candidate))continue;
                    string buttonName=candidate.Current.Name;
                    if(buttonName!="\u53d1\u9001" && buttonName!="\u53d1\u9001(S)" && buttonName!="Send" && buttonName!="Send(S)")continue;
                    object action;if(candidate.TryGetCurrentPattern(InvokePattern.Pattern,out action)){send=candidate;invoke=(InvokePattern)action;sends++;}
                }
                Require(sends==1 && chosen==null,"uia_send_unavailable");
                string current=value.Current.Value;
                Require(current==expectedText,expectedText==""?"draft_present":"text_mismatch");
                EmptyAttachments(editor);
                var binding=new Binding {pid=pid,hwnd=hwnd,sourceRoot=root,processStarted=started.ToString(),targetName=name,
                    targetRuntimeId=RuntimeId(ancestor),editorRuntimeId=RuntimeId(editor),sendRuntimeId=RuntimeId(send),draftEmpty=current==""};
                binding.signature=String.Join("|",new string[]{pid.ToString(),hwnd.ToString(),root,started.ToString(),name,binding.targetRuntimeId,binding.editorRuntimeId,binding.sendRuntimeId,
                    rectangle.left.ToString(),rectangle.top.ToString(),rectangle.right.ToString(),rectangle.bottom.ToString()});
                chosen=new Context {binding=binding,target=ancestor,editor=editor,send=send,value=value,invoke=invoke};break;
            }
        }
        Require(chosen!=null,"uia_send_unavailable");
        Require(Process.GetProcessById(pid).StartTime.ToUniversalTime().ToFileTimeUtc()==started,"window_changed");
        return chosen;
    }
}
'@
    if($SelfTest) { @{ok=$true;abi='compiled';mode='no-window-no-input'} | ConvertTo-Json -Compress; exit 0 }
    $raw=[Console]::In.ReadToEnd()
    if($raw.Length -gt 20000) { throw 'invalid_input' }
    $request=$raw | ConvertFrom-Json
    if($Mode -eq 'inspect') {
        if($request.targetId -ne 'filehelper') { throw 'uia_send_unavailable' }
        $context=[WeBridgeNativeSend]::Inspect([int]$request.pid,[long]$request.hwnd,[string]$request.sourceRoot,'')
        @{ok=$true;binding=$context.binding;stage='before_input'} | ConvertTo-Json -Depth 6 -Compress
    } else {
        $binding=$request.binding
        $text=[string]$request.text
        if($binding.targetId -ne 'filehelper' -or -not $text.Trim() -or $text.Length -gt 4000 -or $text -match '[\x00-\x1f\x7f]') { throw 'invalid_input' }
        $context=[WeBridgeNativeSend]::Inspect([int]$binding.pid,[long]$binding.hwnd,[string]$binding.sourceRoot,'')
        if($context.binding.signature -cne $binding.signature) { throw 'window_changed' }
        # Only target-specific UIA patterns are used, never global keystrokes.
        $stage='input_started'
        $context.value.SetValue($text)
        $check=[WeBridgeNativeSend]::Inspect([int]$binding.pid,[long]$binding.hwnd,[string]$binding.sourceRoot,$text)
        if($check.binding.signature -cne $binding.signature -or -not $check.send.Current.IsEnabled) { throw 'window_changed' }
        $stage='submit_started'
        $check.invoke.Invoke()
        @{ok=$true;stage='submitted';delivered=$false} | ConvertTo-Json -Compress
    }
} catch {
    if($SelfTest) { throw }
    $message=[string]$_.Exception.Message
    $known=@('uia_send_unavailable','window_changed','owner_unverified','draft_present','draft_unverifiable','text_mismatch','desktop_unavailable')
    $code='native_failed'
    foreach($item in $known) { if($message.Contains($item)) { $code=$item;break } }
    @{ok=$false;stage=$stage;issueCode=$code;delivered=$false} | ConvertTo-Json -Compress
}
