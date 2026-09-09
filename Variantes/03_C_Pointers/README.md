# 03 - C puro usando punteros

## Lenguaje

C.

## Metodo

En vez de `values[index]`, se usa:

```c
*ptr
++ptr
```

## Relacion con Assembly

Conceptualmente:

```c
*ptr
```

se acerca a:

```asm
lw t2, 0(t0)
```

y:

```c
++ptr
```

para `int32_t` se corresponde con avanzar 4 bytes.

## Que ensena

Es un puente excelente entre C y Assembly.

## Estado

**Fuente lista.**
