# Integracion pendiente de FreeRTOS

Para compilar este apartado deben integrarse:

```text
FreeRTOS kernel
port RISC-V compatible con GD32VW553
FreeRTOSConfig.h
heap_x.c
tick
context switch
queue.c
includes del kernel
fuentes del kernel en CMake
```

## Configuracion necesaria

Debe estar habilitada la API de retardo utilizada:

```text
INCLUDE_vTaskDelay = 1
```

## Diferencia con la referencia original

La referencia utiliza C + rutinas RISC-V.

El apartado FreeRTOS puro no llama:

```text
riscv_array_sum()
riscv_array_max()
```

El procesamiento se realiza dentro de `ProcessorTask` en C y la transferencia de
trabajo/resultados se hace con queues.

## Validacion

Solo marcar como validada despues de:

1. configurar;
2. compilar;
3. enlazar;
4. arrancar scheduler;
5. crear las dos queues;
6. crear las tres tareas;
7. obtener suma 8;
8. obtener maximo 5;
9. observar cinco pulsos en PC13.
