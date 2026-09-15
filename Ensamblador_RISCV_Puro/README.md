# Procesamiento de arreglos en Ensamblador RISC-V puro

## Regla

La aplicacion de este apartado esta completamente en:

```text
main.S
```

No hay archivos `.c`.

## Arreglo

```text
{2, -1, 5, 3, -2, 1}
```

Resultados:

```text
suma   = 8
maximo = 5
```

## Flujo

```text
test_values
    ↓
lw
    ↓
suma + comparacion signed
    ↓
guardar resultados
    ↓
comprobar 8 y 5
    ↓
PC13
```

## Registros principales

| Registro | Uso |
|---|---|
| `s0` | puntero al arreglo |
| `s1` | elementos restantes |
| `s2` | acumulador de suma |
| `s3` | maximo |
| `s4` | contador de pulsos |
| `t0-t2` | temporales, MMIO y retardos |

## Resultado fisico

Si los resultados son correctos:

```text
5 pulsos
pausa
5 pulsos
...
```

Si son incorrectos:

```text
parpadeo rapido
```

## Estado

Fuente lista.

La sintaxis del archivo `.S` fue revisada como codigo RV32, pero el estado
**validada por compilacion** solo se usara despues de compilar el proyecto real
con el toolchain y CMake del curso.
