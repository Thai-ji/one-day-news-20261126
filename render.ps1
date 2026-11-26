#!/usr/bin/env pwsh
# Render design.html to entry.png with headless Microsoft Edge.
# Usage: powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\render.ps1
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $root 'design.html'
$png  = Join-Path $root 'entry.png'

if (-not (Test-Path $html)) { throw "design.html not found at $html" }
if (Test-Path $png) { Remove-Item $png -Force }

$edgeCandidates = @(
  'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
  'C:\Program Files\Microsoft\Edge\Application\msedge.exe'
)
$edge = $edgeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Microsoft Edge not found in the standard install locations.' }

$uri = ([System.Uri]$html).AbsoluteUri
$edgeArgs = @(
  '--headless=new',
  '--disable-gpu',
  '--hide-scrollbars',
  '--force-device-scale-factor=1',
  '--window-size=1024,1024',
  "--screenshot=$png",
  '--virtual-time-budget=5000',
  $uri
)

& $edge @edgeArgs | Out-Null

$deadline = (Get-Date).AddSeconds(25)
while (-not (Test-Path $png) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 200 }
if (-not (Test-Path $png)) { throw 'entry.png was not produced by Edge.' }

$item = Get-Item $png
$bytes = [System.IO.File]::ReadAllBytes($png)
$width = ([int]$bytes[16] * 16777216) + ([int]$bytes[17] * 65536) + ([int]$bytes[18] * 256) + [int]$bytes[19]
$height = ([int]$bytes[20] * 16777216) + ([int]$bytes[21] * 65536) + ([int]$bytes[22] * 256) + [int]$bytes[23]
Write-Output ("entry.png: {0} bytes, {1}x{2}" -f $item.Length, $width, $height)

