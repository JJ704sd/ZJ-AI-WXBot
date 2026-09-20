param([Parameter(Mandatory=$true)][string]$ImagePath,
      [Parameter(Mandatory=$true)][string]$OutputPath,
      [string]$Language = 'zh-Hans')
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Add-Type -AssemblyName System.Runtime.WindowsRuntime
[Windows.Storage.StorageFile,Windows.Storage,ContentType=WindowsRuntime] > $null
[Windows.Graphics.Imaging.BitmapDecoder,Windows.Graphics.Imaging,ContentType=WindowsRuntime] > $null
[Windows.Media.Ocr.OcrEngine,Windows.Foundation,ContentType=WindowsRuntime] > $null
[Windows.Globalization.Language,Windows.Globalization,ContentType=WindowsRuntime] > $null
$taskMethod = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and $_.IsGenericMethod -and $_.GetParameters().Count -eq 1 -and
    $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
} | Select-Object -First 1
function AwaitResult($operation, [Type]$resultType) {
    $task = $taskMethod.MakeGenericMethod($resultType).Invoke($null, @($operation))
    $task.Wait()
    return $task.Result
}
$stream = $null
$bitmap = $null
$stage = 'ocr_initialization_failed'
try {
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage(
        [Windows.Globalization.Language]::new($Language))
    if ($null -eq $engine) { $stage = 'ocr_language_unavailable'; throw 'unavailable' }
    $stage = 'ocr_decode_failed'
    $file = AwaitResult ([Windows.Storage.StorageFile]::GetFileFromPathAsync($ImagePath)) ([Windows.Storage.StorageFile])
    $stream = AwaitResult ($file.OpenAsync(0)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitResult ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $bitmap = AwaitResult ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $stage = 'ocr_recognition_failed'
    $recognized = AwaitResult ($engine.RecognizeAsync($bitmap)) ([Windows.Media.Ocr.OcrResult])
    $rows = @($recognized.Lines | ForEach-Object {
        $line = $_
        $left = [double]::PositiveInfinity; $top = [double]::PositiveInfinity
        $right = 0.0; $bottom = 0.0
        foreach ($word in $line.Words) {
            $r = $word.BoundingRect
            $left = [Math]::Min($left, $r.X); $top = [Math]::Min($top, $r.Y)
            $right = [Math]::Max($right, $r.X + $r.Width)
            $bottom = [Math]::Max($bottom, $r.Y + $r.Height)
        }
        @{text=$line.Text; box=@($left,$top,$right,$bottom)}
    })
    $json = ConvertTo-Json -InputObject @{status='ok'; lines=$rows} -Depth 6 -Compress
    [IO.File]::WriteAllText($OutputPath, $json, [Text.UTF8Encoding]::new($false))
} catch {
    # Never serialize exceptions that may contain private image paths/text.
    $failure = @{status=$stage; error_type=$_.Exception.GetType().FullName;
        hresult=$_.Exception.HResult} | ConvertTo-Json -Compress
    [IO.File]::WriteAllText($OutputPath, $failure, [Text.UTF8Encoding]::new($false))
    exit 2
} finally {
    if ($null -ne $bitmap) { $bitmap.Dispose() }
    if ($null -ne $stream) { $stream.Dispose() }
}
