# 7. Plan de validacion de variantes

## Casos de prueba obligatorios

Cada algoritmo debe probarse al menos con:

```text
A = {2, -1, 5, 3, -2, 1}
suma = 8
maximo = 5
minimo = -2
positivos = 4
```

Ademas:

### Un solo elemento

```text
{7}
```

### Todos negativos

```text
{-8, -3, -10, -1}
```

### Valores repetidos

```text
{4, 4, 4, 4}
```

### Longitud cero

Cuando la interfaz lo permita, debe existir una politica documentada para
`length == 0`.

### Signed vs unsigned

```text
{-1, 1, 2}
```

Debe mostrar por que un maximo signed y uno unsigned pueden ser diferentes.

## Validacion Assembly

Durante depuracion revisar:

- `a0`;
- `a1`;
- `t0-t6`;
- `s0-s4` cuando aplique;
- `sp`;
- memoria apuntada;
- retorno.

## Rendimiento

La variante unrolled no se declarara "mas rapida" sin medir.

Medidas posibles:

- ciclos si hay contador disponible;
- tiempo por GPIO;
- numero de instrucciones en `.lst`;
- inspeccion del desensamblado.

## FreeRTOS

Solo se marcara validada despues de integrar:

- kernel;
- port RISC-V;
- `FreeRTOSConfig.h`;
- heap;
- tick;
- colas;
- scheduler.

## Estados documentales

- **Base actual**
- **Fuente lista**
- **Integracion pendiente**
- **Analisis**
- **Validada por compilacion**
- **Validada en placa**
