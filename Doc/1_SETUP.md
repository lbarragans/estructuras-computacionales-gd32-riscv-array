# Configuración del entorno

## Requisitos

- Windows 10 u 11.
- Visual Studio Code.
- CMake 3.20 o superior.
- Ninja.
- GD32 Embedded Builder con Nuclei RISC-V GCC.
- GD32VW55x Firmware Library V1.6.0.
- OpenOCD.
- Depurador CMSIS-DAP/WCH-Link.

## Extensiones

- C/C++ de Microsoft.
- CMake Tools.
- Cortex-Debug.

## Configuración privada

Ejecute:

    Copy-Item .\tools\local_config.example.ps1 .\tools\local_config.ps1

Edite:

    $GD32_SDK_ROOT = "C:/ruta/GD32VW55x_Firmware_Library_V1.6.0"
    $NUCLEI_TOOLCHAIN_DIR = "C:/ruta/NucleiRISCVGCC/bin"
    $OPENOCD_ROOT = "C:/ruta/OpenOCD/xpack-openocd-0.11.0-3"

local_config.ps1 y .vscode/launch.json se excluyen de Git porque contienen
rutas propias de cada computador.

tools/configure.ps1 exporta las rutas antes de invocar CMake para que
try_compile encuentre el compilador.

Abra directamente 02_RISCV_Assembly_Array como carpeta raíz. Si aparece
Restricted Mode, seleccione Trust this folder.

