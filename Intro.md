# Introducción

El objetivo de esta segunda parte del curso es introducir a los estudiantes en el estudio de la construcción de compiladores en sus 4 fases fundamentales: análisis sintáctico y semántico, optimización de código, generación de código; además de algunas nociones de diseño de lenguajes de programación.

Esta primera conferencia introduce el contenido del curso y explica el sistema de evaluación. El objetivo fundamental es motivar a los estudiantes en el estudio de la construcción de compiladores y crear expectativas sobre las habilidades y conocimientos que adquirirán durante el semestre. Para ello, dividimos la conferencia en 3 secciones fundamentales, que buscan responder tres interrogantes claves sobre el diseño del curso:

* ¿Qué preguntas fundamentales serán capaces de responder los estudiantes al finalizar el estudio de la asignatura?
* ¿Qué habilidades deberán desarrollar para ser capaces de responder esas preguntas?
* ¿Qué mecanismos emplearán los estudiantes y profesores para evaluar y retroalimentar el proceso de aprendizaje?

La respuesta de estas tres preguntas, de forma colegiada con los estudiantes, debe permitir definir los objetivos generales y contenidos particulares a presentar, así como las formas de evaluar la adquisición de dicho conocimiento. Es fundamental en esta primera conferencia incentivar el diálogo y la colaboración entre estudiantes y profesores, más allá de simplemente  exponer contenidos. Con esto se aspira a lograr una mayor motivación intrínseca en los estudiantes, y hacerlos partícipe del diseño de su propio currículum.

## Preguntas fundamentales

La conferencia comienza preguntando a los estudiantes:

> ¿Por qué están aquí?

El objetivo de esta pregunta es animarlos a hablar de sus aspiraciones con respecto a la asignatura. La pregunta tiene varias connotaciones a varios niveles:

* ¿Por qué están aquí en la conferencia hoy?
* ¿Por qué están aquí en este curso?
* ¿Por qué están aquí en este momento de la carrera? ¿De sus vidas?

Estas preguntas se pueden o no hacer de forma explícita. El objetivo es llevarlos a considerar cuáles son sus motivaciones más allá de la asistencia y las notas; qué aspiran a lograr. Aquí los estudiantes deberían llegar a considerar su futuro como profesionales, y ver dónde encajan los conocimientos y habilidades que (suponen que) obtendrán en la asignatura, dentro de la idea general de sus vidas futuras.

Una vez conocidas las aspiraciones, específicas sobre la asignatura y generales sobre la carrera y la vida profesional, se plantea una pregunta relacionada con el objeto de estudio de la asignatura. La idea es demostrar a los estudiantes que la asignatura no cayó del cielo, sino que existe donde está porque responde a un problema fundamental en la computación.

> ¿Por qué se estudia compilación?

Aquí intentamos responder la pregunta de qué problema fundamental de la computación se resuelve con lo que llamamos compiladores. El objetivo es demostrar que los compiladores surgen como una necesidad de enlazar el pensamiento abstracto en alto nivel de los especialistas de un dominio con el pensamiento mecánico de bajo nivel necesario para operar los equipos de cómputo.

Aquí puede ser útil poner un ejemplo real. Pedir a los estudiantes que se recuerden de Programación, y el segundo proyecto sobre jerarquías de clase (o cualquier ejemplo similar de alto nivel). Recuerden lo que escribieron allí, cómo modelaron la solución al problema, en qué nivel de abstracción se movían, qué conceptos utilizaban como bloques constructores de su universo. Luego recordarles que realmente esto que ellos escribieron ejecuta encima de un microprocesador como el que vieron en Arquitectura de Computadoras, con un lenguaje ensamblado que solo contiene saltos, registros y pilas. Pedirles que intenten hacer la conexión entre ambos mundos. La pregunta que salta de inmediato es:

> ¿Quién conecta estos niveles?

Básicamente hay una gran distancia entre el nivel de razonamiento que ocurre en el cerebro y el nivel de razonamiento que ocurre en una computadora. Los problemas de cualquier dominio se resuelven pensando a un nivel de abstracción con un lenguaje que describe las reglas de ese dominio. Hubo una época en que estos niveles de abstracción tenía que conectarlos el programador. De hecho, en esta época, la diferencia entre analista y programador era justamente que el analista diseñaba la solución en su lenguaje, y el programador la traducía a un programa ejecutable en el lenguaje de máquina.

Por ejemplo, en 1952 Grace Hooper trabajaba en la simulación de trayectorias balísticas. Para dirigir un proyectil a su objetivo, los modelos físicos se describen en un lenguaje de ecuaciones diferenciales y mecánica newtoniana. Sin embargo, para poder implementar estos modelos en un dispositivo de cómputo hay que hablar en un lenguaje de registros, pilas e interrupciones. Esta diferencia es lo que hace que programar sea tan difícil, y hacía extremadamente lento el desarrollo de nuevos modelos porque a cada paso podían haber errores tanto en la modelación como en la codificación. ¿Cuando algo fallaba, de quién era la culpa? Del analista o del programador? ¿O peor, del sistema de cómputo?

Entonces a Grace Hooper se le ocurrió la genial idea de que se podía diseñar un programa de computadora capaz de traducir del lenguaje de alto nivel al de bajo nivel.

Esta idea genial tomaría varios en perfeccionarse al punto de ser una realidad. El primer compilador de Grace Hooper para el lenguaje A-0 realmente era prácticamente un linker con algunas funciones básicas. Los primeros lenguajes de alto nivel en tener compiladores "serios" son FORTRAN (1957, John Backus), ALGOL (1958, Friedrich Bauer) y COBOL (1960, Grace Hooper).
Una ventaja adicional además de reducir el tiempo de desarrollo, era la posibilidad de compilar el mismo programa para múltiples plataformas. En 1960 por primera vez se compiló el mismo programa de COBOL para dos máquinas distintas: UNIVAC II y RCA 501.

En este punto los lenguajes se volvieron suficientemente complicados, que ya los compiladores no se podían escribir "a mano". Entonces hizo falta volcarse a la teoría, y desarrollar una ciencia sobre qué tipos de lenguajes de programación se podían compilar, y con qué compiladores. Esto dio nacimiento, en 1960, a la ciencia que hoy conocemos como Compilación.

La historia de lo que sucedió después, y los descubrimientos que se hicieron, es justamente lo que vamos a poder responder a lo largo de este curso.

## Habilidades y conocimientos

Una vez presentadas las preguntas generales del curso, pasamos a explicar el contenido del curso en más detalle. Para ello, comenzamos con el problema en cuestión:

> Queremos construir un compilador

Presentamos entonces la estructura básica de un compilador, es decir, "abrimos la caja negra". Por motivos que se irán haciendo evidentes a medida que avance el curso, los estudiantes entenderán que esta estructura es la manera más "natural" de diseñar un compilador.

Aquí podemos desvelar la maquinaria paso a paso, intentando descubrir intuitivamente por qué estas fases son justamente así. Las 4 fases en que se divide un compilador son:

* Análisis sintáctico
* Análisis semántico
* Optimización
* Generación de código

Recordar que el objetivo de estas cuatro fases es llegar desde un programa en un lenguaje en alto nivel (código C# por ejemplo) a un lenguaje de máquina.

```
       /-------\     /------\     /------\     /------\
C# ==> | Sint. | ==> | Sem. | ==> | Opt. | ==> | Gen. | ==> ASM
    |  \-------/  |  \------/     \------/     \------/  |
    |             |                                      |
    *- Gramática -*------ Lenguaje Intermedio (AST) -----*
```

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

## Evaluación y retroalimentación

Una vez que los estudiantes saben que habilidades obtendrán, entonces se plantea el problema de la evaluación. Aquí queremos presentar la evaluación como una necesidad y una ventaja para ellos, no como una obligación o una arbitrariedad del profesor. Comenzaremos preguntando a los estudiantes lo siguiente:

> ¿Para qué sirve la evaluación?

El objetivo de esta pregunta es motivarlos a reconocer el sistema de evaluación como un mecanismo de retroalimentación que les permite entender su propio avance y optimizar su estudio. Claro que la evaluación tiene un valor externo, que le permite a la sociedad saber quienes están preparados o no. Pero las notas particulares obtenidas en una asignatura no significan nada fuera del sistema educacional. A nadie se le ofrece un trabajo por las notas que obtuvo. Lo que cuenta es graduarse o no. Entonces, ¿por qué se toma tanto trabajo en cuantificar la evaluación? La respuesta es que el número obtenido en una evaluación es una métrica de retroalimentación para que el estudiante sepa en qué grado fue capaz de cumplir las expectativas del profesor.

El sistema de evaluación se compone de:

* Un exámen final
* Proyectos opcionales

Al final cada estudiante necesita demostrar que ha superado los estándares de cada parte del contenido. Por este motivo, no sirve suspender ninguna de las partes. Los proyectos opcionales tienen 2 objetivos:

* Introducir conceptos y habilidades más avanzados
* Demostrar el dominio de un tema o habilidad particular

De este modo los estudiantes que hagan los proyectos adicionales, es muy posible que convaliden partes o la totalidad del examen final. Pero lo más importante es que solo haciendo los proyectos adicionales van a sacarle el provecho máximo al curso y aprender las habilidades más avanzadas. De qué modo cada proyecto contribuye o no a una nota dependerá de la revisión y se analizará en cada caso particular. Pero pueden estar seguros que, en última instancia, hacer los proyectos adicionales al menos servirá para prepararse para el examen mucho mejor que solamente haciendo los ejercicios de clase, y más aún, para el futuro.

Los proyectos opcionales serán a menudo presentados por los profesores, pero se le dará especial importancia y valor a los proyectos que se les ocurra a los estudiantes de forma espontánea.

## Conclusiones

Este curso es un viaje, un viaje por una de las ramas más espectaculares de la historia de la computación, una rama que definió a la computación como ciencia, y que creó algunos de sus héroes más famosos. Es un viaje lleno de dificultades, pero detrás de cada obstáculo hay algo increíble que descubrir. Los que hemos pasado por este viaje les podemos prometer que vale la pena. Pero la mejor forma de experimentarlo no es como espectador, como un simple pasajero. La mejor forma de experimentarlo es coger el timón y decidir ustedes cuáles son los lugares que quieren explorar. Nosotros haremos el mejor esfuerzo por llevarlos allí, pero no les podemos mantener los ojos abiertos. Mirar, oler y tocar todo lo que puedan es responsabilidad de ustedes.
