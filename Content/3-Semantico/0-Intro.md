\part{Análisis Semántico}

# Introducción {-}

Hemos completado hasta el momento la primera fase del proceso de compilación. En esta fase logramos, a partir de una gramática libre del contexto (con ciertas restricciones) obtener un árbol de derivación de cualquier cadena de este lenguaje. Dicho árbol de derivación nos describe la forma en que la cadena es generada por la gramática. Intuitivamente, esta información nos permite "entender" el significado de la cadena. Hemos definido clases de gramáticas para las que podemos asegurar que existe **siempre** un único árbol de derivación, lo cual nos permite "entender" sin ambigüedad la intención que transmite la cadena. Además, hemos visto como  construir algoritmos eficientes (de complejidad lineal) para obtener este árbol para toda cadena del lenguaje. Más aún, hemos visto algoritmos que nos permiten detectar una cadena que no pertenece al lenguaje lo antes posible, y determinar exactamente el motivo.

En general hemos avanzado considerablemente en el proceso de compilación. Empezamos con una cadena de texto escrita por el programador en un editor de texto, y ya contamos con una representación computacional que nos permite entender la intención del programador. En principio, podríamos pensar que estamos listos para convertir ese árbol de expresión en la lista de instrucciones en legnguaje de máquina que serán realmente ejecutados.

Sin embargo, en la mayoría de los lenguajes de programación interesantes, existen muchas construcciones inválidas que no podemos expresar con una gramática libre del contexto. Estas construcciones son intrínsicamente dependientes del contexto, y por tanto no pueden ser reconocidas de forma eficiente y no ambigüa. La mayoría de estas construcciones están asociadas a conceptos más complejos de la teoría de lenguajes de programación, tales como las funciones, las variables, los tipos, la herencia, la sobrecarga, etc.

En este capítulo veremos cómo resolver algunos de estos problemas dependenientes del contexto.
