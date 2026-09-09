# 05 - Assembly con loop unrolling

## Lenguaje

Assembly RISC-V.

## Metodo

La suma procesa dos elementos por iteracion:

```asm
lw t2, 0(t0)
lw t3, 4(t0)
```

El puntero avanza 8 bytes y el contador disminuye en 2.

## ¿Por que puede ayudar?

Reduce la cantidad de iteraciones y algunos saltos.

## ¿Por que puede NO ayudar?

- mas instrucciones en el cuerpo;
- mayor tamano de codigo;
- caso especial para longitud impar;
- efectos de pipeline/memoria;
- el compilador C tambien puede optimizar.

## Regla

No afirmar "es mas rapido" hasta medir.

## Estado

**Fuente lista; pendiente de benchmark.**
