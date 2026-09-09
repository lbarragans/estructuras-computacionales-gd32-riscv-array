# 07 - ABI avanzada, registros preservados y stack

## Lenguajes

C + Assembly RISC-V.

## Novedad

La funcion produce cuatro resultados mediante una estructura de salida.

Usa registros `s0-s4`, por lo que debe preservarlos.

## Prologo

```asm
addi sp, sp, -32
sw   s0, 24(sp)
...
```

## Epilogo

Restaura los registros y recupera el stack pointer.

## Que ensena

- stack frame;
- alineacion de pila;
- callee-saved;
- estructura en memoria;
- multiples resultados;
- prologo/epilogo.

## Por que funciona

La ABI exige que una funcion devuelva los registros `s` con el valor que tenian
antes de la llamada. La pila guarda temporalmente esos valores.

## Estado

**Fuente lista; especialmente importante para depuracion paso a paso.**
