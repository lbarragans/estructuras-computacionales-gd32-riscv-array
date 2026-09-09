# Variantes del ejercicio

## Objetivo de esta sección

Un mismo resultado visible puede obtenerse con arquitecturas de software distintas. Esta sección sirve como menú comparativo y como guía de estudio.

## Formas de implementación

| Variante | Lenguaje / tecnología | Idea principal | Estado |
|---|---|---|---|
| C bare-metal | C | acceso a periféricos y ejecución secuencial | disponible / relacionada |
| Assembly RISC-V | Assembly | instrucciones y registros directamente visibles | por implementar o enlazar |
| Interrupciones | C / Assembly | reacción a eventos sin espera activa | disponible / relacionada |
| Máquina de estados | C | comportamiento no bloqueante | disponible / relacionada |
| Scheduler cooperativo | C | varias tareas sin RTOS completo | relacionada |
| FreeRTOS | C + FreeRTOS | tareas administradas por un scheduler | siguiente evolución |
| Híbrido C + Assembly | C + Assembly | combinar abstracción y control de bajo nivel | siguiente evolución |

> **Importante:** FreeRTOS no es un lenguaje. Normalmente se programa en C. Por eso GitHub puede mostrar `C 100%` aunque la técnica usada sea FreeRTOS.

## ¿Por qué conservar varias soluciones?

Porque dos programas pueden producir exactamente el mismo resultado físico y, sin embargo, utilizar la CPU de manera completamente distinta.

Ejemplo: un LED que cambia cada segundo puede implementarse con:

- espera activa;
- temporizador e interrupción;
- máquina de estados;
- tarea FreeRTOS.

El LED puede verse igual, pero cambian el consumo de CPU, la escalabilidad, la precisión temporal y la forma de razonar sobre el sistema.

## Pregunta guía

Antes de mirar el código, responder:

> ¿Qué está haciendo el procesador mientras espera que ocurra el siguiente evento?
