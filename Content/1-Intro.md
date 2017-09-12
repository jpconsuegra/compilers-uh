# Anatomía de un Compilador

Comenzaremos este viaje diseccionando el sistema computacional canónico de la teoría de lenguajes formales: un compilador. A grandes razgos, un compilador no es más que un programa, cuya entrada y salida resultan ser también programas. La entrada es un programa en un lenguaje que llamaremos "de alto nivel", y la salida en un lenguaje de "bajo nivel", que es equivalente al primero. Exactamente qué es alto y bajo nivel dependerá de muchos factores, y no existe una definición formal. De forma general, un lenguaje de alto nivel es aquel que nos es cómodo a los programadores para expresar las operaciones que nos interesa ejecutar. Así mismo, un lenguaje de bajo nivel es aquel que un dispositivo de cómputo puede ejecutar de forma eficiente. Tal vez los ejemplos más típicos sean un lenguaje orientado a objetos y un lenguaje ensamblador respectivamente, pero existen muchas otras combinaciones de lenguaje de entrada y salida de interés.

Ahora bien, antes de zambullirnos de lleno en la anatomía de un compilador, es conveniente mencionar algunas sistemas de procesamiento de lenguajes relacionados. Podemos intentar categorizarlos según el "tipo" del lenguaje de entrada y salida. En primer lugar, el ejemplo clásico es cuando queremos convertir un lenguaje de alto nivel a otro de bajo nivel, y justamente llamamos a este sistema un **compilador**. El caso contrario, cuando queremos convertir de un lenguaje en bajo nivel a otro en alto nivel, podemos llamarle por analogía un **decompilador**. Este tipo de herramientas son útiles para analizar y realizar ingeniería inversa en programas para los que, tal vez, ya no tenemos el código fuente, y necesitamos entender o modificar. Los otros dos casos, de alto nivel a alto nivel y de bajo nivel a nivel son básicamente **traductores**; y en ocasiones se les llama también **transpiladores**. Por ejemplo, TypeScript es un lenguaje de alto nivel que se "transpila" a JavaScript, otro lenguaje también de alto nivel. Entre lenguajes de bajo nivel podemos tener también traductores. Un ejemplo son los llamados **compiladores JIT** (*just-in-time*), que se usan para traducir un programa compilado a un lenguaje de bajo nivel genérico (por ejemplo **IL**) a un lenguaje de máquina específico para la arquitectura donde se ejecuta.

Volvamos entonces al caso clásico, el **compilador**. o este curso vamos a usar como una guía didáctica el diseño de un compilador para el lenguaje COOL, que compilará a un lenguaje de máquina denominado MIPS. Los detalles de ambos lenguajes serán introducidos a medida que sea conveniente, pero por el momento cabe decir que COOL es un lenguaje orientado a objetos, con recolección automática de basura, herencia simple, polimorfismo, y un sistema de tipos unificado. MIPS es un lenguaje ensamblador de pila para una arquitectura de 32 bits con registros y operaciones aritméticas, lógicas y orientadas a cadenas.

Intentemos entonces definir esta maquinaria paso a paso. De forma abstracta nuestro compilador es una "caja negra" con convierte programas escritos en COOL a programas escritos en MIPS:

             +------------+
    COOL ==> | Compilador | ==> MIPS
             +------------+

Para comenzar a destapar esta caja negra, notemos que al menos tenemos dos componentes independientes: uno que opera en lenguaje COOL y otro que opera en lenguaje MIPS. Necesitamos ser capaces de "leer" un programa en COOL y "escribirlo" en MIPS. Al primer módulo, que "lee", le llamaremos *parser*, por motivos históricos que veremos más adelante. Al segundo componente le llamaremos simplemente el *generador*.

             +--------+     +-----------+
    COOL ==> | PARSER | ==> | GENERADOR | ==> MIPS
             +--------+     +-----------+

De aquí surge immediatamente una pregunta: ¿qué protocolo de comunicación tienen estos módulos? Es necesario diseñar una especie de lenguaje intermedio, un mecanismo de representación que no sea ni COOL ni MIPS, sino algo que esté "a medio camino" entre ambos. Es decir, hace falta traducir el programa en COOL a alguna forma de representación abstracta, independiente de la sintaxis, que luego pueda ser interpretada por el generador y escrita en MIPS. Llamésmole de momento *representación intermedia (IR)*.

             +--------+           +-----------+
    COOL ==> | PARSER | = (IR) => | GENERADOR | ==> MIPS
             +--------+           +-----------+

Pasemos entonces a analizar qué forma debe tener esta representación intermedia. En principio, debe ser totalmente independiente de COOL o de MIPS, en términos de sintaxis. A fin de cuentas, podemos estar generando para cualquier otra plataforma, no solo MIPS. Por otro lado, tiene que ser capaz de capturar todo lo qué es posible expresar en COOL. A este tipo de representación, independiente de la sintaxis, pero que captura todo el significado, le vamos a llamar indistintamente *representación semántica* en ocasiones, justamente por este motivo. ¿Qué va en una representación semántica? Pues todos los conceptos que son expresables en un programa, dígase clases, métodos, variables, expresiones, ciclos. ¿Qué no va? Pues todo lo que sea "superfluo" al significado. Por ejemplo, el hecho de que un método tiene un nombre, pertenece a una clase, y tiene ciertos argumentos de ciertos tipos, es importante semánticamente. Dos métodos se diferencian por alguno de estos elementos. Por otro lado, el hecho de que un método se escribe primero por su nombre, luego por los argumentos entre paréntesis seguidos por los nombres de sus tipos, es poco importante *en este momento*. Daría lo mismo que los tipos fueran delante o detrás de los nombres de los argumentos, ya en esta fase del procesamiento lo que me interesa es de qué tipo es un argumento, y no si ese tipo se declara antes o después textualmente.

Definir exactamente qué es semánticamente importante en un lenguaje particular no es una tarea fácil, y veremos una vez llegados a ese punto algunas ideas para atacar este problema (qué es en última instancia un problema de diseño, y por lo tanto es más un arte que una ciencia, al menos en el sentido artístico de Donald Knuth). Lo que sí es interesante de momento, es analizar qué tipo de procesamiento es importante, o al menos conveniente, realizar sobre esta representación intermedia.



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
