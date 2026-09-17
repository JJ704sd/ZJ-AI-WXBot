param([Parameter(Mandatory=$true)][string]$ReadyPath)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework
$window = New-Object System.Windows.Window
$window.Title = 'Synthetic UIA native provider'
$window.Width = 360
$window.Height = 160
$window.ShowActivated = $false
$window.ShowInTaskbar = $false
$box = New-Object System.Windows.Controls.TextBox
$box.Text = 'uia-v3-synthetic-value'
$box.IsReadOnly = $true
$box.Margin = '20'
$window.Content = $box
$window.Add_ContentRendered({
    $handle = (New-Object System.Windows.Interop.WindowInteropHelper($window)).Handle
    $json = @{hwnd=$handle.ToInt64(); pid=$PID} | ConvertTo-Json -Compress
    [IO.File]::WriteAllText($ReadyPath, $json)
})
$app = New-Object System.Windows.Application
[void]$app.Run($window)
