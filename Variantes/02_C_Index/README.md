# 02 - C puro usando indices

## Lenguaje

C.

## Metodo

El arreglo se recorre mediante:

```c
values[index]
```

## Por que funciona

El compilador transforma el indice en una direccion equivalente a:

```text
direccion_base + index * sizeof(int32_t)
```

## Ventaja

Es la forma mas legible para comenzar y sirve como referencia funcional.

## Limitacion

Oculta detalles de registros e instrucciones que Assembly hace explicitos.

## Estado

**Fuente lista.**
