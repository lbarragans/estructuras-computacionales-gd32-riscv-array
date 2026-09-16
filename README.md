# Ejercicio 02 - Procesamiento de arreglos en GD32VW553

**Unidad:** Procesamiento y transferencia de informacion en sistemas embebidos RISC-V
**Autora:** Laura Daniela Barragan Silva
**Plataforma:** GD32VW553HMQ6/HMQ7
**Arquitectura:** RISC-V RV32

## 1. Implementacion original de referencia

La implementacion funcional existente se conserva:

```text
Src/main.c
Src/array_riscv.S
Inc/array_riscv.h
```

El arreglo de prueba es:

```text
{2, -1, 5, 3, -2, 1}
```

y los resultados esperados son:

```text
suma   = 8
maximo = 5
```

La referencia calcula suma y maximo en C y en rutinas RISC-V, compara ambos
resultados y utiliza PC13 para mostrar el resultado.

## 2. Estructura definitiva de estudio

Se eliminan las antiguas carpetas `Variantes/`.

Solo se conservan dos implementaciones alternativas:

```text
Ensamblador_RISCV_Puro/
FreeRTOS_Puro/
```

La estructura queda:

```text
02_RISCV_Assembly_Array/
├── Src/
│   ├── main.c
│   └── array_riscv.S
├── Inc/
│   └── array_riscv.h
├── Ensamblador_RISCV_Puro/
│   ├── main.S
│   ├── README.md
│   └── DEPURACION.md
├── FreeRTOS_Puro/
│   ├── main.c
│   ├── README.md
│   └── INTEGRACION.md
├── Doc/
├── .gitattributes
├── REGLA_GLOBAL_LENGUAJES.md
├── NOTA_LINGUIST.md
├── CMakeLists.txt
└── README.md
```

## 3. Ensamblador RISC-V puro

La aplicacion completa de estudio esta en:

```text
Ensamblador_RISCV_Puro/main.S
```

No hay archivos `.c` dentro de ese apartado.

El archivo:

1. define el arreglo en `.rodata`;
2. recorre los seis enteros con `lw`;
3. calcula la suma;
4. calcula el maximo con comparacion signed;
5. guarda los resultados en variables visibles para depuracion;
6. comprueba `suma = 8` y `maximo = 5`;
7. si son correctos, muestra cinco pulsos en PC13;
8. si hay error, produce un parpadeo rapido.

Todo el control de RCU, GPIOC, algoritmo, comparaciones y retardos de la
aplicacion se realiza directamente en ensamblador RISC-V.

El startup, linker y sistema de programacion siguen siendo infraestructura de la
plataforma.

## 4. FreeRTOS puro

FreeRTOS no es un lenguaje; esta implementacion esta escrita en C.

"Puro" significa aqui que la organizacion concurrente del ejercicio usa
directamente primitivas nativas de FreeRTOS y no llama a las rutinas de
ensamblador de la referencia.

La arquitectura es:

```text
ProducerTask
    ↓ Queue
ProcessorTask
    ↓ Queue
IndicatorTask
    ↓
PC13
```

### ProducerTask

Publica un trabajo que contiene:

```text
puntero al arreglo
longitud
```

### ProcessorTask

Calcula en C:

```text
suma
maximo
```

### IndicatorTask

Comprueba:

```text
suma == 8
maximo == 5
```

y muestra el resultado mediante el LED.

La temporizacion utiliza `vTaskDelay()`, por lo que las tareas se bloquean sin
hacer espera activa.

## 5. Diferencia conceptual

| Implementacion | Objetivo principal |
|---|---|
| Referencia original | comparar C y rutinas RISC-V mediante ABI |
| Ensamblador RISC-V puro | hacer visible todo el algoritmo y el hardware sin C de aplicacion |
| FreeRTOS puro | estudiar tareas, queues, bloqueo y transferencia de datos |

## 6. Comparacion signed

El arreglo contiene valores negativos.

Para calcular el maximo se necesita una comparacion **con signo**.

En ensamblador RISC-V puro se utiliza:

```asm
bge
```

y no:

```asm
bgeu
```

porque `bgeu` interpretaria el patron binario de un numero negativo como un
entero positivo sin signo muy grande.

## 7. Estado

| Implementacion | Estado |
|---|---|
| `Src/main.c` + `Src/array_riscv.S` | referencia funcional |
| `Ensamblador_RISCV_Puro` | compilable y programable con `build_variant.ps1` |
| `FreeRTOS_Puro` | compilable y programable con `build_freertos.ps1` y MSDK V1.0.3g |

## 8. Lenguajes

El repositorio contiene codigo real en:

```text
C
Ensamblador RISC-V
```

FreeRTOS es una tecnologia/RTOS y no un lenguaje.

GitHub puede denominar automaticamente `Assembly` al lenguaje de los archivos
`.S`; ese nombre corresponde a GitHub Linguist.

## 9. Regla del curso

Para este y los siguientes ejercicios se conserva:

```text
codigo original de referencia
+
Ensamblador_RISCV_Puro
+
FreeRTOS_Puro
```

No se conservaran las antiguas variantes comparativas.

## Ejecutar las variantes

Referencia original por JTAG/OpenOCD:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\\tools\\build_variant.ps1 -Variant original -Flash
```

Assembly puro por JTAG/OpenOCD:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\\tools\\build_variant.ps1 -Variant assembly -Flash
```

FreeRTOS usa el port oficial del SDK WiFi V1.0.3g:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\build_freertos.ps1 -Clean -Flash
```

Resultado esperado: cinco pulsos repetidos en PC13. En caso de error se
presenta una secuencia rapida de diez cambios.

## Guía central de ejecución

Siga la [guía central GD32VW553](https://github.com/lbarragans/gd32vw553-vscode-cmake-guide)
para preparar VS Code, compilar, programar y depurar cada variante.
