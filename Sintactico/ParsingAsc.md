## Parsing Ascendente (*Bottom-Up*)

En la sección anterior vimos las técnicas de parsing descendente, y aprendimos algunas de las limitaciones más importantes que tienen. Dado que el objetivo es poder predecir exactamente que producción es necesario ejecutar en cada momento, las gramáticas LL(1) tienen fuertes restricciones. En particular, deben estar factorizadas, y no pueden tener recursión izquierda (criterios son necesarios pero no suficientes). Por este motivo, para convertir una gramática "natural" en una gramática LL(1) es necesario adicionar no-terminales para factorizar y eliminar la recursión, que luego no tienen ningún significado semántico. Los árboles de derivación de estas gramáticas son por tanto más complejos, y tienen menos relación con el árbol de sintaxis abstracta que queremos obtener finalmente (aunque aún no hemos definido este concepto formalmente).

Intuitivamente, el problema con los parsers descendentes, es que son demasiado exigentes. En cada momento, se quiere saber qué producción hay que aplicar para obtener la porción de cadena que sigue. En otras palabras, a partir de una forma oracional, tenemos que decidir cómo expandir el no-terminal más a la izquierda, de modo que la siguiente forma oracional esté "más cerca" de generar la cadena. Por este motivo se llama parsing descendente.

¿Qué pasa si pensamos el problema de forma inversa? Comenzamos con la cadena completa, y vamos a intentar reducir fragmentos de la cadena, aplicando producciones "a la inversa" hasta lograr reducir toda la cadena a `S`. En vez de intentar adivinar que producción aplicar "de ahora en adelante", intentaremos deducir, dado un prefijo de la cadena analizado, qué producción se puede "des-aplicar" para reducir ese prefijo a una forma oracional que esté "más cerca" del símbolo inicial.  Si pensamos el problema de forma inversa, puede que encontremos una estrategia de parsing que sea más permisiva con las gramáticas.

Veamos un ejemplo. Recordemos la gramática "natural" no ambigua para expresiones aritméticas:

    E = T + E | T
    T = int * T | int | ( E )

Y la cadena de siempre: `int * ( int + int )`. Tratemos ahora de construir una derivación "de abajo hacia arriba", tratando de reducir esta cadena al símbolo inicial `E` aplicando producciones a la inversa. Vamos a representar con una barra vertical `|` el punto que divide el fragmento de cadena que hemos analizado del resto. De modo que empezamos por:

    |int * ( int + int )

Miramos entonces el primer token:

     int|* ( int + int )

El primer token de la cadena es `int`, que se puede reducir aplicando `T -> int` a la inversa. Sin embargo, esta reducción no es conveniente. ¿Por qué? El problema es que queremos lograr reducir hasta `E`, por tanto hay que tener un poco de "luz larga" y aplicar reducciones que, en principio, dejen la posibilidad de seguir reduciendo hasta `E`. Como no existe ninguna producción que derive en `T * w`, si reducimos `T -> int` ahora no podremos seguir reduciendo en el futuro. Más adelante formalizaremos esta idea. Seguimos entonces buscando hacia la derecha en la cadena:

     int *|( int + int )
     int * (|int + int )
     int * ( int|+ int )

En este punto podemos ver que sí es conveniente reducir `T -> int`, porque luego viene un `+` y tenemos, en principio, la posibilidad de seguir reduciendo aplicando `E -> T + E` en el futuro:

     int * ( T|+ int )

Avanzamos hacia el siguiente token reducible:

     int * ( T +|int )
     int * ( T + int|)

Aquí nuevamente podemos aplicar la reducción `T -> int`:

     int * ( T + T|)

Antes de continuar, dado que tenemos justo delante de la barra (`|`) un sufijo `T + T`, deberíamos darnos cuenta que es conveniente reducir `E -> T` para luego poder reducir `E -> T + E`:

     int * ( T + E|)
     int * ( E|)

En este punto, no hay reducciones evidentes que realizar, así que seguimos avanzando:

     int * ( E )|

Hemos encontrado entonces un sufijo `( E )` que podemos reducir con `T -> (E)`:

     int * T|

Luego reducimos `T -> int * T`:

     T|

Y finalmente reducimos `E -> T`:

     E

En este punto hemos logrado reducir al símbolo inicial toda la cadena. Veamos la secuencia de formas oracionales que hemos obtenido:

     int * ( int + int )
     int * ( T + int )
     int * ( T + T )
     int * ( T + E )
     int * ( E )
     int * T
     T
     E

Si observamos esta secuencia en orden inverso, veremos que es una derivación extrema derecha de `E -*-> int * ( int + int )`. Justamente, un parser ascendente se caracteriza porque construye una derivación extrema derecha en orden inverso, desde la cadena hacia el símbolo inicial. Tratemos ahora de formalizar este proceso.

De forma general hemos hecho dos tipos de operaciones en nuestro análisis, que llamaremos **shift** y **reduce**. La operación **shift** nos permite mover la barra `|` un token hacia la derecha, lo que equivale a decir que analizamos el siguiente token. La operación **reduce** nos permite coger un sufijo de la forma oracional que está antes de la barra `|` y reducirla a un no-terminal, aplicando una producción a la inversa (o "desaplicando" la producción). Veamos nuevamente la secuencia de operaciones que hemos realizado, notando las que fueron **shift** y las que fueron **reduce**:

    |int * ( int + int )   [shift]
     int|* ( int + int )   [shift]
     int *|( int + int )   [shift]
     int * (|int + int )   [shift]
     int * ( int|+ int )   [reduce]
     int * ( T|+ int )     [shift]
     int * ( T +|int )     [shift]
     int * ( T + int|)     [reduce]
     int * ( T + T|)       [reduce]
     int * ( T + E|)       [reduce]
     int * ( E|)           [shift]
     int * ( E )|          [reduce]
     int * T|              [reduce]
     T|                    [reduce]
     E                     [reduce]

