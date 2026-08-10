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

foreach ($VariableName in @(
    "GD32_SDK_ROOT",
    "NUCLEI_TOOLCHAIN_DIR",
    "OPENOCD_ROOT"
)) {
    $Value = Get-Variable -Name $VariableName -ValueOnly `
        -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "The variable $VariableName is not configured."
    }
}

# Export the values so CMake try_compile receives the same toolchain paths.
$env:GD32_SDK_ROOT = $GD32_SDK_ROOT
$env:NUCLEI_TOOLCHAIN_DIR = $NUCLEI_TOOLCHAIN_DIR
$env:OPENOCD_ROOT = $OPENOCD_ROOT

$Preset = if ($BuildType -eq "Release") {
    "gd32-release"
} else {
    "gd32-debug"
}

Push-Location $ProjectRoot
try {
    & cmake `
        --preset $Preset `
        "-DGD32_SDK_ROOT=$GD32_SDK_ROOT" `
        "-DNUCLEI_TOOLCHAIN_DIR=$NUCLEI_TOOLCHAIN_DIR"

    if ($LASTEXITCODE -ne 0) {
        throw "CMake configuration failed with code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}

