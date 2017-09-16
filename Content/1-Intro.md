# Anatomía de un Compilador

Comenzaremos este viaje diseccionando el sistema computacional canónico de la teoría de lenguajes formales: un compilador. A grandes razgos, un compilador no es más que un programa, cuya entrada y salida resultan ser también programas. La entrada es un programa en un lenguaje que llamaremos "de alto nivel", y la salida en un lenguaje de "bajo nivel", que es equivalente al primero. Exactamente qué es alto y bajo nivel dependerá de muchos factores, y no existe una definición formal. De forma general, un lenguaje de alto nivel es aquel que nos es cómodo a los programadores para expresar las operaciones que nos interesa ejecutar. Así mismo, un lenguaje de bajo nivel es aquel que un dispositivo de cómputo puede ejecutar de forma eficiente. Tal vez los ejemplos más típicos sean un lenguaje orientado a objetos y un lenguaje ensamblador respectivamente, pero existen muchas otras combinaciones de lenguaje de entrada y salida de interés.

Ahora bien, antes de zambullirnos de lleno en la anatomía de un compilador, es conveniente mencionar algunas sistemas de procesamiento de lenguajes relacionados. Podemos intentar categorizarlos según el "tipo" del lenguaje de entrada y salida. En primer lugar, el ejemplo clásico es cuando queremos convertir un lenguaje de alto nivel a otro de bajo nivel, y justamente llamamos a este sistema un **compilador**. El caso contrario, cuando queremos convertir de un lenguaje en bajo nivel a otro en alto nivel, podemos llamarle por analogía un **decompilador**. Este tipo de herramientas son útiles para analizar y realizar ingeniería inversa en programas para los que, tal vez, ya no tenemos el código fuente, y necesitamos entender o modificar. Los otros dos casos, de alto nivel a alto nivel y de bajo nivel a nivel son básicamente **traductores**; y en ocasiones se les llama también **transpiladores**. Por ejemplo, TypeScript es un lenguaje de alto nivel que se "transpila" a JavaScript, otro lenguaje también de alto nivel. Entre lenguajes de bajo nivel podemos tener también traductores. Un ejemplo son los llamados **compiladores JIT** (*just-in-time*), que se usan para traducir un programa compilado a un lenguaje de bajo nivel genérico (por ejemplo **IL**) a un lenguaje de máquina específico para la arquitectura donde se ejecuta.

Volvamos entonces al caso clásico, el **compilador**. o este curso vamos a usar como una guía didáctica el diseño de un compilador para el lenguaje COOL, que compilará a un lenguaje de máquina denominado MIPS. Los detalles de ambos lenguajes serán introducidos a medida que sea conveniente, pero por el momento cabe decir que COOL es un lenguaje orientado a objetos, con recolección automática de basura, herencia simple, polimorfismo, y un sistema de tipos unificado. MIPS es un lenguaje ensamblador de pila para una arquitectura de 32 bits con registros y operaciones aritméticas, lógicas y orientadas a cadenas.

Intentemos entonces definir esta maquinaria paso a paso. De forma abstracta nuestro compilador es una "caja negra" con convierte programas escritos en COOL a programas escritos en MIPS:

             +------------+
    COOL ==> | Compilador | ==> MIPS
             +------------+

Para comenzar a destapar esta caja negra, notemos que al menos tenemos dos componentes independientes: uno que opera en lenguaje COOL y otro que opera en lenguaje MIPS. Necesitamos ser capaces de "leer" un programa en COOL y "escribirlo" en MIPS. Al primer módulo, que "lee", le llamaremos *parser*, o analizador sintáctico, por motivos históricos que veremos más adelante. Al segundo componente le llamaremos simplemente el *generador*.

             +--------+     +-----------+
    COOL ==> | PARSER | ==> | GENERADOR | ==> MIPS
             +--------+     +-----------+

De aquí surge immediatamente una pregunta: ¿qué protocolo de comunicación tienen estos módulos? Es necesario diseñar una especie de lenguaje intermedio, un mecanismo de representación que no sea ni COOL ni MIPS, sino algo que esté "a medio camino" entre ambos. Es decir, hace falta traducir el programa en COOL a alguna forma de representación abstracta, independiente de la sintaxis, que luego pueda ser interpretada por el generador y escrita en MIPS. Llamésmole de momento *representación intermedia (IR)*.

             +--------+           +-----------+
    COOL ==> | PARSER | = (IR) => | GENERADOR | ==> MIPS
             +--------+           +-----------+

Pasemos entonces a analizar qué forma debe tener esta representación intermedia. En principio, debe ser totalmente independiente de COOL o de MIPS, en términos de sintaxis. A fin de cuentas, podemos estar generando para cualquier otra plataforma, no solo MIPS. Por otro lado, tiene que ser capaz de capturar todo lo qué es posible expresar en COOL. A este tipo de representación, independiente de la sintaxis, pero que captura todo el significado, le vamos a llamar indistintamente *representación semántica* en ocasiones, justamente por este motivo. ¿Qué va en una representación semántica? Pues todos los conceptos que son expresables en un programa, dígase clases, métodos, variables, expresiones, ciclos. ¿Qué no va? Pues todo lo que sea "superfluo" al significado. Por ejemplo, el hecho de que un método tiene un nombre, pertenece a una clase, y tiene ciertos argumentos de ciertos tipos, es importante semánticamente. Dos métodos se diferencian por alguno de estos elementos. Por otro lado, el hecho de que un método se escribe primero por su nombre, luego por los argumentos entre paréntesis seguidos por los nombres de sus tipos, es poco importante *en este momento*. Daría lo mismo que los tipos fueran delante o detrás de los nombres de los argumentos, ya en esta fase del procesamiento lo que nos interesa es de qué tipo es un argumento, y no si ese tipo se declara antes o después textualmente.

Definir exactamente qué es semánticamente importante en un lenguaje particular no es una tarea fácil, y veremos una vez llegados a ese punto algunas ideas para atacar este problema (qué es en última instancia un problema de diseño, y por lo tanto es más un arte que una ciencia, al menos en el sentido artístico de Donald Knuth). Lo que sí es interesante de momento, es analizar qué tipo de procesamiento es importante, o al menos conveniente, realizar sobre esta representación intermedia.

Cómo justificaremos más adelante, existen estructuras linguísticas que no son fáciles de reconocer, porque son dependientes del contexto. Por ejemplo, la expresión `x = y + z` es muy sencilla de reconocer sintácticamente, pero en un lenguaje con tipado estático esta expresión puede no pertenecer al lenguaje según los tipos de cada variable. Este es un problema clásico de dependencia del contexto, donde la expresión `x = y + z` es válida si existe en el contexto donde, por ejemplo existe, `int x, int y, int z` pero no donde el contexto es `int x, int y, object z`. Hay muchos problemas que son dependientes del contexto, entre ellos:

* Declaración de variables antes de su uso
* Consistencia en los tipos declarados y las operaciones realizadas
* Consistencia entre la declaración de una función y su invocación
* Retornos en todos los caminos de ejecución

La solución de estos problemas empleando las técnicas de la teoría de lenguajes solamente es en general no polinomial, y a veces no computable. Pero muchos de estos problemas se pueden resolver de forma más sencilla analizando la estructura computacional intermedia. ¿Por qué? Veremos más adelante que esta estructura tiene generalmente forma arbórea, y en una estructura arbórea es fácil analizar la consistencia de los tipos y problemas similares recorriendo cada uno de los nodos. De forma recursiva, el nodo raíz (o programa) estará correcto si cada hijo está correcto. Para realizar este tipo de procesamiento, introduciremos una nueva fase, que llamaremos *chequeo semántico*, y que opera justamente sobre la representación semántica del programa.

             +--------+    +-----------+    +-----------+
    COOL ==> | PARSER | => | SEMANTICO | => | GENERADOR | ==> MIPS
             +--------+    +-----------+    +-----------+

Finalmente, justo antes de generar el código ejecutable final, cabe preguntarse si existe algún tipo de procesamiento adicional conveniente. Descubriremos más adelante varios tipos de optimizaciones que se pueden aplicar en este punto, entre ellas:

* Eliminar código no alcanzable
* Expandir expresiones constantes
* Elimiar asignaciones superfluas
* Desenrrollar ciclos con extremos constantes

Estas optimizaciones a menudo son convenientes de realizar sobre una estructura del programa mucho más cercana al código de máquina que al código original. Son muchos los factores que influyen en esto y que veremos más adelante, pero de forma intuitiva, es fácil entender que optimizar un programa debe ser un proceso muy cercano al código de máquina, pues la propia naturaleza de la optimización requiere explotar características propias de la maquinaria donde será ejecutado el código. Introduciremos entonces una fase de optimización, que de momento visualizaremos de forma *paralela* al proceso de generación, pues en la práctica ambas fases comparten la misma representación y ambos procesos ocurren de forma más o menos simultánea.

             +--------+    +-----------+    +-----------+
    COOL ==> | PARSER | => | SEMANTICO | => | GENERADOR | ==> MIPS
             +--------+    +-----------+    +-----------+
                                                  ||
                                           +--------------+
                                           | OPTIMIZACION |
                                           +--------------+

Antes de terminar vamos a develar una fase adicional, justo antes del proceso de *parsing*. Para entender por qué, debemos introducirnos un poco más profundamente en este proceso. El proceso de *parsing* básicamente de lo que se encarga es convertir cadenas de texto (escritas en el lenguaje origen) a una estructura (arbórea) que captura la semántica del programa. Por ejemplo, supongamos que tenemos la siguiente expresión como parte de un programa en COOL:

    if a <= 0 then
        b
    else
        c
    fi

Esta expresión, desde el punto de vista semántico, podemos pensar que se transforma a una estructura como la siguiente:

        IF-EXPR
       /   |   \
      <=   b    c
     /  \
    a    0

De forma simplificada, en esta estructura hemos representado semánticamente el significado de la expresión sintáctica anterior, extrayendo los elementos importantes (el hecho de que una expresión `if` contiene tres elementos: condición, parte del cuerpo `true` y parte del cuerpo `false`) y obviando los detalles de sintaxis que ya no son imporantes (por ejemplo las palabras `then`, `else` y `fi` que solamente sirven para separar los bloques correspondientes).

La solución de este problema (convertir una secuencia de texto en una representación semántica) nos tomará la primera mitad del curso, pues es uno de los temas centrales en toda la teoría de lenguajes y la compilación en particular. Más adelante formalizaremos con exactitud este problema y veremos muchísimas estrategias de solución. Pero antes de llegar a ese punto, es necesario resolver un sub-problema de menor complejidad, que aún así nos dará suficiente trabajo como para desarrollar gran parte de la teoría de lenguajes en su solución. El problema en cuestión es el siguiente.

La cadena de texto de entrada, realmente está formada por una secuencia de caracteres. En el caso anterior, por ejemplo, tenemos la siguiente secuencia:

    i f \s a \s < = \s 0 \s t h e n \n \t b \n e l s e \n \t c \n f i

En esta secuencia hemos representado cada caracter por separado, y hemos puesto explícitamente los espacios en blanco (`\s`), cambios de línea (`\n`) y espacios de tabulación (`\t`). Esta secuencia es lo que realmente "ve" el compilador en la entrada. Por lo tanto, desde el punto de vista puramente sintáctico, existen muchas secuencias que son exactamente el mismo programa. Por ejemplo, si existen varios espacios entre dos símbolos, o si no hay cambios de línea, o si los bloques están indentados con 4 espacios en vez con un caracter `\t`, realmente estamos en presencia del mismo programa.

Para simplificar la tarea del *parser*, es conveniente convertir primeramente esta secuencia de caracteres en una secuencia de **tokens**, que no son más que los elementos básicos que componen el lenguaje, lo que pudiéramos llamar las *palabras* o *símbolos* más básicos. Por ejemplo, en el caso anterior, quisiéramos obtener la siguiente secuencia de **tokens**:

    if | a | <= | 0 | then | b | else | c | fi

Introduciremos entonces una primera fase, que llamaremos indistintamente *tokenización*, o análisis lexicográfico, para transmitir la idea de que en esta fase solamente se procesan los elementos *léxicos*, es decir, las palabras, sin llegar todavía a tocar los elementos *sintácticos*, es decir, la estructura. Al mecanismo encargado de resolver este problema le llamaremos entonces *lexer*.

             +--------+                     +-----------+
    COOL ==> | LEXER  |                     | GENERADOR | ==> MIPS
             +--------+    +-----------+    +-----------+
                 ||     => | SEMANTICO | =>       ||
             +--------+    +-----------+   +--------------+
             | PARSER |                    | OPTIMIZACION |
             +--------+                    +--------------+

A modo de resumen, tenemos entonces cinco fases fundamentales:

Análisis Lexicográfico (*lexer*)
:   donde se realiza la conversión de una secuencia de caracteres a una secuencia de *tokens*.

Análisis Sintáctico (*parser*)
:   donde se determina la estructura sintáctica del programa a partir de los *tokens* y se obtiene una estructura intermedia.

Análisis Semántico
:   donde se verifican las condiciones semánticas del programa y se valida el uso correcto de todos los símbolos definidos.

Optimización
:   donde se eliminan o simplifican secciones del programa en función de la arquitectura de máquina hacian donde se vaya a compilar.

Generación
:   donde se convierte finalmente la estructura semántica y optimizada hacia el lenguaje objetivo en la arquitectura donde será ejecutado.

Comenzaremos entonces a estudiar la fase de análisis lexicográfico, donde introduciremos los primeros elementos de la teoría de lenguajes formales.