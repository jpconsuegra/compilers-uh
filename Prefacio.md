# Prefacio {-}

Este documento tiene como objetivo presentar el diseño de un curso de un semestre de Compilación para estudiantes de Ciencia de la Computación. El documento está dirigido a los profesores y no directamente a los estudiantes. Por este motivo discute fundamentalmente cuestiones metodológicas, pero también presenta secciones de contenido "puro" que pueden servir tanto a los profesores como a los estudiantes. Sin embargo, este documento no es en absoluto un libro de texto de la asignatura Compilación (ni pretende serlo). Se asume que los profesores y estudiantes cuentan con documentación adicional para profundizar en los conocimientos impartidos. Cuando se presenta una sección de contenido, es más con el objetivo de presentar una guía sobre qué contenido será impartido, ilustrar un posible enfoque para introducir dicho contenido, y quizá además para acotar ciertas cuestiones específicas que consideramos de especial importancia. En cualquier caso, los estudiantes pueden encontrar también en este documento respuestas a preguntas de su interés, no solo desde el punto de vista puramente técnico (preguntas de la asignatura) sino principalmente del punto de vista metodológico (preguntas sobre la asignatura). De esta forma pueden entender mejor qué podemos prometerles como instructores, que se espera de ellos en cambio, y de qué forma pueden sacar el máximo provecho de este curso.

A los lectores pedimos disculpas de antemano por el lenguaje, que puede parecer demasiado formal o "metodológico" en ocasiones. Prometemos hacer el mayor esfuerzo por amenizar las discusiones tanto como lo permita el tema en cuestión. Desgraciadamente hay cosas que no pueden ser explicadas con palabras simples. Como decía el gran Albert Einstein: "las cosas se deben explicar lo más simple que se pueda, pero no más".

## Diseño del Curso

Este curso fue diseñado bajo una concepción más dinámica e interactiva, más integrada con el resto de las disciplinas, y más práctica, pero sin perder en formalidad, precisión y profundidad en el conocimiento impartido. Para desarrollar este curso, primeramente nos planteamos tres preguntas pilares, que guían todo el diseño, desde las cuestiones de alto nivel, hasta los detalles de implementación. Estas preguntas son las siguientes:

> **¿Cuáles son las cuestiones fundamentales que esta asignatura ayuda a responder y comprender?**

El objetivo de esta pregunta es cuestionarse primeramente el porqué de un curso de Compilación, antes de decidir qué contenidos específicos se deben incluir. Para ellos analizamos el lugar que ocupa la asignatura dentro del plan general de la carrera de Ciencia de la Computación, y los diversos conocimientos que enlaza. De esta forma pretendemos diseñar un curso más integrado y de mayor utilidad para la formación profesional.

En una primera mirada, el curso de Compilación ocupa un lugar privilegiado dentro de la carrera. Ocurre justo en un momento donde los estudiantes han obtenido la mayor parte de los conocimientos básicos (programación, diseño de algoritmos, lógica y matemática y discreta), y están a punto de comenzar a adentrarse en las cuestiones propias de la Ciencia de la Computación. Esta asignatura viene a ser, de un modo tal vez un poco arrogante, la asignatura más integradora de toda esta primera parte. En este punto los estudiantes conocen cuestiones de muy alto nivel, tales como diseños de algoritmos y estructuras de datos, teoría de la computabilidad y la complejidad computacional, patrones de diseño y diversos paradigmas de programación, así como una creciente colección de lenguajes de programación particulares. Además conocen muchos detalles de bajo nivel, tales como la arquitectura de los procesadores, la memoria, los procesos y los sistemas operativos, lenguajes de máquina y ensambladores y modelos computacionales para la implementación de operaciones aritméticas eficientes.

Compilación viene a ser la asignatura que enlaza estos dos mundos, el de alto nivel, y el de bajo nivel. Por primera vez los estudiantes pueden hacerse una idea del proceso completo que sucede desde la concepción de una idea de un algoritmo o sistema, su análisis, su implementación en un lenguaje de alto nivel (o varios lenguajes, frameworks y bibliotecas), y como todo ello se traduce a un lenguaje de máquina, y se ejecuta encima de un dispositivo de cómputo concreto. Desde este punto de vista, Compilación permite integrar los conocimientos del resto de las disciplinas de esta primera parte de la carrera, y viene a cerrar lo que podemos llamar el perfil básico del Científico de la Computación. Es en cierta forma la última de las asignaturas básicas y la primera de las asignaturas avanzadas. En este sentido, podemos considerar que la cuestión fundamental que responde la asignatura es justamente esta:

> *¿Cómo se traduce una idea expresada en un lenguaje de alto nivel a un conjunto de instrucciones ejecutables en un dispositivo de cómputo?*

O más básicamente:

> *¿Cómo se llega de la idea a la ejecución?*

Sin embargo, las cuestiones a responder van mucho a allá de simplemente describir este proceso de "traducción". Los estudiantes descubrirán durante el recorrido necesario para responder a esta interrogante, varias preguntas subyacentes.

> **¿Cuáles son las habilidades principales que obtendrán los estudiantes?**

> **¿Cómo se puede evaluar y retroalimentar el proceso de aprendizaje de los estudiantes?**

> **¿Cómo se puede evaluar y retroalimentar el diseño del curso?**

## Estructura del Documento

Las 4 preguntas presentadas anteriormente constituyen para nosotros una guía transversal a todo el diseño del curso. Empleamos estas preguntas para analizar el contenido general a impartir, pero también para decidir en cada conferencia, cada clase práctica, incluso cada proyecto o ejercicio particular, qué proveer y qué esperar. Por este motivo, a lo largo de todo este documento, estaremos regresando a estas preguntas una y otra vez, cada vez que surga la necesidad. Las presentaremos al inicio de cada capítulo para explicar la concepción general de ese conjunto de conocimientos.
