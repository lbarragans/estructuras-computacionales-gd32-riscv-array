# 7. Plan de validacion

## Referencia original

Comprobar primero:

```text
suma C       = 8
suma RISC-V  = 8
maximo C     = 5
maximo RISC-V= 5
```

y la secuencia de cinco pulsos en PC13.

## Ensamblador RISC-V puro

Validar:

1. integracion de `Ensamblador_RISCV_Puro/main.S`;
2. ausencia de archivos `.c` dentro del apartado;
3. arreglo correcto en `.rodata`;
4. seis cargas de elementos mediante el bucle;
5. suma esperada igual a 8;
6. maximo signed esperado igual a 5;
7. variables de depuracion actualizadas;
8. configuracion directa de GPIOC;
9. cinco pulsos si los resultados son correctos;
10. parpadeo rapido si la comprobacion falla;
11. prueba fisica en placa.

## FreeRTOS puro

Validar:

1. kernel FreeRTOS;
2. port RISC-V;
3. `FreeRTOSConfig.h`;
4. heap;
5. creacion de queues;
6. creacion de ProducerTask;
7. creacion de ProcessorTask;
8. creacion de IndicatorTask;
9. transferencia del trabajo por queue;
10. transferencia del resultado por queue;
11. suma igual a 8;
12. maximo igual a 5;
13. uso de `vTaskDelay()` sin busy-wait;
14. cinco pulsos en la placa;
15. ausencia de llamadas a `riscv_array_sum()` y `riscv_array_max()` en este apartado.

## Estados

- referencia funcional;
- fuente lista;
- integrada mediante `APP_VARIANT=assembly` o como aplicacion MSDK FreeRTOS;
- validada por compilacion;
- validada en placa.

## Comandos de validacion en VS Code

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build_variant.ps1 -Variant original -Flash
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build_variant.ps1 -Variant assembly -Flash
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build_freertos.ps1 -Clean -Flash
```

La referencia debe indicar coincidencia entre C y Assembly. Las variantes
Assembly pura y FreeRTOS deben producir cinco pulsos en PC13; el patron rapido
de error no debe aparecer.
