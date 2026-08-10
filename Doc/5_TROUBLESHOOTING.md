# Solución de problemas

## No se encuentra el compilador

Revise tools/local_config.ps1. La ruta debe terminar en NucleiRISCVGCC/bin.
configure.ps1 exporta la ruta para try_compile.

## CMake conserva datos anteriores

    Remove-Item .\build -Recurse -Force -ErrorAction SilentlyContinue

Vuelva a configurar.

## Undefined reference to riscv_array_sum

Confirme que CMakeLists.txt incluya Src/array_riscv.S y que el archivo declare
.global riscv_array_sum y .global riscv_array_max.

## El LED parpadea rápidamente

Compare g_sum_c, g_sum_asm, g_max_c y g_max_asm.

## WATCH está vacío

Despliegue Global en VARIABLES, pulse + junto a WATCH o use Add to Watch.

## optimized out

La optimización puede ocultar variables locales. Observe las variables globales
volatile y los registros.

## OpenOCD no detecta la placa

Cierre otros programas que utilicen el depurador, revise alimentación y JTAG,
confirme interface/cmsis-dap.cfg y mantenga adapter speed 100.

