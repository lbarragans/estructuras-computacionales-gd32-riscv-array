# Procesamiento de arreglos en GD32VW553: C, Assembly RISC-V y distintas arquitecturas

**Unidad:** Procesamiento y transferencia de informacion en sistemas embebidos RISC-V
**Autora:** Laura Daniela Barragan Silva
**Plataforma:** GD32VW553HMQ6/HMQ7  
**Arquitectura:** RISC-V RV32

## 1. Proposito

La implementacion principal del repositorio se conserva intacta:

```text
Src/main.c
Src/array_riscv.S
Inc/array_riscv.h
```

El programa calcula la suma y el maximo del arreglo:

```text
{2, -1, 5, 3, -2, 1}
```

dos veces:

```text
Referencia en C
        ↓
Comparacion
        ↑
Funciones Assembly RISC-V
```

Si los resultados coinciden, el LED PC13 muestra cinco pulsos; si no coinciden,
parpadea rapidamente.

La version principal sigue siendo la que compila por defecto. Las nuevas
implementaciones viven en `Variantes/` y se integraran/validaran una por una.

## 2. Menu de implementaciones

| # | Variante | Lenguaje / tecnologia | Concepto central | Estado |
|---:|---|---|---|---|
| 01 | Hibrida actual | C + Assembly | ABI, `a0/a1`, `lw`, punteros | Base actual |
| 02 | C puro por indices | C | algoritmo de referencia | Fuente lista |
| 03 | C puro con punteros | C | aritmetica de punteros | Fuente lista |
| 04 | Operaciones en Assembly | Assembly | recorrido, suma, min, max, conteo | Fuente lista |
| 05 | Assembly con loop unrolling | Assembly | menos saltos vs claridad | Fuente lista |
| 06 | Signed vs unsigned | C + Assembly | `bge` frente a `bgeu` | Fuente lista |
| 07 | ABI avanzada + stack | C + Assembly | `sp`, registros `s`, caller/callee-saved | Fuente lista |
| 08 | Hibrida con estadisticas extendidas | C + Assembly | modularidad C/ASM | Fuente lista |
| 09 | FreeRTOS productor-procesador-verificador | C + Assembly + FreeRTOS | tareas y colas | Integracion pendiente |
| 10 | Por que NO usar interrupciones aqui | Documentacion | seleccionar la arquitectura adecuada | Analisis |

Ver [`Variantes/README.md`](Variantes/README.md).

## 3. Por que la implementacion actual funciona

La ABI RISC-V define donde viajan argumentos y valores de retorno.

Para:

```c
riscv_array_sum(values, length);
```

la llamada usa conceptualmente:

```text
a0 = direccion del primer elemento
a1 = cantidad de elementos
```

Assembly avanza el puntero cuatro bytes por elemento, porque cada `int32_t`
ocupa 4 bytes:

```asm
lw      t2, 0(t0)
addi    t0, t0, 4
```

El resultado vuelve a C en `a0`.

## 4. Que cambia entre C y Assembly

En C podemos escribir:

```c
sum += values[index];
```

En Assembly debemos hacer visibles las operaciones:

```text
direccion
    ↓
carga desde memoria
    ↓
operacion aritmetica
    ↓
avance del puntero
    ↓
control del bucle
```

Por eso este ejercicio es especialmente util para estudiar la relacion entre:

```text
algoritmo -> compilador -> instrucciones -> registros -> memoria
```

## 5. Indices frente a punteros

Estas dos expresiones C pueden representar el mismo acceso:

```c
values[index]
```

y

```c
*pointer
```

pero la segunda se aproxima visualmente a lo que vemos en Assembly:

```asm
lw t2, 0(t0)
addi t0, t0, 4
```

## 6. Signed frente a unsigned

El arreglo principal contiene numeros negativos.

Por eso el maximo de enteros con signo debe utilizar una comparacion signed:

```asm
bge
```

Una comparacion unsigned:

```asm
bgeu
```

interpreta el patron binario de `-1` como un valor positivo muy grande.

Este contraste se estudia en la variante 06.

## 7. ABI y pila

La implementacion base utiliza principalmente registros temporales `t0-t2`.

En la variante 07 construiremos una funcion mas grande que usa registros
preservados `s0-s4` y la pila. Esto permite estudiar de forma concreta:

- `sp`;
- stack frame;
- caller-saved;
- callee-saved;
- prologo y epilogo;
- retorno por estructura de salida.

## 8. Optimizacion: no siempre menos instrucciones significa mejor codigo educativo

La variante de loop unrolling procesa dos elementos por iteracion.

Puede reducir el numero de saltos, pero tambien:

- aumenta el codigo;
- complica el caso de longitud impar;
- dificulta la lectura;
- puede no mejorar el rendimiento en todos los contextos.

La conclusion debe basarse en medicion, no solo en apariencia.

## 9. FreeRTOS

FreeRTOS no es un lenguaje.

En la variante 09:

```text
Productor -> Queue -> Procesador Assembly -> Queue -> Verificador C
```

Esta arquitectura tiene sentido si los arreglos llegan de forma asincrona o si
hay otras tareas concurrentes.

Para un unico arreglo constante procesado una sola vez, FreeRTOS seria una
solucion innecesariamente compleja.

La variante se mantiene como **integracion pendiente** porque el CMake actual no
enlaza el kernel FreeRTOS ni su port RISC-V.

## 10. ¿Y las interrupciones?

Una interrupcion es apropiada cuando existe un evento asincrono:

- UART recibe un byte;
- ADC completa una conversion;
- un temporizador vence;
- cambia una entrada digital.

Pero la suma de un arreglo que ya esta en RAM es trabajo secuencial de CPU.

Forzar una interrupcion para "hacer la suma de otra manera" no aporta una
arquitectura mejor. Esta decision se documenta en la variante 10.

## 11. Lenguajes en GitHub

La politica global ya establecida se mantiene:

```text
C        -> cuenta si se usa realmente
Assembly -> cuenta si se usa realmente

PowerShell -> no cuenta
CMake      -> no cuenta
JSON       -> no cuenta
Markdown   -> documentacion
```

Los porcentajes exactos no se fuerzan.

## 12. Validacion

Agregar una fuente a `Variantes/` no significa que ya este validada en hardware.

Cada variante debe pasar posteriormente por:

1. revision;
2. integracion CMake;
3. compilacion;
4. warnings;
5. prueba con datos normales;
6. casos limite;
7. depuracion de registros/memoria;
8. prueba en placa cuando corresponda;
9. commit de validacion.

Ver [`Doc/7_PLAN_DE_VALIDACION.md`](Doc/7_PLAN_DE_VALIDACION.md).
