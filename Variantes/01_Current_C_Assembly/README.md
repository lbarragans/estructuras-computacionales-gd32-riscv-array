# 01 - Implementacion hibrida C + Assembly actual

## Lenguajes

C + Assembly RISC-V.

## Idea

C prepara los datos y verifica resultados. Assembly realiza suma y maximo.

## Por que funciona

La ABI RISC-V permite que ambas partes acuerden donde estan los argumentos y
donde volvera el resultado.

```text
a0 = puntero
a1 = longitud
```

`lw` lee un entero de 32 bits y el puntero avanza 4 bytes.

## Que ensena

- frontera C/Assembly;
- ABI;
- memoria;
- punteros;
- registros temporales;
- retorno en `a0`.

## Estado

**Base actual.**
