# Compilación y programación

## VS Code

En Terminal > Run Task utilice:

1. Configure GD32 Debug.
2. Build GD32 Debug.
3. Flash GD32 Debug.

Build + Flash GD32 Assembly Array ejecuta el flujo completo.

## PowerShell

    powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\configure.ps1 -BuildType Debug
    cmake --build --preset build-debug
    powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\flash.ps1 -BuildType Debug

Se generan ELF, HEX, BIN, MAP y LST en build/debug.

OpenOCD debe terminar con Programming Finished, Verified OK y Resetting Target.
El LED debe emitir cinco pulsos, hacer una pausa y repetir.

