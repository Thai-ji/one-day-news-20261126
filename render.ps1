param(
    [string]$OutFile = 'entry.png'
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $root 'design.html'
$png = Join-Path $root $OutFile

if (-not (Test-Path $html)) {
    throw "design.html not found at $html"
}

$edgeCandidates = @(
    'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
    'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
    'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
)
$edge = $null
foreach ($candidate in $edgeCandidates) {
    if (Test-Path $candidate) { $edge = $candidate; break }
}
if (-not $edge) {
    throw 'Microsoft Edge executable not found.'
}

if (Test-Path $png) {
    Remove-Item -LiteralPath $png -Force
}

$profile = Join-Path $env:TEMP ('news26-edge-' + [guid]::NewGuid().ToString('N'))
$uri = ([System.Uri]$html).AbsoluteUri

& $edge --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 `
    --window-size=1024,1024 --screenshot=$png --virtual-time-budget=5000 `
    --user-data-dir=$profile $uri | Out-Null

if (-not (Test-Path $png)) {
    throw "Edge produced no screenshot at $png"
}

$bytes = [System.IO.File]::ReadAllBytes($png)
$signature = ($bytes[0..7] | ForEach-Object { $_.ToString('x2') }) -join ''
if ($signature -ne '89504e470d0a1a0a') {
    throw "Output is not a PNG (signature $signature)"
}
$width = ([int]$bytes[16] -shl 24) -bor ([int]$bytes[17] -shl 16) -bor ([int]$bytes[18] -shl 8) -bor [int]$bytes[19]
$height = ([int]$bytes[20] -shl 24) -bor ([int]$bytes[21] -shl 16) -bor ([int]$bytes[22] -shl 8) -bor [int]$bytes[23]
if ($width -ne 1024 -or $height -ne 1024) {
    throw "Expected 1024x1024, got ${width}x${height}"
}
if ($bytes.Length -gt 1048576) {
    throw "PNG is $($bytes.Length) bytes, over the 1 MiB limit"
}

Remove-Item -Recurse -Force -LiteralPath $profile -ErrorAction SilentlyContinue

Write-Output ("rendered {0}: {1} bytes, {2}x{3}" -f $OutFile, $bytes.Length, $width, $height)
