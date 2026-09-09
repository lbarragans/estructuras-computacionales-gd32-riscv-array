# 09 - FreeRTOS: productor -> procesador -> verificador

## Lenguajes / tecnologia

- C
- Assembly RISC-V
- FreeRTOS como RTOS

## Arquitectura

```text
Producer
   ↓ Queue
Processor Assembly
   ↓ Queue
Verifier C
```

## Cuando tiene sentido

Si los bloques de datos llegan periodicamente desde:

- ADC;
- UART;
- red;
- sensor;
- DMA;

y otras tareas deben ejecutarse simultaneamente.

## Cuando NO tiene sentido

Para procesar una sola constante una unica vez, esta arquitectura es demasiado
compleja.

## Por que esta pendiente

El CMake principal no incluye todavia:

- kernel;
- port RISC-V;
- `FreeRTOSConfig.h`;
- heap;
- tick;
- context switch.

## Estado

**Integracion pendiente.**
