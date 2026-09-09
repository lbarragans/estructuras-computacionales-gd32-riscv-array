# 06 - Signed vs unsigned

## Lenguajes

C + Assembly RISC-V.

## Experimento

```text
{-1, 1, 2}
```

### Comparacion signed

`bge` interpreta `-1` como negativo.

Resultado esperado:

```text
2
```

### Comparacion unsigned

`bgeu` interpreta el patron de `-1` como:

```text
0xFFFFFFFF = 4294967295
```

por lo que puede convertirse en el "maximo" unsigned.

## Que ensena

Los bits no cambian. Cambia la **interpretacion**.

## Estado

**Fuente lista.**
