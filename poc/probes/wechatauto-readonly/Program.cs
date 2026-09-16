using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using FlaUI.Core.AutomationElements;
using FlaUI.UIA3;

// Prerequisite probe using the SDK's UIA dependencies, not SDK acceptance.
// No SDK initialization, input, focus, screenshots, network or message contents.
if (args.Length is < 1 or > 2 || string.IsNullOrWhiteSpace(args[0]))
{
    Console.Error.WriteLine("Usage: ReadOnlyProbe <exact target group title> [baseline|pulse-screen-reader|pulse-narrator]");
    return 2;
}

const uint SpiGetScreenReader = 0x46;
const uint SpiSetScreenReader = 0x47;
const uint SpifSendChange = 0x02;
const uint ObjIdClient = 0xFFFFFFFC;
const uint ObjIdWindow = 0;
var iidAccessible = new Guid("618736E0-3C3D-11CF-810C-00AA00389B71");

void Stage(string name)
{
    Console.Error.WriteLine(JsonSerializer.Serialize(new { utc = DateTimeOffset.UtcNow, stage = name }));
    Console.Error.Flush();
}
object? OptionalMetadata(Func<object?> read)
{
    try { return read(); }
    catch { return null; }
}

var expected = args[0];
var mode = args.Length == 2 && !string.IsNullOrWhiteSpace(args[1]) ? args[1] : "baseline";
if (mode is not ("baseline" or "pulse-screen-reader" or "pulse-narrator"))
{
    Console.Error.WriteLine("Usage: ReadOnlyProbe <exact target group title> [baseline|pulse-screen-reader|pulse-narrator]");
    return 2;
}

int ReadScreenReaderFlag()
{
    int value = 0;
    Native.SystemParametersInfoGet(SpiGetScreenReader, 0, ref value, 0);
    return value;
}
void WriteScreenReaderFlag(bool enable)
{
    Native.SystemParametersInfoSet(SpiSetScreenReader, enable ? 1u : 0u, IntPtr.Zero, SpifSendChange);
}

Stage("env");
var weixinVersion = OptionalMetadata(() => FileVersionInfo.GetVersionInfo(@"C:\Program Files\Tencent\Weixin\Weixin.exe").FileVersion);
var narratorRunning = Process.GetProcessesByName("Narrator").Length > 0;
var weixinProcessCount = Process.GetProcessesByName("Weixin").Length;
var screenReaderBefore = ReadScreenReaderFlag();

using var automation = new UIA3Automation();
Stage("uia_ready");

object Capture(string label)
{
    Stage("capture_" + label);
    var pids = Process.GetProcessesByName("Weixin").Select(p => p.Id).ToHashSet();
    var hwnds = new List<IntPtr>();
    var mainHandles = Process.GetProcessesByName("Weixin")
        .Select(p => p.MainWindowHandle)
        .Where(h => h != IntPtr.Zero)
        .ToHashSet();
    Native.EnumWindows((hwnd, _) =>
    {
        Native.GetWindowThreadProcessId(hwnd, out uint pid);
        if (!pids.Contains((int)pid) || hwnds.Count >= 12) return true;
        if (Native.IsWindowVisible(hwnd) || mainHandles.Contains(hwnd)) hwnds.Add(hwnd);
        return true;
    }, IntPtr.Zero);
    foreach (var handle in mainHandles)
        if (!hwnds.Contains(handle)) hwnds.Insert(0, handle);

    var windows = new List<object>();
    bool matched = false;
    int mmuiNodes = 0;
    int rawNodes = 0;
    foreach (var hwnd in hwnds)
    {
        Stage("from_handle_" + hwnd.ToInt64().ToString("x"));
        try
        {
            var window = automation.FromHandle(hwnd);
            var walker = automation.TreeWalkerFactory.GetRawViewWalker();
            var queue = new Queue<(AutomationElement element, int depth)>();
            queue.Enqueue((window, 0));
            var tree = new List<object>();
            int windowMmui = 0;
            int automationIdPresent = 0;
            bool titleMatch = false;
            while (queue.Count > 0 && tree.Count < 80)
            {
                var (element, depth) = queue.Dequeue();
                var className = OptionalMetadata(() => element.ClassName) as string;
                var exactTarget = OptionalMetadata(() => element.Name == expected) as bool?;
                var automationPresent = OptionalMetadata(() => !string.IsNullOrEmpty(element.AutomationId)) as bool?;
                if (className != null && (className.StartsWith("mmui::", StringComparison.Ordinal) || className.StartsWith("mmui:", StringComparison.OrdinalIgnoreCase)))
                    windowMmui++;
                if (automationPresent == true) automationIdPresent++;
                if (exactTarget == true) titleMatch = true;
                tree.Add(new
                {
                    depth,
                    class_name = className,
                    control_type = OptionalMetadata(() => element.ControlType.ToString()),
                    framework = OptionalMetadata(() => element.Properties.FrameworkId.Value),
                    automation_id_present = automationPresent,
                    exact_target_name = exactTarget
                });
                if (depth >= 6) continue;
                var child = walker.GetFirstChild(element);
                for (int i = 0; child != null && i < 20 && queue.Count < 80; i++)
                {
                    queue.Enqueue((child, depth + 1));
                    child = walker.GetNextSibling(child);
                }
            }
            Console.Error.WriteLine(JsonSerializer.Serialize(new { stage = "raw_tree_result", label, hwnd = hwnd.ToInt64().ToString("x"), nodes = tree, pending = queue.Count }));
            Console.Error.Flush();
            var nativeClass = new StringBuilder(256);
            Native.GetClassName(hwnd, nativeClass, nativeClass.Capacity);
            var nativeClassName = nativeClass.ToString();
            bool inspectSelectors = nativeClassName == "Qt51514QWindowIcon" || mainHandles.Contains(hwnd);
            var titles = Array.Empty<AutomationElement>();
            var messages = Array.Empty<AutomationElement>();
            var inputs = Array.Empty<AutomationElement>();
            bool selectorTitleMatches = false;
            if (inspectSelectors)
            {
                Stage("query_titles");
                titles = window.FindAllDescendants(cf => cf.ByAutomationId(
                    "content_view.top_content_view.title_h_view.left_v_view.left_content_v_view.left_ui_.big_title_line_h_view"));
                Stage("titles_read");
                selectorTitleMatches = titles.Any(title => title.Name == expected ||
                    title.FindAllChildren().Any(child => child.Name == expected));
                Stage("query_messages");
                messages = window.FindAllDescendants(cf => cf.ByAutomationId("chat_message_list"));
                Stage("query_inputs");
                inputs = window.FindAllDescendants(cf => cf.ByAutomationId("chat_input_field"));
                Stage("queries_complete");
            }
            else Stage("skip_selectors_" + nativeClassName);
            matched |= selectorTitleMatches && messages.Length == 1 && inputs.Length == 1;
            mmuiNodes += windowMmui;
            rawNodes += tree.Count;
            windows.Add(new
            {
                process_id = OptionalMetadata(() => { Native.GetWindowThreadProcessId(hwnd, out uint pid); return (int)pid; }),
                hwnd_hex = hwnd.ToInt64().ToString("x"),
                is_visible = Native.IsWindowVisible(hwnd),
                is_main_window_handle = mainHandles.Contains(hwnd),
                native_class = nativeClassName,
                window_class = OptionalMetadata(() => window.ClassName),
                is_offscreen = OptionalMetadata(() => window.Properties.IsOffscreen.Value),
                raw_node_count = tree.Count,
                raw_pending = queue.Count,
                mmui_class_nodes = windowMmui,
                automation_id_present_count = automationIdPresent,
                raw_target_title_exact_match = titleMatch,
                msaa_client_child_count = MsaaChildCount(hwnd, ObjIdClient),
                msaa_window_child_count = MsaaChildCount(hwnd, ObjIdWindow),
                title_nodes = titles.Length,
                target_title_exact_match = selectorTitleMatches,
                message_list_nodes = messages.Length,
                input_nodes = inputs.Length
            });
        }
        catch (Exception ex)
        {
            windows.Add(new { hwnd_hex = hwnd.ToInt64().ToString("x"), error_type = ex.GetType().Name });
        }
    }
    return new
    {
        label,
        screen_reader_flag = ReadScreenReaderFlag(),
        window_count = windows.Count,
        raw_node_count = rawNodes,
        mmui_class_nodes = mmuiNodes,
        ui_structure_pass = matched,
        windows
    };
}

object beforeCapture;
object? afterCapture = null;
int? screenReaderDuring = null;
int screenReaderAfter = screenReaderBefore;
try
{
    beforeCapture = Capture("before");
    if (mode == "pulse-screen-reader")
    {
        Stage("set_screen_reader_true");
        WriteScreenReaderFlag(true);
        screenReaderDuring = ReadScreenReaderFlag();
        Thread.Sleep(2000);
        afterCapture = Capture("after");
    }
    else if (mode == "pulse-narrator")
    {
        Stage("start_narrator");
        Process.Start(new ProcessStartInfo
        {
            FileName = Path.Combine(Environment.SystemDirectory, "Narrator.exe"),
            UseShellExecute = true
        });
        Thread.Sleep(3000);
        screenReaderDuring = ReadScreenReaderFlag();
        afterCapture = Capture("after");
    }
}
finally
{
    if (mode is "pulse-screen-reader" or "pulse-narrator")
    {
        if (mode == "pulse-narrator")
        {
            Stage("stop_narrator");
            foreach (var narrator in Process.GetProcessesByName("Narrator"))
            {
                try { narrator.Kill(); }
                catch { }
            }
        }
        Stage("restore_screen_reader");
        WriteScreenReaderFlag(screenReaderBefore != 0);
        Thread.Sleep(200);
        screenReaderAfter = ReadScreenReaderFlag();
    }
}

Stage("output");
var matchedFinal = afterCapture != null
    ? ((dynamic)afterCapture).ui_structure_pass == true
    : ((dynamic)beforeCapture).ui_structure_pass == true;
Console.WriteLine(JsonSerializer.Serialize(new
{
    utc = DateTimeOffset.UtcNow,
    probe = "flaui5-readonly-v6-accessibility",
    mode,
    weixin_file_version = weixinVersion,
    weixin_process_count = weixinProcessCount,
    narrator_running = narratorRunning,
    screen_reader_before = screenReaderBefore,
    screen_reader_during = screenReaderDuring,
    screen_reader_after = screenReaderAfter,
    ui_structure_pass = matchedFinal,
    sdk_acceptance_pass = false,
    real_mention_verified = false,
    send_enabled = false,
    before = beforeCapture,
    after = afterCapture
}, new JsonSerializerOptions { WriteIndented = true }));
return matchedFinal ? 0 : 3;

int? MsaaChildCount(IntPtr hwnd, uint objectId)
{
    try
    {
        var iid = iidAccessible;
        var hr = Native.AccessibleObjectFromWindow(hwnd, objectId, ref iid, out var obj);
        if (hr != 0 || obj == null) return null;
        var count = obj.GetType().InvokeMember("accChildCount", BindingFlags.GetProperty, null, obj, null);
        return count == null ? null : Convert.ToInt32(count);
    }
    catch
    {
        return null;
    }
}

internal static class Native
{
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW")]
    public static extern bool SystemParametersInfoGet(uint uiAction, uint uiParam, ref int pvParam, uint fWinIni);

    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW")]
    public static extern bool SystemParametersInfoSet(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);

    [DllImport("oleacc.dll")]
    public static extern int AccessibleObjectFromWindow(IntPtr hwnd, uint dwObjectID, ref Guid riid,
        [MarshalAs(UnmanagedType.Interface)] out object ppvObject);
}
