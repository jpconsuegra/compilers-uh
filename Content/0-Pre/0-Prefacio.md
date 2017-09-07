# Prefacio {-}

Este documento tiene como objetivo presentar el diseño de un curso de Compilación para estudiantes de Ciencia de la Computación. Este documento no es en absoluto un libro de texto de la asignatura Compilación (ni pretende serlo). Se asume que los profesores y estudiantes cuentan con documentación adicional para profundizar en los conocimientos impartidos. Cuando se presenta una sección de contenido, es más con el objetivo de presentar una guía sobre qué contenido será impartido, ilustrar un posible enfoque para introducir dicho contenido, y quizá además para acotar ciertas cuestiones específicas que consideramos de especial importancia. En cualquier caso, los estudiantes pueden encontrar también en este documento respuestas a preguntas de su interés, no solo desde el punto de vista puramente técnico (preguntas sobre el contenido) sino también desde el punto de vista metodológico (preguntas sobre la forma, o preguntas sobre las preguntas). De esta manera pueden entender mejor qué podemos prometerles como instructores, que se espera de ellos en cambio, y de qué forma pueden sacar el máximo provecho de este curso.

## Diseño del Curso

Este curso fue diseñado bajo una concepción más dinámica e interactiva, más integrada con el resto de las disciplinas, y más práctica, pero sin perder en formalidad, precisión y profundidad en el conocimiento impartido. Para desarrollar este curso, primeramente nos planteamos primerante la siguiente pregunta: *¿Cuáles son las cuestiones fundamentales que esta asignatura ayuda a responder y comprender?*

El objetivo de esta pregunta es cuestionarse primeramente el porqué de un curso de Compilación, antes de decidir qué contenidos específicos se deben incluir. Para ellos analizamos el lugar que ocupa la asignatura dentro del plan general de la carrera de Ciencia de la Computación, y los diversos conocimientos que enlaza. De esta forma pretendemos diseñar un curso más integrado y de mayor utilidad para la formación profesional.

En una primera mirada, el curso de Compilación ocupa un lugar privilegiado dentro de la carrera. Ocurre justo en un momento donde los estudiantes han obtenido la mayor parte de los conocimientos básicos (programación, diseño de algoritmos, lógica y matemática y discreta), y están a punto de comenzar a adentrarse en las cuestiones propias de la Ciencia de la Computación. Esta asignatura viene a ser, de un modo tal vez un poco arrogante, la asignatura más integradora de toda esta primera parte. En este punto los estudiantes conocen cuestiones de muy alto nivel, tales como diseños de algoritmos y estructuras de datos, teoría de la computabilidad y la complejidad computacional, patrones de diseño y diversos paradigmas de programación, así como una creciente colección de lenguajes de programación particulares. Además conocen muchos detalles de bajo nivel, tales como la arquitectura de los procesadores, la memoria, los procesos y los sistemas operativos, lenguajes de máquina y ensambladores y modelos computacionales para la implementación de operaciones aritméticas eficientes.

Compilación viene a ser la asignatura que enlaza estos dos mundos, el de alto nivel, y el de bajo nivel. Por primera vez los estudiantes pueden hacerse una idea del proceso completo que sucede desde la concepción de una idea de un algoritmo o sistema, su análisis, su implementación en un lenguaje de alto nivel (o varios lenguajes, frameworks y bibliotecas), y como todo ello se traduce a un lenguaje de máquina, y se ejecuta encima de un dispositivo de cómputo concreto. Desde este punto de vista, Compilación permite integrar los conocimientos del resto de las disciplinas de esta primera parte de la carrera, y viene a cerrar lo que podemos llamar el perfil básico del Científico de la Computación. Es en cierta forma la última de las asignaturas básicas y la primera de las asignaturas avanzadas.

En una primera enumeración, podemos intentar definir habilidades y conocimientos concretos que los estudiantes pueden aspirar a obtener en esta asignatura. Un buen ejercicio consiste en preguntar a los propios estudiantes qué creen que deberían aprender en esta asignatura. Aunque realmente no tienen una idea clara de cuál es el campo de estudio que tienen delante, o dicho de otra forma, sobre qué *deberían* aprender; hemos encontrado que los estudiantes sí tienen expectativas bastante claras sobre qué *quieren* aprender. Por supuesto, encontrar un balance adecuado entre ambos intereses (los *nuestros* y los *suyos*) debe ser un objetivo a perseguir. Presentamos a continuación una posible e incompleta lista de estas habilidades, que hemos recopilado de varias sesiones de preguntas a estudiantes, edulcoradas con nuestras propias concepciones:

- Reconocer problemas típicos de compilación y teoría de lenguajes.
- Crear reconocedores y generadores de lenguajes.
- Entender el funcionamiento de un compilador.
- Saber cómo se implementan instrucciones de alto nivel.
- Diseñar lenguajes de dominio específico.
- Poder implementar intérpretes y compiladores de un lenguaje arbitrario.
- Entender las diferencias y similaridades entre lenguajes distintos.
- Conectar lenguajes de alto nivel con arquitecturas de máquina.
- Aprender técnicas de procesamiento de lenguaje natural.

Estas habilidades cubren desde los temas más prácticos sobre el diseño de lenguajes y compiladores hasta cuestions más filósoficas y abstractas relacionadas con otras áreas del conocimiento, desde la ingeniería de software hasta la inteligencia artificial. Los estudiantes quieren no sólo ser capaces de *hacer*, sino también, y tal vez más importante, quieren ser capaces de *entender* cómo funcionan los algoritmos, técnicas, estructuras de datos, patrones de diseño, modelos de razonamiento, que son empleados en esta ciencia.

Para dar forma a un curso que pueda ayudar a los estudiantes a obtener estas habilidades (y otras relacionadas), nos dimos entonces a la tarea de resumir las preguntas o cuestiones fundamentales que debe responder dicho curso. En una primera instancia, parece que una pregunta tan clara cómo *¿qué es un compilador?* o incluso *¿cómo funciona un compilador?* puede servir de guía al contenido del curso. Sin embargo, en una mirada más profunda, podemos descubrir que hay cuestiones más primarias, a las cuáles un compilador es ya una respuesta, un medio más que un fin en sí mismo. De hecho, podemos cuestionarnos porqué surgió la necesidad de hacer compiladores en primer lugar, a qué problema intentaron dar respuesta, y tratar de escarbar entonces las preguntas más primarias que subyacen en esta historia.

Podemos comenzar esta historia más o menos así. Hay una gran distancia entre el nivel de razonamiento que ocurre en el cerebro y el nivel de razonamiento que ocurre en una computadora. Los problemas de cualquier dominio se resuelven pensando a un nivel de abstracción con un lenguaje que describe las reglas de ese dominio. Hubo una época en que estos niveles de abstracción tenía que conectarlos el programador. De hecho, en esta época, la diferencia entre analista y programador era justamente que el analista diseñaba la solución en su lenguaje, y el programador la traducía a un programa ejecutable en el lenguaje de máquina.

Por ejemplo, en 1952 Grace Hooper trabajaba en la simulación de trayectorias balísticas. Para dirigir un proyectil a su objetivo, los modelos físicos se describen en un lenguaje de ecuaciones diferenciales y mecánica newtoniana. Sin embargo, para poder implementar estos modelos en un dispositivo de cómputo hay que hablar en un lenguaje de registros, pilas e interrupciones. Esta diferencia es lo que hace que programar sea tan difícil, y hacía extremadamente lento el desarrollo de nuevos modelos porque a cada paso podían haber errores tanto en la modelación como en la codificación. ¿Cuando algo fallaba, de quién era la culpa? ¿Del analista o del programador? ¿O peor, del sistema de cómputo?

Entonces a Grace Hooper se le ocurrió una genial idea: viendo que el proceso de convertir las ecuaciones diferenciales a programas concretos era fundamentalmente mecánico, ¿por qué no dejar que la propia computadora haga esta conversión?

Esta idea genial tomaría varios en perfeccionarse al punto de ser una realidad. El primer compilador de Grace Hooper para el lenguaje A-0 realmente era prácticamente un linker con algunas funciones básicas. Los primeros lenguajes de alto nivel en tener compiladores "serios" son FORTRAN (1957, John Backus), ALGOL (1958, Friedrich Bauer) y COBOL (1960, Grace Hooper). Una ventaja adicional además de reducir el tiempo de desarrollo, era la posibilidad de compilar el mismo programa para múltiples plataformas. En 1960 por primera vez se compiló el mismo programa de COBOL para dos máquinas distintas: UNIVAC II y RCA 501.

En este punto los lenguajes se volvieron suficientemente complicados, que ya los compiladores no se podían escribir "a mano". Entonces hizo falta volcarse a la teoría, y desarrollar una ciencia sobre qué tipos de lenguajes de programación se podían compilar, y con qué compiladores. Esto dio nacimiento, en 1960, a la ciencia que hoy conocemos como Compilación. Motivada no solo por un motivo práctico, sino también fundamentada en los principios teóricos más sólidos, la compilación vino a convertirse en una de las primeras justificaciones para que la computación se cuestionara problemas propios, y dejara de ser una mera herramienta de cálculo. Problemas tan distantes como el procesamiento de lenguaje natural y la naturaleza de las funciones computables han caído bajo el diapasón de las problemáticas estudiadas en este campo. Hoy la compilación es una ciencia sólida, fundamentada en años de teoría formal y práctica ingenieril.

Escondida bajo todo este aparataje formal y toda la gama de experiencias y resultados teóricos y prácticos de los últimos 60 años, podemos encontrar una cuestión más fundamental, una pregunta que quizá retroceda hasta el propio Alan Turing, o incluso más allá, hasta Ada Lovelace y Charles Babbage con su máquina analítica. La cuestión es esta:

> **¿Cómo hablar con una computadora?**

Esta pregunta es, a nuestro modo de ver, en última instancia la cuestión a responder en este curso. Todos los intentos de diseñar lenguajes, todos los algoritmos y técnicas descubiertos, todos los patrones de diseño y arquitecturas, están en última instancia ligados al deseo de poder hacer una *pregunta* a la computadora, y obtener una *respuesta* a cambio. No importa si la pregunta es calcular cierta trayectoria de proyectiles, o encontrar la secuencia de parámetros que minimizan cierta función. Todo programa es en cierto modo una conversación con la computadora, un canal de comunicación, que queremos que sea lo suficientemente poderoso como para poder expresar nuestras ideas más complejas, y lo suficientemente simple como para poder ser entendido por una máquina de Turing. Como veremos en este curso, hallar el balance adecuado es un problema sumamente interesante, e intentar responderlo nos llevará por un camino que nos planteará muchas otras interrogantes, entre ellas las siguientes:

- ¿Qué tipos de lenguajes es capaz de *entender* una computadora?
- ¿Cuánto de un lenguaje debe ser *entendido* para poder entablar una conversación?
- ¿Qué es *entender* un lenguaje?
- ¿Es igual de fácil o difícil *entender* que *hablar* un lenguaje?
- ¿Podemos caracterizar los lenguajes en términos computacionales según su complejidad para ser *entendidos* por una computadora?
- ¿Cómo se relacionan estos lenguajes con el lenguaje humano?
- ¿Qué podemos aprender sobre la naturaleza de las computadoras y los problemas computables, a partir de los lenguajes que son capaces de reconocer?
- ¿Qué podemos aprender sobre el lenguaje humano para hacer más inteligentes a las computadoras?
- ¿Qué podemos aprender sobre el lenguaje humano, y la propia naturaleza de nuestra inteligencia, a partir de estudiar los lenguajes entendibles por distintos tipos de máquinas?

Estas preguntas, aunque no serán directamente respondidas en los siguientes capítulos, forman la columna vertebral del contenido del curso, en el sentido en qué todo lo presentado es con la intención de, al menos, poder echar un poco de luz en estos temas. Esperamos que al finalizar el curso, los estudiantes sean capaces de discutir las implicaciones filosóficas de las posibles respuestas a estas preguntas, y no solo a las cuestiones técnicas o más prácticas que el curso ataca. Por este motivo, sí trataremos en la medida de lo posible de, además del contenido técnico, adicionar en ocasiones algunos comentarios o discusiones más filósoficas al respecto de estas preguntas y otras similares.

## Contenido

Para intentar responder algunas de las interrogantes planteadas arriba, hemos dividido el contenido del curso en 6 temas fundamentales, aunque existen muchos elementos que son trans-temáticos y por tanto no quedarían bien ubicados en ningún lugar particular. Por este mismo motivo, estos temas no deben tomarse como particiones rígidas del contenido, sino más bien guías a grandes razgos que giran alrededor de un concepto común. Cada uno de los temas presentados a continuación tiene un capítulo para sí, divido en varias secciones según sea conveniente. Aunque no es una guía absoluta, la división entre las secciones se ha hecho teniendo en cuenta que sea útil para organizar conferencias. De modo que consideramos que una conferencia sobre un tema particular no debería comenzar ni terminar por el medio de una sección, sino abarcar una, dos o más secciones completas de un mismo tema.

### Teoría de Lenguajes

En este tema trataremos

  - Definiciones matemáticas y computacionales
  - Tipos de lenguajes y características
  - Equivalencias y relaciones entre lenguajes
  - Problemas interesantes sobre lenguajes
  - Relación entre la teoría de lenguajes y la computabilidad
- Mecanismos de generación (gramáticas)
  - Jerarquía de gramáticas de Chomsky
  - Gramáticas atributadas
  - Formas normales y algoritmos de conversión
- Mecanismos de reconocimiento (autómatas)
  - Tipos de autómatas según el tipo de lenguaje
  - Conversión entre autómatas y expresiones regulares
  - Autómatas para el problema de *parsing*
- Semántica
  - Representaciones semánticas y problemas típicos
  - Solución de referencias y *aliases*
  - Inferencia de tipos y expresiones
  - Validación de pre- y post-condiciones e invariantes
- Generación de código
  - Semánticas operacionales
  - Arquitecturas de generación código
  - Optimizaciones
- Ejecución de código
  - Intérpretes y máquinas virtuales
  - Manejo de excepciones
  - Recolección de basura

## Estructura del Documento

Las 4 preguntas presentadas anteriormente constituyen para nosotros una guía transversal a todo el diseño del curso. Empleamos estas preguntas para analizar el contenido general a impartir, pero también para decidir en cada conferencia, cada clase práctica, incluso cada proyecto o ejercicio particular, qué proveer y qué esperar. Por este motivo, a lo largo de todo este documento, estaremos regresando a estas preguntas una y otra vez, cada vez que surga la necesidad. Las presentaremos al inicio de cada capítulo para explicar la concepción general de ese conjunto de conocimientos.
