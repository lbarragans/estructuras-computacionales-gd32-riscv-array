# Conceptos de RISC-V, registros, memoria y ensamblador

## 1. Modelo del ejercicio

El programa escrito en C entrega un puntero y una longitud a una función
ensamblador. La CPU lee los datos de memoria, opera con ellos en registros y
devuelve el resultado a C. Finalmente, el LED representa el resultado.

    C → ABI → registros → memoria → ensamblador → retorno → LED

Este flujo conecta el algoritmo de alto nivel con la ejecución física.

## 2. RISC-V y RV32

RISC-V es una arquitectura de conjunto de instrucciones o ISA. Define qué
instrucciones entiende el procesador, cuáles registros existen, cómo se accede
a memoria y cómo se representan las operaciones.

RV32 indica que los registros enteros principales tienen 32 bits. El proyecto
utiliza rv32imafdc e ilp32d. Las extensiones habilitan, entre otras funciones,
multiplicación, división, operaciones atómicas, punto flotante e instrucciones
comprimidas.

## 3. Registro

Un registro es una ubicación de almacenamiento dentro de la CPU. Es más rápido
que RAM o Flash y puede contener datos, direcciones, contadores, argumentos y
resultados.

RISC-V dispone de 32 registros enteros físicos, x0 a x31. La ABI les asigna
nombres según su función.

## 4. ABI

ABI significa Application Binary Interface. Es el conjunto de reglas que
permite comunicar funciones compiladas desde C con funciones ensamblador.

La ABI define:

- dónde se colocan los argumentos;
- dónde se entrega el resultado;
- cuáles registros puede modificar una función;
- cuáles debe preservar;
- cómo se administra la pila;
- cómo retorna una función.

## 5. Registros enteros

| Físico | ABI | Uso habitual |
|---|---|---|
| x0 | zero | Siempre contiene cero |
| x1 | ra | Dirección de retorno |
| x2 | sp | Puntero de pila |
| x3 | gp | Puntero global |
| x4 | tp | Puntero del hilo |
| x5 | t0 | Temporal |
| x6 | t1 | Temporal |
| x7 | t2 | Temporal |
| x8 | s0/fp | Registro preservado o puntero de marco |
| x9 | s1 | Registro preservado |
| x10 | a0 | Argumento 0 y valor retornado |
| x11 | a1 | Argumento 1 |
| x12 | a2 | Argumento 2 |
| x13 | a3 | Argumento 3 |
| x14 | a4 | Argumento 4 |
| x15 | a5 | Argumento 5 |
| x16 | a6 | Argumento 6 |
| x17 | a7 | Argumento 7 |
| x18-x27 | s2-s11 | Registros preservados |
| x28-x31 | t3-t6 | Registros temporales |

## 6. Registros del ejercicio

La función se declara en C así:

    int32_t riscv_array_sum(const int32_t *values, uint32_t length);

La correspondencia es:

    values  → a0
    length  → a1
    retorno → a0

Antes de la llamada:

    a0 = dirección de test_values[0]
    a1 = 6

Al terminar la suma:

    a0 = 8

Al terminar la búsqueda del máximo:

    a0 = 5

El mismo registro a0 puede contener primero una dirección y después un número.
El registro solo guarda bits; el programa determina su significado en cada
momento.

## 7. Temporales y preservados

a0-a7 y t0-t6 son caller-saved. La función puede modificarlos. Si el llamador
necesita conservarlos, debe guardarlos antes de la llamada.

s0-s11 son callee-saved. Una función que los modifique debe guardar sus valores
originales y restaurarlos antes de retornar.

Estas funciones solo usan argumentos y temporales, por lo que no necesitan
guardar registros preservados.

## 8. ra, sp y funciones hoja

ra contiene la dirección a la que debe regresar una función. ret transfiere el
control a esa dirección.

sp apunta a la pila. La pila permite guardar registros, variables locales,
argumentos adicionales y direcciones de retorno.

riscv_array_sum y riscv_array_max son funciones hoja: no llaman a otras
funciones. No modifican registros preservados y no necesitan reservar memoria
en la pila. Por eso sp no cambia.

## 9. Arreglo en memoria

Cada int32_t ocupa cuatro bytes:

| Desplazamiento | Valor | Representación hexadecimal |
|---:|---:|---|
| 0 | 2 | 0x00000002 |
| 4 | -1 | 0xFFFFFFFF |
| 8 | 5 | 0x00000005 |
| 12 | 3 | 0x00000003 |
| 16 | -2 | 0xFFFFFFFE |
| 20 | 1 | 0x00000001 |

El arreglo ocupa 6 por 4, es decir, 24 bytes. El puntero avanza cuatro bytes:

    addi t0, t0, 4

lw carga una palabra de 32 bits desde la dirección indicada.

## 10. Complemento a dos

Los valores negativos se representan en complemento a dos:

    -1 = 0xFFFFFFFF
    -2 = 0xFFFFFFFE

La instrucción add suma correctamente estos patrones. Para obtener el máximo se
necesita una comparación con signo. bge interpreta los operandos como enteros
con signo; una comparación sin signo interpretaría -1 como un valor muy grande.

## 11. Rutina de suma

Inicialización:

    mv t0, a0
    mv t1, a1
    li a0, 0

t0 recibe el puntero, t1 la cantidad y a0 se convierte en acumulador.

| Iteración | Dato en t2 | a0 acumulado |
|---:|---:|---:|
| 1 | 2 | 2 |
| 2 | -1 | 1 |
| 3 | 5 | 6 |
| 4 | 3 | 9 |
| 5 | -2 | 7 |
| 6 | 1 | 8 |

Ciclo:

    lw      t2, 0(t0)
    add     a0, a0, t2
    addi    t0, t0, 4
    addi    t1, t1, -1
    bnez    t1, .Lsum_loop

## 12. Rutina de máximo

El primer elemento se adopta como máximo inicial:

    lw t0, 0(a0)

| Elemento leído | Máximo en t0 |
|---:|---:|
| 2 | 2 |
| -1 | 2 |
| 5 | 5 |
| 3 | 5 |
| -2 | 5 |
| 1 | 5 |

Al terminar:

    mv a0, t0
    ret

## 13. Instrucciones

| Instrucción | Función |
|---|---|
| mv rd, rs | Copia el contenido de un registro |
| li rd, valor | Carga una constante |
| lw rd, offset(rs) | Lee una palabra de 32 bits |
| add rd, rs1, rs2 | Suma dos registros |
| addi rd, rs1, valor | Suma un inmediato |
| beqz rs, etiqueta | Salta si el registro es cero |
| bnez rs, etiqueta | Salta si no es cero |
| bge rs1, rs2, etiqueta | Compara con signo y salta |
| j etiqueta | Salto incondicional |
| ret | Retorna usando ra |

mv, li, beqz, bnez, j y ret son pseudoinstrucciones. El ensamblador las
convierte en instrucciones básicas equivalentes.

## 14. Directivas

| Directiva | Propósito |
|---|---|
| .section .text | Ubica el código en la sección ejecutable |
| .align 2 | Alinea instrucciones |
| .global | Hace visible una función al enlazador |
| .type | Identifica el símbolo como función |
| .size | Registra el tamaño de la función |

La extensión .S mayúscula permite ejecutar el preprocesador antes del
ensamblador.

## 15. Validación mediante C

C y ensamblador calculan por rutas independientes:

    suma C 8       = suma ASM 8
    máximo C 5     = máximo ASM 5

Entonces:

    g_results_match = 1

El LED muestra cinco pulsos. Si alguna comparación falla,
g_results_match vale cero y el LED parpadea rápidamente.

## 16. Depuración

En la llamada a riscv_array_sum observe a0 y a1. Use Step Into y siga t0, t1,
t2 y a0. En el segundo breakpoint confirme:

    g_sum_c = 8
    g_sum_asm = 8
    g_max_c = 5
    g_max_asm = 5

Después de Step Over:

    g_results_match = 1

## 17. Preguntas

1. ¿Por qué a0 puede representar primero un puntero y luego un resultado?
2. ¿Por qué el puntero aumenta cuatro bytes?
3. ¿Qué ocurriría si se usara lbu en lugar de lw?
4. ¿Por qué la comparación del máximo debe considerar el signo?
5. ¿Qué función cumple ra?
6. ¿Por qué las funciones no modifican sp?
7. ¿Qué debería hacerse si se utilizara s0?
8. ¿Qué retorna la función cuando length es cero?
9. ¿Qué riesgo existe si length supera el tamaño real?
10. ¿Qué diferencias muestra el archivo LST entre C y ensamblador?

## 18. Ampliaciones

- Implementar mínimo.
- Contar positivos y negativos.
- Buscar un valor.
- Invertir el arreglo.
- Calcular el promedio.
- Comparar cantidad de instrucciones y tamaño de código.

