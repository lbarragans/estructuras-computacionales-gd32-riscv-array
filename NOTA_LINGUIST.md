# Por qué `main.c` no se contará en este repositorio

El ejercicio contiene un archivo `Src/main.c` que sirve como **arnés de prueba** para invocar y verificar funciones escritas en RISC-V Assembly.

Ese archivo es útil y debe conservarse.

Sin embargo, el propósito académico del repositorio es estudiar Assembly. Por eso `.gitattributes` contiene:

```gitattributes
Src/main.c linguist-detectable=false
```

Esto no cambia la compilación, no borra el archivo y no modifica su comportamiento.

Únicamente evita que GitHub Linguist mezcle C con Assembly al calcular la barra de lenguajes.

El código `.S` sigue siendo el código principal del ejercicio.
