# Gramáticas Atributadas

Hasta el momento hemos visto como obtener un árbol de derivación de un lenguaje, y luego hemos presentado el árbol de sintaxis abstracta como una descripción más cómoda para realizar análisis semántico. Sin embargo, todavía no tenemos un mecanismo para construir un árbol de sintaxis abstracta a partir de un árbol de derivación. En principio, podemos pensar en estrategias *ad-hoc*, y para cada gramática particular escribir un algoritmo que construye el AST. De forma general estos algoritmos serán estrategias recursivas que irán recorriendo el árbol de derivación y computando fragmentos del AST a partir de los fragmentos obtenidos en los nodos hijos. En este capítulo veremos un esquema formal para describir esta clase de algoritmos, que además nos permitirá resolver varios problemas dependientes del contexto de forma elegante y sencilla.

## Construyendo un AST

* ver la gramática de expresiones nuevamente
* definir un AST en forma de jerarquía de clases
* ver de forma intuitiva una estrategia recursiva para transformar el árbol de derivación al AST
* definir una jerarquía de clases para el árbol de derivación
* implementar el algoritmo en el árbol de derivación
* ejecutar a mano un ejemplo

## Gramáticas Atributadas

* comentar sobre la noción de atributos y reglas
* formalizar el concepto de gramáticas atributadas
* ejemplificar
