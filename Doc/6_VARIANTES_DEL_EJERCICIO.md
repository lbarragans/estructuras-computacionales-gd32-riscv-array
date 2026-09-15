# Apartados definitivos del ejercicio 02

Las antiguas variantes comparativas se retiran.

Se conservan dos caminos alternativos de implementacion.

## Ensamblador RISC-V puro

Archivo:

```text
Ensamblador_RISCV_Puro/main.S
```

El estudiante observa directamente:

- `.text`, `.rodata` y `.bss`;
- direccion del arreglo;
- `lw`;
- incremento del puntero en 4 bytes;
- contador de elementos;
- suma en registros;
- comparacion signed;
- maximo;
- variables globales para depuracion;
- acceso MMIO a GPIOC;
- control del LED;
- subrutinas y `call/ret`.

No existe codigo C de aplicacion dentro de este apartado.

## FreeRTOS puro

Archivo:

```text
FreeRTOS_Puro/main.c
```

El estudiante observa:

- tareas;
- prioridades;
- queues;
- productor/consumidor;
- bloqueo de tareas;
- transferencia de estructuras;
- temporizacion mediante `vTaskDelay()`.

Esta implementacion no llama las rutinas RISC-V de la referencia.

## Referencia original

Se conserva:

```text
Src/main.c
Src/array_riscv.S
Inc/array_riscv.h
```

porque permite estudiar especificamente la ABI entre C y RISC-V.
