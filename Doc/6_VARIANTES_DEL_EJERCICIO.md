# 6. Variantes del procesamiento de arreglos

## Objetivo

Resolver y analizar el mismo problema de procesamiento de datos desde distintos
niveles de abstraccion.

## Comparacion

| Variante | Acceso a memoria | Control del bucle | Uso de ABI | Concurrencia |
|---|---|---|---|---|
| Hibrida actual | Assembly `lw` | Assembly | Si | No |
| C por indices | `values[i]` | C | compilador | No |
| C por punteros | `*ptr++` | C | compilador | No |
| Assembly completo | `lw` | branches | Si | No |
| Assembly unrolled | dos `lw`/iteracion | menos branches | Si | No |
| Signed/unsigned | `lw` | `bge`/`bgeu` | Si | No |
| ABI + stack | `lw` + estructura | branches | avanzada | No |
| Hibrida extendida | C + Assembly | ambos | Si | No |
| FreeRTOS | C/Assembly | scheduler | Si | Si |

## Preguntas guia

1. ¿Por que un `int32_t` hace avanzar el puntero 4 bytes?
2. ¿Que diferencia existe entre `lw` y el valor almacenado en el registro?
3. ¿Que registro contiene el primer argumento de una funcion?
4. ¿Por que el resultado vuelve normalmente en `a0`?
5. ¿Que diferencia hay entre `bge` y `bgeu`?
6. ¿Que registros debe restaurar una funcion si usa `s0-s11`?
7. ¿Que ventaja y costo tiene desenrollar un bucle?
8. ¿Cuando tiene sentido dividir el procesamiento en tareas FreeRTOS?
9. ¿Por que una interrupcion no es una alternativa natural para procesar un
   arreglo que ya esta disponible en RAM?
