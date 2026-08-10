# Depuración de C y ensamblador

## Preparación

    powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\create_debug_config.ps1

Seleccione Debug GD32VW553 - Cortex Debug y presione F5.

## Breakpoints

Primer breakpoint:

    g_sum_asm = riscv_array_sum(test_values, length);

Use F11 para entrar en riscv_array_sum.

Segundo breakpoint:

    g_results_match = (g_sum_c == g_sum_asm) && (g_max_c == g_max_asm);

Valores finales:

    g_sum_c = 8
    g_sum_asm = 8
    g_max_c = 5
    g_max_asm = 5
    g_results_match = 1

Antes de la llamada, a0 contiene la dirección del arreglo y a1 contiene 6.
Durante la suma, t0 recorre el arreglo, t1 cuenta, t2 contiene el dato leído y
a0 acumula. Al retornar, a0 vale 8. En la función de máximo retorna 5.

| Tecla | Acción |
|---|---|
| F5 | Continuar |
| F10 | Step Over |
| F11 | Step Into |
| Shift+F11 | Step Out |
| Shift+F5 | Detener |

