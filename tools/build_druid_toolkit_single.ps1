param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [string]$OutFile = ''
)

$ErrorActionPreference = 'Stop'

$scriptPath = Join-Path $ProjectRoot 'scripts/druid_toolkit.lua'
$otuiPath = Join-Path $ProjectRoot 'ui/druid_toolkit.otui'
if([string]::IsNullOrWhiteSpace($OutFile)) {
  $OutFile = Join-Path $ProjectRoot 'druid_toolkit_single.lua'
}

if(!(Test-Path $scriptPath)) { throw "Missing: $scriptPath" }
if(!(Test-Path $otuiPath)) { throw "Missing: $otuiPath" }

$lua = Get-Content -Path $scriptPath -Raw
$otui = Get-Content -Path $otuiPath -Raw

function Get-Delimiter([string[]]$texts) {
  for($n=2; $n -le 30; $n++) {
    $eq = '=' * $n
    $close = ']' + $eq + ']'
    $ok = $true
    foreach($t in $texts) {
      if($t.Contains($close)) { $ok = $false; break }
    }
    if($ok) { return $eq }
  }
  throw 'Unable to find safe Lua long-string delimiter.'
}

$eq = Get-Delimiter @($lua, $otui)
$open = '[' + $eq + '['
$close = ']' + $eq + ']'

$out = @"
-- AUTO-GENERATED FILE. DO NOT EDIT BY HAND.
-- Build command:
--   powershell -ExecutionPolicy Bypass -File tools/build_druid_toolkit_single.ps1
--
-- Portable single-file Druid Toolkit:
-- 1) Copy this file into any bot profile folder.
-- 2) Run from Ingame Script Editor with:
--    dofile('druid_toolkit_single.lua')

__druid_toolkit_otui_inline = $open
$otui
$close

local __druid_toolkit_source = $open
$lua
$close

local __ok, __err = pcall(function()
  local __chunk, __loadErr = load(__druid_toolkit_source, 'scripts/druid_toolkit.lua')
  if not __chunk then error(__loadErr) end
  __chunk()
end)

if not __ok then
  print('[DruidToolkitSingle] FAILED: ' .. tostring(__err))
else
  print('[DruidToolkitSingle] Loaded.')
end

__druid_toolkit_source = nil
"@

Set-Content -Path $OutFile -Value $out -Encoding UTF8
Write-Output "Built: $OutFile"
