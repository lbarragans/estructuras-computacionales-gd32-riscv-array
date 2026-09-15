# Depuracion

El apartado exporta tres simbolos:

```text
g_sum_ensamblador
g_max_ensamblador
g_resultados_ok
```

Despues del procesamiento deben contener:

```text
g_sum_ensamblador = 8
g_max_ensamblador = 5
g_resultados_ok   = 1
```

## Puntos utiles de breakpoint

```text
.Larray_loop
.Larray_done
.Lsuccess_sequence
.Lresults_error
```

## Conceptos para observar

Durante `.Larray_loop`:

```text
s0 -> direccion del elemento actual
s1 -> elementos restantes
s2 -> suma parcial
s3 -> maximo parcial
```

La instruccion:

```asm
bge s3, t0, .Lkeep_max
```

realiza una comparacion signed.
