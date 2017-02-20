# Análisis Sintáctico

El objetivo de esta sección es presentar el proceso de análisis sintáctico, desde la definición de la gramática, hasta la construcción del lexer y el parser, terminando con el árbol de derivación. Como siempre comenzaremos analizando cuáles son las preguntas fundamentales que esta parte del curso ayuda a responder, cuáles son las habilidades y conocimientos que los estudiantes ganarán, y cuáles son los mecanismos de evaluación  y retroalimentación que permitirán evaluar el progreso de los estudiantes.

## Preguntas

Como siempre, comenzamos esta sección con las preguntas fundamentales que nos ayudarán a comprender y organizar el contenido.

> **¿Qué cuestiones fundamentales ayudará a responder este contenido?**

El estudio del análisis sintáctico debe responder a la pregunta sobre cómo obtener una representación computacional de la estructura de un programa escrito en un lenguaje de programación. Es necesario guiar a los estudiantes desde la concepción de un lenguaje de programación, el diseño de la gramática correspondiente, y el problema de obtener un árbol de derivación de esta gramática.

Para comenzar, pueder ser conveniente mostrar recordar los estudiantes el proceso de compilación tal como fue descrito a alto nivel en el tema anterior. Por ahora nos centraremos en la fase de Análisis Sintáctico. Como habíamos visto, esta fase es la encargada de obtener una representación computacional a partir de una oración en el lenguaje origen. La primera pregunta interesante a responder es:

> ¿Desde el punto de vista computacional, qué cosa es el programa de entrada?

Aquí los estudiantes deberían rápidamente llegar a que el programa de entrada es un **string**, más específicamente, una secuencia de caracteres en algún vocabulario, digamos ASCII o Unicode. Es conveniente ilustrar esto presentando un programa tal y como se ve en un IDE, y luego presentar como se ve para el compilador, es decir, con los cambios de línea y los espacios en blanco como caracteres escapados.
