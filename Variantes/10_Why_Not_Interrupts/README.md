# 10 - ¿Por que no resolver la suma del arreglo mediante una interrupcion?

## Respuesta corta

Porque la suma del arreglo almacenado en RAM no es un evento asincrono.

## Que problema resuelve una interrupcion

Una interrupcion permite que la CPU reaccione cuando ocurre algo como:

```text
UART recibe dato
ADC termina conversion
timer vence
GPIO cambia
DMA termina transferencia
```

## El arreglo actual

En este ejercicio:

```text
el arreglo ya esta en RAM
↓
la CPU tiene todo lo necesario
↓
debe recorrerlo y calcular
```

No existe un evento externo que justifique interrumpir el flujo.

## ¿Se podria fabricar una interrupcion?

Si. Por ejemplo, un temporizador podria generar una IRQ y procesar un elemento
por interrupcion.

Pero eso agregaria:

- latencia;
- complejidad;
- estado compartido;
- overhead de entrada/salida de ISR;
- dependencia temporal artificial.

No mejora el algoritmo.

## Cuando SI podria aparecer una interrupcion en un proyecto de arreglos

Si el arreglo se llena mediante ADC + DMA y una IRQ indica:

```text
buffer completo
```

entonces la interrupcion no "calcula la suma": avisa que **los datos estan
listos**, y el procesamiento puede comenzar fuera de la ISR.

## Leccion

Una buena arquitectura no consiste en usar todas las tecnicas disponibles.

Consiste en seleccionar la tecnica que corresponde al problema.
