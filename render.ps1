$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
if (-not (Test-Path $edge)) { $edge = 'C:\Program Files\Microsoft\Edge\Application\msedge.exe' }
if (-not (Test-Path $edge)) { throw 'Microsoft Edge not found' }

$html = Join-Path $here 'design.html'
$png  = Join-Path $here 'entry.png'
if (-not (Test-Path $html)) { throw "design.html not found: $html" }
if (Test-Path $png) { Remove-Item $png -Force }

$url = 'file:///' + ($html -replace '\\', '/')
$args = @(
  '--headless=new', '--disable-gpu', '--hide-scrollbars',
  '--force-device-scale-factor=1', '--window-size=1024,1024',
  "--screenshot=$png", '--virtual-time-budget=6000', $url
)
$p = Start-Process -FilePath $edge -ArgumentList $args -NoNewWindow -PassThru -Wait
if ($p.ExitCode -ne 0) { throw "Edge exited $($p.ExitCode)" }

for ($i = 0; $i -lt 50; $i++) {
  if ((Test-Path $png) -and ((Get-Item $png).Length -gt 0)) { break }
  Start-Sleep -Milliseconds 200
}
if (-not (Test-Path $png)) { throw 'screenshot was not produced' }

$f = Get-Item $png
Write-Output ("RENDERED {0} bytes {1}" -f $f.Length, $f.FullName)
