[CmdletBinding()]
param(
    [ValidateSet("Debug", "Release")]
    [string]$BuildType = "Debug"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ConfigFile = Join-Path $PSScriptRoot "local_config.ps1"

if (-not (Test-Path $ConfigFile)) {
    throw @"
Missing tools/local_config.ps1.
Copy tools/local_config.example.ps1 as tools/local_config.ps1 and edit it.
"@
}

. $ConfigFile

if ([string]::IsNullOrWhiteSpace($OPENOCD_ROOT)) {
    throw "OPENOCD_ROOT is not configured."
}

$OpenOcdExe = Join-Path $OPENOCD_ROOT "bin/openocd.exe"
$OpenOcdScripts = Join-Path $OPENOCD_ROOT "scripts"
$BuildFolder = $BuildType.ToLowerInvariant()
$ElfPath = Join-Path `
    $ProjectRoot "build/$BuildFolder/GD32VW55x.elf"

foreach ($RequiredPath in @(
    $OpenOcdExe,
    $OpenOcdScripts,
    $ElfPath
)) {
    if (-not (Test-Path $RequiredPath)) {
        throw "Required path was not found: $RequiredPath"
    }
}

$ElfForOpenOcd = (Resolve-Path $ElfPath).Path.Replace("\", "/")
$ProgramCommand = `
    "program {$ElfForOpenOcd} verify reset exit"

& $OpenOcdExe `
    -s $OpenOcdScripts `
    -f "interface/cmsis-dap.cfg" `
    -c "cmsis_dap_backend usb_bulk" `
    -c "cmsis_dap_vid_pid 0x1a86 0x8012" `
    -c "transport select jtag" `
    -c "adapter speed 50" `
    -f "target/gd32vw55x.cfg" `
    -c $ProgramCommand

if ($LASTEXITCODE -ne 0) {
    throw "OpenOCD failed with code $LASTEXITCODE."
}

