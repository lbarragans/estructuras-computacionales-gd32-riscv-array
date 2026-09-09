# Política de lenguajes del repositorio

Este ejercicio utiliza realmente **C y RISC-V Assembly**.

- `Src/main.c` forma parte de la solución y debe contarse como **C**.
- Los archivos `.S`/`.s` forman parte de la solución y deben contarse como **Assembly**.
- Los archivos auxiliares de construcción, configuración y automatización no deben alterar la barra de lenguajes.

Por eso GitHub debe mostrar una combinación semejante a:

```text
C          xx.x %
Assembly   yy.y %
```

Los porcentajes exactos dependen de la cantidad de código de cada lenguaje y siempre suman 100%.

## Regla que seguiremos en todos los repositorios

**Si un lenguaje participa realmente en la implementación, debe aparecer.**

Ejemplos:

- C puro → C 100%.
- Assembly puro → Assembly 100%.
- C + Assembly → aparecen ambos.
- FreeRTOS → normalmente aparece C, y se documenta FreeRTOS como tecnología.
- PowerShell/CMake/JSON/Markdown de soporte → no cuentan como lenguaje de la solución.
