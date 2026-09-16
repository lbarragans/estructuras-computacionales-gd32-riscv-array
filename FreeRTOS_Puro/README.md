# Procesamiento de arreglos con FreeRTOS puro

## Que significa "puro"

FreeRTOS no es un lenguaje; la aplicacion esta escrita en C.

Aqui "puro" significa que la organizacion del ejercicio usa directamente
primitivas del RTOS y que esta implementacion no llama las rutinas RISC-V de la
referencia.

## Arquitectura

```text
ProducerTask
    ↓ job_queue
ProcessorTask
    ↓ result_queue
IndicatorTask
    ↓ PC13
```

## ProducerTask

Publica periodicamente:

```text
puntero al arreglo
longitud
```

## ProcessorTask

Calcula en C:

```text
suma
maximo
```

y envia una estructura de resultado.

## IndicatorTask

Valida:

```text
suma   == 8
maximo == 5
```

Si es correcto muestra cinco pulsos.

Si falla muestra una secuencia rapida.

## Conceptos FreeRTOS

- `xTaskCreate`;
- `xQueueCreate`;
- `xQueueSend`;
- `xQueueReceive`;
- `vTaskDelay`;
- prioridades;
- tareas bloqueadas;
- transferencia de datos entre tareas.

## Estado

Aplicacion MSDK completa. El kernel, port, heap y tick provienen del SDK
oficial V1.0.3g según `INTEGRACION.md`.
