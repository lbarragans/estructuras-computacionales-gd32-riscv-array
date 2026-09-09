# 04 - Operaciones de arreglo en Assembly RISC-V

## Lenguaje

Assembly RISC-V para la capa algoritmica.

## Operaciones

- suma;
- minimo;
- maximo;
- cantidad de valores positivos.

## Por que funciona

Todas las operaciones comparten el mismo patron:

```text
leer elemento -> procesar -> avanzar puntero -> decrementar contador -> repetir
```

## Importante

"Assembly puro" aqui se refiere al **algoritmo de procesamiento**. El arranque
del microcontrolador, linker y soporte de placa siguen dependiendo de la
infraestructura del SDK.

## Estado

**Fuente lista.**
