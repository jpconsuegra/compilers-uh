# Anatomía de un Compilador

Presentamos entonces la estructura básica de un compilador, es decir, "abrimos la caja negra". Por motivos que se irán haciendo evidentes a medida que avance el curso, los estudiantes entenderán que esta estructura es la manera más "natural" de diseñar un compilador.

Aquí podemos desvelar la maquinaria paso a paso, intentando descubrir intuitivamente por qué estas fases son justamente así. Las 4 fases en que se divide un compilador son:

* Análisis sintáctico
* Análisis semántico
* Optimización
* Generación de código

Recordar que el objetivo de estas cuatro fases es llegar desde un programa en un lenguaje en alto nivel (código C# por ejemplo) a un lenguaje de máquina.

           /-------\     /------\     /------\     /------\
    C# ==> | Sint. | ==> | Sem. | ==> | Opt. | ==> | Gen. | ==> ASM
        |  \-------/  |  \------/     \------/     \------/  |
        |             |                                      |
        *- Gramática -*------ Lenguaje Intermedio (AST) -----*

Las primeras dos fases en desvelar son evidentes: el análisis sintáctico y el generador de código. Para ello se introduce primero la idea de un lenguaje intermedio, que permite representar al código en una estructura (semi) independiente de ambos lenguajes. Esto además permite separar ambas fases e implementar compiladores para múltiples lenguajes origen y múltiples plataformas objetivo. Entonces el análisis sintáctico es justamente el que convierte del lenguaje origen a la representación intermedia, y la generación de código convierte de la representación intermedia al lenguaje objetivo.

Aquí se introduce la idea de que las gramáticas, con toda su teoría de reconocimiento, pueden ser útiles para la primera fase. Ya se tienen algoritmos que permiten resolver el problema de la palabra, aunque por supuesto como se verá hace falta mucho más que eso para obtener una estructura interna.

El siguiente problema es que existen estructuras linguísticas que no son fáciles de reconocer, porque son dependientes del contexto. Por ejemplo, la expresión `x = y + z` es muy sencilla de reconocer sintácticamente, pero en un lenguaje con tipado estático esta expresión puede no pertenecer al lenguaje según los tipos de cada variable. Este es un problema clásico de dependencia del contexto, donde la expresión `x = y + z` es válida si existe en el contexto donde, por ejemplo existe, `int x, int y, int z` pero no donde el contexto es `int x, int y, object z`. Hay muchos problemas que son dependientes del contexto, entre ellos:

* Declaración de variables antes de su uso
* Consistencia en los tipos declarados y las operaciones realizadas
* Consistencia entre la declaración de una función y su invocación
* Retornos en todos los caminos de ejecución

La solución de estos problemas mediante gramáticas solamente es en general no polinomial, y a veces no computable. Pero muchos de estos problemas se pueden resolver de forma más sencilla analizando la estructura computacional intermedia. ¿Por qué? Esta estructura tiene generalmente forma arbórea (ya que las gramáticas se prestan de forma natural a esta representación, pensar en la derivación de una oración a partir de un conjunto de producciones), y en una estructura arbórea es fácil analizar la consistencia de los tipos y problemas así recorriendo cada uno de los nodos. De forma recursiva, el nodo raíz (o programa) estará correcto si cada hijo está correcto. Entonces se introduce que esta estructura se denomina Árbol de Sintaxis Abstracto (AST) y que describe la sintaxis de forma abstracta, ya que no necesariamente tiene todos los detalles de la sintaxis original. Esto se verá más adelante qué significa. Entonces introducimos una fase de análisis semántico donde se verifican todas las reglas que no son fáciles (o posibles) de escribir en una gramática libre del contexto.

Finalmente, desvelamos una fase de optimización, ya que de paso como tenemos el árbol de sintaxis abstracta, es bastante natural pensar que se pueden detectar patrones optimizables, tales como:

* Código no alcanzable
* Expresiones constantes
* Asignaciones superfluas
* Ciclos desenrrollables

Al final se termina mostrando la maquinaria completa. Por cada fase se pueden enumerar algunas de las habilidades que obtendrán al terminar el curso:

* Definir gramáticas útiles para lenguajes de diversos dominios (expresiones, objetos, agentes, etc.)
* Implementar parsers para estas gramáticas, según su tipo.
* Diseñar ASTs útiles según el dominio a representar.
* Realizar análisis semánticos usuales: chequeo de tipos, sobrecargas, polimorfismo, genericidad, etc.
* Detectar patrones comunes de código optimizable.
* Generar código para diversas plataformas y lenguajes (ensambladores y otros lenguajes de alto nivel).

Al terminar es importante expresar que, como pueden ver, las habilidades y conocimientos que pueden adquirir tienen mucho poder. Pero para ello es necesario mucho esfuerzo y estudio, pues son temas de una complejidad teórica y práctica que reunen casi todas las habilidades que han obtenido en el resto de las asignaturas: hay buenas prácticas, diseño, algoritmos, estructuras de datos, demostraciones y mucha implementación.
