using System.Diagnostics;
using System.Text.Json;
using FlaUI.UIA3;
using FlaUI.Core.AutomationElements;

// A prerequisite probe using the SDK's UIA dependencies, not SDK acceptance.
// No SDK initialization, input, focus, screenshots, network or message contents.
if (args.Length != 1 || string.IsNullOrWhiteSpace(args[0]))
{
    Console.Error.WriteLine("Usage: ReadOnlyProbe <exact target group title>");
    return 2;
}
void Stage(string name) { Console.Error.WriteLine(JsonSerializer.Serialize(new { utc = DateTimeOffset.UtcNow, stage = name })); Console.Error.Flush(); }
object? OptionalMetadata(Func<object?> read) { try { return read(); } catch { return null; } }
var expected = args[0];
Stage("uia_init");
using var automation = new UIA3Automation();
Stage("uia_ready");
var summaries = new List<object>();
bool matched = false;
foreach (var process in Process.GetProcessesByName("Weixin"))
{
    using (process)
    {
        Stage("main_handle_" + process.Id);
        var handle = process.MainWindowHandle;
        if (handle == IntPtr.Zero) continue;
        Stage("from_handle_" + process.Id);
        var windows = new[] { automation.FromHandle(handle) };
        foreach (var window in windows)
        {
            try
            {
                Stage("raw_tree_begin");
                var walker = automation.TreeWalkerFactory.GetRawViewWalker();
                var queue = new Queue<(AutomationElement element, int depth)>();
                queue.Enqueue((window, 0));
                var tree = new List<object>();
                while (queue.Count > 0 && tree.Count < 80)
                {
                    var (element, depth) = queue.Dequeue();
                    tree.Add(new {
                        depth,
                        class_name = OptionalMetadata(() => element.ClassName),
                        control_type = OptionalMetadata(() => element.ControlType.ToString()),
                        framework = OptionalMetadata(() => element.Properties.FrameworkId.Value),
                        automation_id_present = OptionalMetadata(() => !string.IsNullOrEmpty(element.AutomationId)),
                        exact_target_name = OptionalMetadata(() => element.Name == expected)
                    });
                    if (depth >= 6) continue;
                    var child = walker.GetFirstChild(element);
                    for (int i = 0; child != null && i < 20 && queue.Count < 80; i++)
                    {
                        queue.Enqueue((child, depth + 1));
                        child = walker.GetNextSibling(child);
                    }
                }
                Console.Error.WriteLine(JsonSerializer.Serialize(new { stage = "raw_tree_result", nodes = tree, pending = queue.Count }));
                Console.Error.Flush();
                Stage("query_titles");
                var titles = window.FindAllDescendants(cf => cf.ByAutomationId(
                    "content_view.top_content_view.title_h_view.left_v_view.left_content_v_view.left_ui_.big_title_line_h_view"));
                Stage("titles_read");
                bool titleMatches = titles.Any(title => title.Name == expected ||
                    title.FindAllChildren().Any(child => child.Name == expected));
                Stage("query_messages");
                var messages = window.FindAllDescendants(cf => cf.ByAutomationId("chat_message_list"));
                Stage("query_inputs");
                var inputs = window.FindAllDescendants(cf => cf.ByAutomationId("chat_input_field"));
                Stage("queries_complete");
                matched |= titleMatches && messages.Length == 1 && inputs.Length == 1;
                summaries.Add(new {
                    process_id = process.Id,
                    window_class = window.ClassName,
                    is_offscreen = OptionalMetadata(() => window.Properties.IsOffscreen.Value),
                    child_classes = OptionalMetadata(() => window.FindAllChildren().Select(child => child.ClassName).ToArray()),
                    title_nodes = titles.Length,
                    target_title_exact_match = titleMatches,
                    message_list_nodes = messages.Length,
                    input_nodes = inputs.Length
                });
            }
            catch (Exception ex)
            {
                summaries.Add(new { process_id = process.Id, error_type = ex.GetType().Name });
            }
        }
    }
}
Stage("output");
Console.WriteLine(JsonSerializer.Serialize(new {
    utc = DateTimeOffset.UtcNow,
    probe = "flaui5-readonly-prerequisite",
    ui_structure_pass = matched,
    sdk_acceptance_pass = false,
    real_mention_verified = false,
    send_enabled = false,
    windows = summaries
}, new JsonSerializerOptions { WriteIndented = true }));
return matched ? 0 : 3;
