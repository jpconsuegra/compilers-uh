# Parsing Ascendente (*Bottom-Up*)

En la sección anterior vimos las técnicas de parsing descendente, y aprendimos algunas de las limitaciones más importantes que tienen. Dado que el objetivo es poder predecir exactamente que producción es necesario ejecutar en cada momento, las gramáticas LL(1) tienen fuertes restricciones. En particular, deben estar factorizadas, y no pueden tener recursión izquierda (criterios que son necesarios pero no suficientes). Por este motivo, para convertir una gramática "natural" en una gramática LL(1) es necesario adicionar no-terminales para factorizar y eliminar la recursión, que luego no tienen ningún significado semántico. Los árboles de derivación de estas gramáticas son por tanto más complejos, y tienen menos relación con el árbol de sintaxis abstracta que queremos obtener finalmente (aunque aún no hemos definido este concepto formalmente).

Intuitivamente, el problema con los parsers descendentes, es que son demasiado exigentes. En cada momento, se quiere saber qué producción hay que aplicar para obtener la porción de cadena que sigue. En otras palabras, a partir de una forma oracional, tenemos que decidir cómo expandir el no-terminal más a la izquierda, de modo que la siguiente forma oracional esté "más cerca" de generar la cadena. Por este motivo se llama parsing descendente.

¿Qué pasa si pensamos el problema de forma inversa? Comenzamos con la cadena completa, y vamos a intentar reducir fragmentos de la cadena, aplicando producciones "a la inversa" hasta lograr reducir toda la cadena a `S`. En vez de intentar adivinar que producción aplicar "de ahora en adelante", intentaremos deducir, dado un prefijo de la cadena analizado, qué producción se puede "desaplicar" para reducir ese prefijo a una forma oracional que esté "más cerca" del símbolo inicial.  Si pensamos el problema de forma inversa, puede que encontremos una estrategia de parsing que sea más permisiva con las gramáticas.

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

Si observamos esta secuencia en orden inverso, veremos que es una derivación extrema derecha de `E -*-> int * ( int + int )`. Justamente, un parser ascendente se caracteriza porque construye una derivación extrema derecha en orden inverso, desde la cadena hacia el símbolo inicial. Tratemos ahora de formalizar este proceso. Para ello, notemos primero algunas propiedades interesante que cumple todo parser ascendente. Partimos del hecho que hemos dado como definición de un parser bottom-up:

> Un parser bottom-up construye una derivación extrema derecha de $S \rightarrow^* \omega$.

A partir de este hecho, que hemos dado como definición, podemos deducir una consecuencia muy interesante:

> Sea $\alpha \beta \omega$ una forma oracional en un paso intermedio de un parser ascendente.
> Sea $X \rightarrow \beta$ la siguiente reducción a realizar.
> Entonces $\omega$ es una cadena de terminales (formalmente $\omega \in T^*$).

Para ver por qué esto es cierto, basta notar que si la derivación que construiremos es extrema derecha, la aplicación de $X \rightarrow \beta$ en este paso solamente puede ocurrir si $X$ es el no-terminal más a la derecha. O sea, si $\alpha \beta \omega$ es el paso correspondiente, y reducimos por $X \rightarrow \beta$, entonces el siguiente paso es la forma oracional $\alpha X \omega$, donde $X$ es el no-terminal más a la derecha, debido justamente a que estamos construyendo una derivación extrema derecha.

Esta propiedad nos permite entonces entender que en todo paso de un parser ascendente, cada vez que sea conveniente reducir $X \rightarrow \beta$, es porque existe una posición (que hemos marcado con `|`), tal que $\alpha \beta | \omega$ es la forma oracional, donde $\alpha \beta \in \{ N \cup T \}^*$ y $\omega \in T^*$. Tenemos entonces dos tipos de operaciones que podemos realizar, que llamaremos **shift** y **reduce**. La operación **shift** nos permite mover la barra `|` un token hacia la derecha, lo que equivale a decir que analizamos el siguiente token. La operación **reduce** nos permite coger un sufijo de la forma oracional que está antes de la barra `|` y reducirla a un no-terminal, aplicando una producción a la inversa (o "desaplicando" la producción). Veamos nuevamente la secuencia de operaciones que hemos realizado, notando las que fueron **shift** y las que fueron **reduce**:

    |int * ( int + int )         | shift
     int|* ( int + int )         | shift
     int *|( int + int )         | shift
     int * (|int + int )         | shift
     int * ( int|+ int )         | reduce T -> int
     int * ( T|+ int )           | shift
     int * ( T +|int )           | shift
     int * ( T + int|)           | reduce T -> int
     int * ( T + T|)             | reduce E -> T
     int * ( T + E|)             | reduce E -> T + E
     int * ( E|)                 | shift
     int * ( E )|                | reduce T -> ( E )
     int * T|                    | reduce T -> int * T
     T|                          | reduce E -> T
     E                           | OK

## Parsers *Shift-Reduce*

Debido a estas operaciones, llamaremos a este tipo de mecanismos *parsers shift-reduce*. Veamos de forma general como implementar este tipo de parsers. Notemos que la parte a la izquierda de la barra siempre cambia porque un sufijo es parte derecha de una producción, y se reduce a un no-terminal. La parte derecha solo cambia cuando un terminal "cruza" la barra y se convierte en parte del sufijo que será reducido en el futuro. De forma que la barra que la parte izquierda se comporta como una pila, ya que solamente se introducen terminales por un extremo, y se extraen símbolos (terminales o no-terminales) por el mismo extremo. La parte derecha es simplemente una secuencia de tokens, que se introducen en la pila uno a uno. Formalicemos entonces el funcionamiento de un parser *shift-reduce*.

Un parser *shift-reduce* es un mecanismo de parsing que cuenta con las siguientes estructuras:

* Una pila de símbolos `S`.
* Una secuencia de terminales `T`.

Y las operaciones siguientes:

* **shift**: Si $S = \alpha |$ es el contenido de la pila, y $T = c \omega \$$ la secuencia de terminales, entonces tras aplicar una operación **shift** se tiene en la pila $S' = \alpha c |$, y la secuencia de terminales ahora es $T' = \omega \$$. Es decir, se mete en la pila el token $c$.
* **reduce**: Si $S = \alpha \beta |$ el contenido de la pila, y $X \rightarrow \beta$ es una producción, entonces tras aplicar una operación **reduce $T \rightarrow \beta$** se tiene en la pila $S' = \alpha X |$. La secuencia de terminales no se modifica. Es decir, se extraen de la pila $| \beta |$ símbolos y se introduce el símbolo $X$ correspondiente.


Podemos definir entonces el proceso de parsing como:

> Sea $S = \emptyset$ la pila inicial, $T = \omega \$$ la cadena a reconocer, y $E$ el símbolo inicial, un parser shift-reduce reconoce esta cadena si y solo si existe una secuencia de operaciones **shift** y **reduce** tal que tras aplicarlas se obtiene $S = E$ y $T = \$$.

Es decir, un parser shitf-reduce básicamente tiene que aplicar operaciones *convenientemente* hasta que en la pila solamente quede el símbolo inicial, y se hayan consumido todos los tokens de la cadena de entrada. En este punto, se ha logrado construir una derivación extrema derecha de la cadena correspondiente. Por supuesto, existe un grado importante de no determinismo en esta definición, porque en principio puede haber muchas secuencias de operaciones shift-reduce que permitan llegar al símbolo inicial. Si asumimos que la gramática no es ambigua, y por tanto solo existe una derivación extrema derecha, podemos intuir que debe ser posible construir un parser que encuentre la secuencia de shift-reduce que produce esa derivación. Desgraciadamente esto no es posible para todo tipo de gramáticas libre del contexto, pero existen gramáticas más restringidas para las que sí es posible decidir de forma determinista en todo momento si la operación correcta es **shift** o **reduce**, y en el segundo caso a qué símbolo reducir.

Para simplificar la notación, en ocasiones identificaremos el estado de un parser shift-reduce en la forma $\alpha | \omega$, sobreentendiendo que el estado de la pila es $S = \alpha |$ y la cadena de entrada es $\omega \$$. Diremos además que un estado $\alpha | \omega$ es válido, si y solo si la cadena pertenece al lenguaje, y este estado forma parte de los estados necesarios para completar el parsing de forma correcta.

Este tipo de parsers son en la práctica los más usados, pues permiten reconocer una cadena (y construir la derivación) con un costo lineal en la longitud de la cadena (la misma eficiencia que los parsers LL), y permiten parsear gramáticas mucho más poderosas y expresivas que las gramáticas LL. De hecho, la mayoría de los compiladores modernos usan alguna variante de un parser shift-reduce. La diferencia entre todos ellos radica justamente en cómo se decide en cada paso qué operación aplicar. Formalicemos entonces el problema de decisión planteado. Tomemos de nuevo la gramática anterior, y recordemos que en el paso:

    int|* ( int + int )


Habíamos dicho que aunque era posible reducir `T -> int`, no era convieniente hacerlo, porque caeríamos en una forma oracional que no puede ser reducida a `E`. En particular, en este caso caeríamos en:

    T|* ( int + int )

Y sabemos intuitivamente que esta forma oracional no es reducible a `E`, porque no existe ninguna producción que comience por `T *`, o dicho de otra forma, `*` no pertenece al `Follow(T)`. Tratemos de formalizar entonces este concepto de "momento donde es conveniente reducir". Para ello introduciremos una definición que formaliza esta intuición.

> Sea $S \rightarrow^* \alpha X \omega \rightarrow \alpha \beta \omega$ una derivación extrema derecha de la forma oracional $\alpha \beta \omega$, y $X \rightarrow \beta$ una producción, decimos que $\alpha \beta$ es un **handle** de $\alpha \beta \omega$.

Intuitivamente, un **handle** nos representa un estado en la pila donde es conveniente reducir, porque sabemos que existen reducciones futuras que nos permiten llegar al símbolo inicial. En la definición anterior la pila sería justamente $\alpha \beta |$, y la cadena de terminales sería $\omega \$$. Sabemos que es posible seguir reduciendo, justamente porque hemos definido un **handle** a partir de conocer que existe una derivación extrema derecha donde aparece ese prefijo. De modo que justamente lo que queremos es identificar cuando tenemos un **handle** en la pila, y en ese momento sabemos que es conveniente reducir.

El problema que nos queda es que hemos definido el concepto de **handle** pero no tenemos una forma evidente de reconocerlos. Resulta que, desgraciadamente no se conoce ningún algoritmo para identificar un **handle** unívocamente en cualquier gramática libre del contexto. Sin embargo, existen algunas heurísticas que nos permiten reconocer algunos **handle** en ciertas ocasiones, y afortunadamente existen gramáticas donde estas heurísticas son suficientes para reconocer todos los **handle** de forma determinista. En última instancia, la diferencia real entre todos los parsers shitf-reduce radica en la estrategia que usen para reconocer los **handle**. Comenzaremos por la más simple.

## Reconociendo **Handles**

La forma en la que hemos definido el concepto de **handle** nos permite demostrar una propiedad interesante:

> En un parser shift-reduce, los **handles** aparecen solo en el tope de la pila, nunca en su interior.

Podemos esbozar una idea de demostración a partir de una inducción fuerte en la cantidad de operaciones **reduce** realizadas. Al inicio, la pila está vacía, y por tanto la hipótesis es trivialmente cierta. Tomemos entonces un estado intermedio de la pila $\alpha \beta |$ que es un **handle**. Además, es el único **handle** por hipótesis de inducción fuerte, ya que de lo contrario tendríamos un **handle** en el interior de la pila. Al reducir, el no-terminal más a la derecha queda en el tope de la pila, ya que es una derivación extrema derecha. Por tanto tendremos un nuevo estado en la pila $\alpha X |$. Ahora pueden suceder 2 cosas, o bien este estado es un **handle** también (y se cumple la hipótesis), o en caso contrario el siguiente **handle** aparecerá tras alguna secuencia solamente de operaciones **shift**. Este nuevo **handle** tiene que aparecer también en el tope de la pila, pues si apareciera en el interior de la pila, tendría que haber estado antes de $X$ (lo que es falso por hipótesis de inducción), o tendría que haber aparecido antes del último terminal al que se le hizo **shift**, pero en tal caso deberíamos haber hecho **reduce** en ese **handle**, lo que contradice el hecho de que solo han sucedido operaciones **shift** desde el último **reduce**.

Este teorema nos permite, en primer lugar, formalizar la intuición de que solamente hacen falta movimientos **shift** a la izquierda. Es decir, una vez un terminal ha entrado en la pila, o bien será reducido en algún momento, o bien la cadena es inválida, pero nunca hará falta sacarlo de la pila y volverlo a colocar en la cadena de entrada.

Por otro lado, este teorema nos describe la estructura de la pila, lo que será fundamental para desarrollar un algoritmo de reconocimiento de **handles**. Dado que los **handles** siempre aparecen en el tope de la pila, en todo momento tendremos, en principio, un prefijo de un **handle**. De modo que una idea útil para reconocer **handles** es intentar reconocer cuales son los prefijos de un **handle**. En general, llamaremos *prefijo viable* a toda forma oracional $\alpha$ que puede aparecer en la pila durante un reconocimiento válido de una cadena del lenguaje. Formalmente:

> Sea $\alpha | \omega$ un estado válido de un parser shift-reduce durante el reconocimiento de una cadena, entonces decimos que $\alpha$ es un prefijo viable.

Intuitivamente, un prefijo viable es un estado en el cual todavía no se ha identificado un error de parsing, por lo que, hasta donde se sabe, la cadena todavía pudiera ser reducida al símbolo inicial. Si podemos reconocer el lenguaje de todos los prefijos viables, en principio siempre sabremos si la pila actual representa un estado válido. Además podemos intuir que esto nos debería ayudar a decidir si hacer un **shift** o un **reduce**, según cual de las dos operaciones nos mantenga el contenido de la pila siendo un prefijo viable. De modo que hemos reducido el problema de identificar **handles** (de forma aproximada) al problema de identificar prefijos viables.

Si analizamos todos los posibles estados válidos de la pila (los posibles prefijos viables), notaremos una propiedad interesante que nos ayudará a reconocer estos prefijos. Supongamos que tenemos un estado $\alpha \beta | \omega$ que es un **handle** para $X \rightarrow \beta$. Entonces por definición $\alpha \beta$ es también un prefijo viable. Además, una vez aplicada la reducción, tendremos el estado $\alpha X | \omega$. Por tanto $\alpha X$ también es un prefijo viable, porque de lo contrario esta reducción sería inválida, contradiciendo el hecho de que hemos reducido correctamente en un **handle**. Por tanto o bien $\alpha X$ es un **handle** en sí, o es un prefijo de un **handle**. En el segundo caso, entonces hay una producción $Y \rightarrow \theta X \phi$, tal que $\alpha = \delta \theta$. Es decir, hay un sufjo de $\alpha X$ que tiene que ser prefijo de la parte derecha de esa producción.

¿Por qué?, pues porque como hemos reducido en un **handle**, esto quiere decir que sabemos que es posible en principio seguir reduciendo, por tanto tiene que haber alguna secuencia de tokens $\phi$, que pudiera o no venir en $\omega$ (aún no sabemos), que complete la parte derecha $\theta X \phi$. Es decir, como sabemos que potencialmente podríamos seguir reduciendo, entonces lo que tenemos en la pila ahora tiene que ser prefijo de la parte derecha de alguna producción. Si no lo fuera, ya en este punto podríamos decir que será imposible seguir reduciendo en el futuro, puesto que solamente introduciremos nuevos tokens en la pila, y nunca tocaremos el interior de la pila (excepto a través de reducciones, que siempre modifican el tope de la pila).

Esta intuición nos dice algo muy importante sobre el contenido de la pila:

> En todo estado válido $\alpha | \omega$ de un parser shift-reduce, la forma oracional $\alpha$ es una secuencia $\alpha = \beta_1 \beta_2 \ldots \beta_n$ donde para cada $\beta_i$ se cumple que existe una producción $X \rightarrow \beta_i \theta$.

Es decir, todo estado válido de la pila es una concatenación de prefijos de partes derechas de alguna producción. En caso contrario, tendríamos una subcadena en la pila que no forma parte de ninguna producción, por tanto no importa lo que pase en el futuro, esta subcadena nunca sería parte de un **reduce**, y por tanto la cadena a reconocer tiene que ser inválida. Más aún, podemos decir exactamente de cuales producciones tienen que ser prefijo esas subcadenas. Dado que en última instancia tenemos que reducir al símbolo inicial $S$, entonces en la pila tenemos necesariamente que encontrar prefijos de todas las producciones que participan en la derivación extrema derecha que estamos construyendo. Formalmente:

> Sea $S \rightarrow^* \alpha \delta \rightarrow^* \omega$ la única derivación extrema derecha de $\omega$, sea $\alpha | \delta$ un estado de un parser shift-reduce que construye esta derivación, sea $X_1 \rightarrow \theta_1, \ldots, X_n \rightarrow \theta_n$ la secuencia de producciones a aplicar tal que $S \rightarrow^* \alpha \delta$, entonces $\alpha = \beta_1 \ldots \beta_n$, donde $\beta_i$ es prefijo de $\theta_i$.

Es decir, en todo momento en la pila lo que tenemos es una concatenación de prefijos de todas las producciones que quedan por reducir. Notemos intuitivamente que esto debe ser cierto, porque el parser va a construir esta derivación al revés. Por tanto en el estado $\alpha | \delta$, que corresponde a la forma oracional $\alpha \delta$ en la derivación, el parser ya ha reconstruido todas las producciones finales, que hacen que $\alpha \delta \rightarrow^* \omega$ (de atrás hacia adelante), y le falta por reconstruir las producciones que hacen que $S \rightarrow^* \alpha \delta$. Luego, lo que está en la pila tiene que reducirse a $S$, y como solo puede pasar que se metan nuevos terminales de $\delta$, todo lo que está en $\alpha$ tiene que de algún modo poderse encontrar en alguna de las producciones que faltan por reducir. De lo contrario, esta reducción sería imposible.

Por supuesto, muchos de los prefijos $\beta_i$ pueden ser $\epsilon$, porque todavía no han aparecido ninguno de los símbolos que forman la producción en la pila (dependen de que reducciones siguientes introduzcan un no-terminal, o de que **shifts** siguientes introduzcan un terminal). De esta forma podemos entender que incluso la pila vacía es una concatenación de prefijos de producciones, todos $\epsilon$. Lo que no puede pasar es que tengamos una subcadena $\beta_k$ que no forme parte de ningún prefijo de ninguna producción, porque entonces nunca podremos reducir totalmente al símbolo inicial. De modo que un prefijo viable no es nada más que una concatenación de prefijos de las producciones que participan en la derivación extrema derecha que queremos construir.

Para ver un ejemplo tomemos nuevamente nuestra gramática favorita:

    E -> T + E | T
    T -> int * T | int | (E)

Y veamos la cadena `( int )`. La derivación extrema derecha que nos genera esta cadena es:

    E -> T -> ( E ) -> ( T ) -> ( int )

Para esta cadena `( E | )` es un estado válido, pues en el siguiente **shift** aparecerá el token `)` que permite reducir (en dos pasos `T -> ( E )` y `E -> T`) al símbolo inicial. Por tanto, `( E` es un prefijo viable. Veamos cómo este prefijo es una concatenación de prefijos de las dos producciones que faltan por reducir. Evidentemente `( E` es prefijo de `T -> ( E )`, y además, $\epsilon$ es prefijo de `E -> T`.

Esta idea es la pieza fundamental que nos permitirá deducir un algoritmo para reconocer prefijos viables. Como un prefijo viable no es más que una concatenación de prefijos de partes derechas de producciones, simplemente tenemos que reconocer *el lenguaje de todas las posibles concatenaciones de prefijos de partes derechas de producciones, que pudieran potencialmente aparecer en una derivación extrema derecha*. Parece una definición complicada, pero dado que conocemos la gramática que queremos reconocer, es de hecho bastante fácil. Notemos que hemos dicho, *que pudieran aparecer en una derivación*, lo cual nos debe dar una idea de cómo construir estas cadenas. Simplemente empezaremos en el símbolo inicial $S$, y veremos todas las posibles maneras de derivar, e iremos rastreando los prefijos que se forman. Para esto nos auxiliaremos de un resultado teórico impresionante, que fundamenta toda esta teoría de parsing bottom-up:

> El lenguaje de todos los prefijos viables de una gramática libre del contexto es regular.

Aunque parece un resultado caído del cielo, de momento podemos comentar lo siguiente. En principio, el lenguaje de todos los posibles prefijos de cada producción es regular (es finito). Y la concatenación de lenguajes regulares es regular. Por tanto, de alguna forma podríamos intuir que este lenguaje de todas las posibles concatenaciones de prefijos debería ser regular. Por tanto debería ser posible construir un autómata finito determinista que lo reconozca. Claro, queda la parte de que no son *todas* las concatenaciones posibles, sino solo aquellas que aparecen en alguna derivación extrema derecha. Tratemos entonces de construir dicho autómata, y a la vez estaremos con esto demostrando que efectivamente este lenguaje es regular. Recordemos que en última instancia lo que queremos es un autómata que lea el contenido de la pila, y nos diga si es un prefijo viable o no.

Para entender como luce este autómata, introduciremos primero un concepto nuevo. Llamaremos **item** a una cadena de la forma $X \rightarrow \alpha . \beta$. Es decir, simplemente tomamos una producción y le ponemos un punto (`.`) en cualquier lugar en su parte derecha. Este **item** formaliza la idea de ver los posibles prefijos de todas las producciones. Por cada producción $X \rightarrow \delta$, tenemos $|\delta|+1$ posibles **items**. Por ejemplo, en la gramática anterior, tenemos los siguientes **items**:

    E -> .T + E
    E ->  T.+ E
    E ->  T +.E
    E ->  T + E.

    E -> .T
    E ->  T.

    T -> .int * T
    T ->  int.* T
    T ->  int *.T
    T ->  int * T.

    T -> .int
    T ->  int.

    T -> .( E )
    T ->  (.E )
    T ->  ( E.)
    T ->  ( E ).

Cada uno de estos **items** nos representa un posible prefijo de una producción. Pero además, cada **item** nos permite también rastrear que esperamos ver a continuación de dicha producción, si es que realmente esa producción fuera la que tocara aplicar a continuación. Veamos entonces qué podemos decir de cómo estos **items** se relacionan entre sí. Tomemos por ejemplo el **item** `E -> T.+ E`. Este **item** nos dice que ya hemos visto algo en la cadena que se reconoce como un `T`, y que esperamos ver a continuación un `+`, si resulta que esta es la producción que realmente tocaba aplicar. El **item** `E -> .T + E` nos dice que si realmente esta es la producción correcta, entonces lo que viene en la cadena debería ser reconocible como un `T`, y luego debería vernir un `+`, y luego algo que se reconozca como un `E`. Por último, un **item** como `T -> ( E ).` nos dice que ya hemos visto toda la parte derecha de esta producción, y por tanto intuitivamente deberíamos poder reducir. De modo que estos **items** nos están diciendo además si es conviente hacer **shift** o hacer **reduce**.

Vamos a utilizar ahora estos **items** para construir el autómata finito no determinista que nos dirá que es lo que puede venir el pila. Cada estado de este autómata es uno de los **items**. Vamos a decir que el estado asociado asociado al **item** $X \rightarrow \alpha . \beta$ representa que en el tope de la pila tenemos el prefijo $\alpha$ de esta producción, o en general, algo que es generado por este prefijo $\alpha$. Por tanto, todos los estados son estados finales, puesto que cada estado corresponde a un prefijo de alguna producción. Lo que tenemos que hacer es definir entonces un conjunto de transiciones que solamente reconozcan aquellas secuencias de prefijos que consituyen prefijos viables.

Suponamos ahora que tenemos cierto estado de un parser shift-reduce, y queremos saber si es un estado válido. Hagamos a nuestro autómata leer esta la pila desde el fondo hacia el tope, como si fuera una cadena de símbolos. Supongamos entonces que durante esta lectura nos encontramos en cierto estado del autómata, asociado por ejemplo al **item** `E -> .T`, y hemos leído ya una parte del fondo de la pila, siguiendo las transiciones que aún no hemos definido del todo. La pregunta entonces es qué puede venir a continuación en la pila, justo encima del último símbolo que analizamos. Evidentemente, en la pila podría venir un  no-terminal `T` directamente, que haya aparecido por alguna reducción hecha anteriormente. Si este fuera el caso, entonces todavía tendríamos un prefijo viable. Entonces podemos añadir una transición del estado `E -> .T` al estado `E -> T.`.

Por otro lado, incluso si no viniera directamente un `T`, de todas formas todavía es posible que tengamos un prefijo viable. ¿Cómo? Supongamos que el no-terminal `T` todavía no ha aparecido porque esa reducción aún no ha ocurrido. Entonces lo que debería venir a continuación en la pila es algo que sea prefijo de alguna producción de `T`, de modo que un **reduce** futuro nos ponga ese `T` en la pila. En ese caso, todavía estaríamos en un prefijo viable, porque tendríamos un prefijo de `E -> T`, y luego un prefijo de algo que se genera con `T`. ¿Cómo reconocer entonces cualquier prefijo de cualquier producción que sale de `T`? Pues afortunadamente tenemos estados que hacen justamente eso, dígase `T -> .int` y `T -> .int * T`, es decir, los **items** iniciales de las producciones de `T`. Dado que estamos construyendo un autómata no-determinista, tenemos la libertad de añadir transiciones $\epsilon$ a estos dos estados. De modo que el estado `E -> .T` tiene tres transiciones, con un `T` se mueve a `E -> T.`, y con $\epsilon$ se mueve a `T -> .int` y a `T -> .int * T`.

Por otro lado, si estuviéramos en el estado `E -> T.+ E`, lo único que podemos esperar que venga en la pila es un terminal `+`. En cualquier otro ya no tendríamos un prefijo viable, pues estábamos esperando tener un prefijo de `E -> T + E`, y ya hemos visto en la pila un `T`. Por tanto si fuera cierto que esta pila es un prefijo viable, tendría que venir algo que continuara este prefijo o empezara un nuevo prefijo. Pero dado que en la producción que estamos esperando lo que viene es un terminal, no existe forma de un **reduce** futuro nos ponga en esa posición a dicho terminal (los **reduce** siempre introducen un no-terminal en la pila). Luego, si no viene exactamente un `+` en la pila, ya podemos estar seguros que este prefijo no es viable (claro, como estamos en un autómata no-determinista puede que existan otros caminos donde sí se reconoce un prefijo viable).

De forma general tenemos las siguientes reglas:

* Si tenemos un estado $X \rightarrow \alpha . c \beta$ donde $c$ es un terminal, añadimos una transición con $c$ al estado $X \rightarrow \alpha c . \beta$.
* Si tenemos un estado $X \rightarrow \alpha . Y \beta$ donde $Y$ es un no-terminal, añadimos una transición con $Y$ al estado $X \rightarrow \alpha Y . \beta$, y además por cada producción $Y \rightarrow \delta$ añadimos una transición con $\epsilon$ al estado $Y \rightarrow .\delta$.

Apliquemos entonces estas reglas al conjunto completo de **items** que hemos obtenido anteriormente. Primero definiremos un estado por cada **item**, y luego iremos adicionando las transiciones:

    [ 1]  E -> .T + E     {  }
    [ 2]  E ->  T.+ E     {  }
    [ 3]  E ->  T +.E     {  }
    [ 4]  E ->  T + E.    {  }
    [ 5]  E -> .T         {  }
    [ 6]  E ->  T.        {  }
    [ 7]  T -> .int * T   {  }
    [ 8]  T ->  int.* T   {  }
    [ 9]  T ->  int *.T   {  }
    [10]  T ->  int * T.  {  }
    [11]  T -> .int       {  }
    [12]  T ->  int.      {  }
    [13]  T -> .( E )     {  }
    [14]  T ->  (.E )     {  }
    [15]  T ->  ( E.)     {  }
    [16]  T ->  ( E ).    {  }

Tomemos entonces el estado `E -> .T + E`. Primero ponemos la transición con `T` hacia `E -> T.+ E`:

    [ 1]  E -> .T + E     { T:2 }

Y luego, dado que `T` es un no-terminal, adicionamos las transiciones $\epsilon$ correspondientes a los estados `T -> .int` y `T -> .int * T`:

    [ 1]  E -> .T + E     { T:2, e:7, e:11 }

Por otro lado, para `E -> T.+ E` la única transición válida es con `+`, hacia el estado `E -> T +.E`:

    [ 2]  E ->  T.+ E     { +:3 }

Para el estado `E -> T+.E` igualmente tenemos una transición con `E` y dos transiciones con $\epsilon$:

    [ 3]  E ->  T +.E     { E:4, e:1, e:5 }

El estado `E -> T + E.` no tiene transiciones salientes, pues representa que se ha reconocido toda la producción. Es responsabilidad de otros estados continuar reconociendo (de forma no-determinista) los prefijos que puedan quedar en la pila.

El estado `E -> .T` se parece mucho al estado `E -> .T + E`. De hecho, tiene las mismas transiciones:

    [ 5]  E -> .T         { T:2, e:7, e:11 }

Finalmente el estado `E -> T.` tampoco transiciones salientes. Ya hemos dicho que todos los estados son finales, pues como las transiciones siempre nos mueven de un prefijo viable a otro, en cualquier momento en que se acabe la pila tenemos un prefijo viable reconocido. Solo queda definir el estado inicial. En principio, deberíamos empezar de forma no-determinista por cualquiera de los estados iniciales de las producciones de `E`. Afortunadamente, en un autómata no-determinista tenemos un recurso para simular esta situación en la que queremos 2 estados iniciales. Simplemente añadimos un estado "dummy", con transiciones $\epsilon$ a cada uno de los estados iniciales que deseamos. Desde el punto de la gramática, esto es equivalente a añadir un símbolo nuevo `E'` con la única producción `E' -> E` y convertirlo en el símbolo inicial. Para esta producción tenemos dos nuevos **items**: `E' -> .E` y `E' -> E.`. El estado `E' -> .E` se convertirá en el estado inicial de nuestro autómata.

El estado `E' -> E.` también es convieniente, pues nos permite reconocer que hemos logrado reducir al símbolo inicial, y deberíamos haber terminado de consumir toda la cadena. De modo que este estado "especial" nos permitirá además saber cuando aceptar la cadena. No podemos simplemente aceptar la cadena en cualquier estado donde se reduzca a `E`, porque es posible que estuviéramos reduciendo a un `E` intermedio, por ejemplo, al `E` que luego de ser reducido en `T -> (E)`.

Ahora que hemos visto como se construyen estas transiciones, veamos directamente el autómata completo.

    [ 0] E' -> .E         { E: 17, e:1, e:5 }
    [ 1]  E -> .T + E     { T:2, e:7, e:11 }
    [ 2]  E ->  T.+ E     { +:3 }
    [ 3]  E ->  T +.E     { E:4, e:1, e:5 }
    [ 4]  E ->  T + E.    {  }
    [ 5]  E -> .T         { T:2, e:7, e:11 }
    [ 6]  E ->  T.        {  }
    [ 7]  T -> .int * T   { int:8 }
    [ 8]  T ->  int.* T   { *:9 }
    [ 9]  T ->  int *.T   { T:10, e:7, e:11 }
    [10]  T ->  int * T.  {  }
    [11]  T -> .int       { int:12 }
    [12]  T ->  int.      {  }
    [13]  T -> .( E )     { (:14 }
    [14]  T ->  (.E )     { E:15, e:1, e:5 }
    [15]  T ->  ( E.)     { ):16 }
    [16]  T ->  ( E ).    {  }
    [17] E' ->  E.

A estos **items** se les denomina también **items LR(0)**, que significa *left-to-right rightmost-derivation look-ahead 0*.

## Autómata LR(0)

Hemos construido finalmente un autómata finito no-determinista que reconoce exactamente el lenguaje de los prefijos viables. Sabemos que existe un autómata finito determinista que reconoce exactamente el mismo lenguaje. Aplicando el algoritmo de conversión de NFA a DFA podemos obtener dicho autómata. Sin embargo, hay una forma más directa de obtener el autómata finito determinista, que consiste en construir los estados aplicando el algoritmo de conversión a medida que vamos analizando las producciones y obteniendo los **items**.

Recordemos que el algoritmo de conversión de NFA a DFA básicamente construye un estado por cada subconjunto de los estados del NFA, siguiendo primero todas las transiciones con el mismo terminal, y luego computando la $\epsilon$-clausura del conjunto de estados resultante. Para cada uno de estos "super-estados" $Q_i$, la nueva transición con un terminal concreto $c$ va hacia el super-estado que representa exactamente al conjunto clausura de todos los estados originales a los que se llegaba desde algún estado $q_j \in Q_i$.

Vamos ahora a reescribir este algoritmo, pero teniendo en cuenta directamente que los estados del NFA son **items**. Por tanto, los super-estados del DFA serán conjuntos de **items**, que son justamente la $\epsilon$-clausura de los **items** a los que se puede llegar desde otro conjunto de **items** siguiendo un símbolo concreto $X$ (terminal o no-terminal). Definiremos entonces dos tipos de **items** para simplicar:

* Un **item kernel** es aquel de la forma $E' \rightarrow .E$ si $E'$ es nuevo símbolo inicial, o cualquier item de la forma $X \rightarrow \alpha . \beta$ con $|\alpha|>1$.

* Un **item no kernel** es aquel de la forma $X \rightarrow .\beta$ excepto el **item** $E' \rightarrow .E$.

Hemos hecho estas definiciones, porque de cierta forma los **items kernel** son los realmente importantes. De hecho, podemos definir dado un conjunto de **items kernel**, el conjunto clausura, que simplemente añade todos los **items no kernel** que se derivan de este conjunto.

> Sea $I$ un conjunto de **items** (kernel o no), el conjunto clausura de $I$ se define como $CL(I) = I \cup \{ X \rightarrow .\beta \}$ tales que $Y \rightarrow \alpha .X \delta \in CL(I)$.

Es decir, el conjunto clausura no es más que la formalización de la operación mediante la cuál añadimos todos los **items** no-kernel que puedan obtenerse de cualquier **item** en $I$. Nótese que la definición es recursiva, es decir, el conjunto clausura de $I$ se define a partir del propio conjunto clausura de $I$. Para computarlo, simplemente partimos de $CL(I) = I$ y añadimos todos los items no-kernel que podamos, mientras cambie el conjunto. Por ejemplo, computemos el conjunto clausura del item asociado estado inicial $E' \rightarrow .E$. Partimos del conjunto singleton que solo contiene a este item:

    I = { E' -> .E }

Ahora buscamos todas las producciones de `E` y añadimos sus items iniciales:

    I = { E' -> .E,
           E -> .T,
           E -> .T + E }

Ahora buscamos todas las producciones de `T` y añadimos sus items iniciales:

    I = { E' -> .E,
           E -> .T,
           E -> .T + E,
           T -> .int,
           T -> .int * T,
           T -> .( E ) }

Como no hemos añadido ningún item que tenga un punto delante de un no-terminal nuevo, este es el conjunto final. Notemos que esta definición no es nada más que la definición de $\epsilon$-clausura usada en la conversión de un NFA a un DFA, solo que la hemos definido en función de los **items** directamente. Si aplicamos la $\epsilon$-clausura al estado $q_0$ de nuestro NFA definido anteriormente, llegaremos exactamente al mismo conjunto de **items**.

Una vez que tenemos este conjunto clausura de **items**, podemos definir entonces cómo añadir transiciones. Para ello definiremos la función $Goto(I,X) = J$, que nos mapea un conjunto de items a otro conjunto de items a partir de un símbolo $X$, de la siguiente forma:

> $Goto(I,X) = CL(\{ Y \rightarrow \alpha X. \beta | Y \rightarrow \alpha .X \beta \in I \})$

La función $Goto(I,X)$ simplemente busca todos los items en $I$ donde aparece un punto delante del símbolo $X$, crea un nuevo conjunto donde el punto aparece detrás del símbolo $X$, y luego calcula la clausura de este conjunto. Básicamente lo que estamos es formalizando la misma operación $Goto$ que usábamos en la conversión de NFA a DFA, pero esta vez escrita en función de los **items**. Por ejemplo, si $I$ es el conjunto calculado anteriormente, entonces:

    Goto(I,T) = { E -> T., E -> T. + E }

Dado que no existe ningún punto delante de un no-terminal, no es necesario computar la clausura.

Una vez que tenemos estas dos definiciones, podemos dar un algoritmo para construir el autómata finito determinista que reconoce los prefijos viables. El estado inicial de nuestro autómata será justamente $CL({ E' \rightarrow .E })$. Luego, repetimos la siguiente operación mientras sea necesario: por cada estado $I$ y cada símbolo $X$, añadimos el estado $Goto(I,X)$ si no existe, y añadimos la transición $I \rightarrow^X J$. El algoritmo termina cuando no hay cambios en el autómata.

Apliquemos entonces este algoritmo a nuestra gramática para expresiones. Partimos del estado $I_0$ ya computado:

    I0 = { E' -> .E,
            E -> .T,
            E -> .T + E,
            T -> .int,
            T -> .int * T,
            T -> .( E ) }

Calculemos ahora $Goto(I_0, E)$:

    I1 = { E' -> E. }

Como no hay ningún punto delante de un no-terminal, la clausura se mantiene igual. Calculemos entonces $Goto(I_0, T)$:

    I2 = { E -> T.,
           E -> T.+ E }

Igualmente la clausura no añade items. Calculemos ahora $Goto(I_0, int)$:

    I3 = { T -> int.,
           T -> int.* T }

Y ahora $Goto(I_0, ( )$:

    I4 = { T -> (.E ) }

A este estado si tenemos que calcularle su clausura:

    I4 = { T ->  (.E ),
           E -> .T,
           E -> .T + E,
           T -> .int,
           T -> .int * T,
           T -> .( E ) }

De modo que ya terminamos con $I_0$. Dado que en $I_1$ no hay símbolos tras un punto, calculemos entonces $Goto(I_2,+)$, y aplicamos la clausura directamente:

    I5 = { E ->  T +.E,
           E -> .T,
           E -> .T + E,
           T -> .int,
           T -> .int * T,
           T -> .( E ) }

Calculamos $Goto(I_3, *)$:

    I6 = { T ->  int *.T,
           T -> .int,
           T -> .int * T,
           T -> .( E ) }

Calculamos $Goto(I_4, E)$:

    I7 = { T -> ( E.) }

Si ahora calculamos $Goto(I_4, T)$, y nos daremos cuenta que es justamente $I_2$. Por otro lado, afortunadamente $Goto(I_4, int) = I_3$. Y finalmente $Goto(I_4, ()$ es el propio estado $I_4$! Por otro lado, $Goto(I_5, E)$ es:

    I8 = { E -> T + E. }

Mientras que $Goto(I_5,T)$ nos lleva de regreso a $I_3$, y $Goto(I_5, ()$ a $I_4$. Saltamos entonces para $Goto(I_6, T)$ que introduce un estado nuevo:

    I9 = { T -> int * T. }

Por otro lado, $Goto(I_6, int) = I_3$ nuevamente, mientras que $Goto(I_6, ()$ nos regresa nuevamente a $I_4$. Finalmente, $Goto(I_7, ))$ nos da el siguiente, y último estado del autómata (ya que $I_8$ e $I_9$ no tienen transiciones salientes):

    I10 = { T -> ( E ). }

Para agilizar este algoritmo, podemos notar que, como dijimos anteriormente, solamente los item kernel son importantes. De hecho, podemos probar fácilmente que dos estados son iguales sí y solo si sus item kernel son iguales, dado que las operaciones de clausura sobre conjuntos de items kernel iguales nos darán el mismo conjunto final. Por lo tanto, en una implementación computacional (o un cómputo manual), si distinguimos los items kernel del resto de los items, cuando computamos un nuevo estado a partir de la función $Goto$, antes de computar su clausura vemos si su conjunto de items kernel coincide con el kernel de otro estado ya creado. En caso contrario, hemos descubierto un nuevo estado y pasamos a computar su clausura.

## Parsing LR(0)

Una vez construido el autómata, podemos finalmente diseñar un algoritmo de parsing bottom-up. Este algoritmo se basa en la idea de verificar en cada momento si el estado de la pila es un prefijo viable, y luego, según el terminal que corresponda en $\omega$, decidimos si la operación a realizar es **shift** o **reduce**. Para determinar si la pila es un prefijo viable, simplemente corremos el autómata construido en el contenido de la pila. Supongamos que este autómata se detiene en el estado $I$. Vamos que nos dicen los items de este estado sobre la operación más conveniente a realizar.

Si en este estado tenemos un item $X \leftarrow \alpha .c \beta$, y $c \omega$ es la cadena de entrada (es decir, $c$ es el próximo terminal a analizar), entonces es evidente que una operación de **shift** me seguirá manteniendo en la pila un prefijo viable. ¿Por qué? Pues porque al hacer **shift** el contenido de la pila ahora crece en $c$, y si vuelvo a correr el autómata desde el inicio de la pila, llegaré nuevamente al estado $I$ justo antes de analizar $c$. Pero sé que desde $I$ hay una transición con $c$ a cierto estado $J$, que es justamente $Goto(I, c)$, por lo tanto terminaré en el estado $J$ habiendo leído toda la pila. Luego, por definición de prefijo viable, como he podido reconocer el contenido de la pila, todo está bien.

Por otro lado, si en el estado $I$ tengo un item de la forma $X \leftarrow \beta.$, entonces es conveniente hacer una operación de **reduce** justamente en la producción $X \rightarrow \beta$. Para ver por qué esta operación me sigue manteniendo en la pila un prefijo viable, notemos que $X \rightarrow \beta.$ quiere decir que hemos reconocido en la pila toda la parte derecha de esta producción. Entonces en la pila lo que tenemos en un **handle**, y por su propia definición reducir en un **handle** siempre es correcto.

De modo que tenemos un algoritmo. En cada iteración, corremos el autómata en el contenido de la pila, y analizamos cuál de las estrategias anteriores es válida según el contenido del estado en que termina el autómata. Si en algún momento el autómata no tiene una transición válida, tiene que ser con el último terminal que acabamos de hacer **shift** (ya que de lo contrario se hubiera detectado en una iteración anterior). Luego, este algoritmo reconoce los errores sintácticos lo antes posible. Es decir, nunca realiza una reducción innecesaria.

Por otro lado, puede suceder que en un estado del autómata tenga items que nos sugieran operaciones contradictorias. Llamaremos a estas situaciones, **conflictos**. En general, podemos tener 2 tipos de conflictos:

* Conflicto **shift-reduce** si ocurre que tengo un item que me sugiere hacer **shift** y otro que me sugiere hacer **reduce**.
* Conflicto **reduce-reduce** si ocurre que tengo dos items que me sugieren hacer **reduce** a producciones distintas.

En cualquiera de estos casos, tenemos una fuente de no-determinismo, pues no sabemos por cuál de estas operaciones se pudiera reconocer la cadena. Este no-determinismo se debe a que en el autómata no-determinista había más de un camino posible que reconocía la cadena, y al convertirlo a determinista, estos caminos se expresan como items contradictorios en el mismo estado. En estos casos, decimos que la gramática no es LR(0). Luego:

> Sea $G=<S,N,T,P>$ una gramática libre del contexto, $G$ es LR(0) si y solo si en el autómata LR(0) asociado no existen conflictos **shift-reduce** ni conflictos **reduce-reduce**.

Notemos que no es posible que tengamos conflictos **shift-shift**, pues solamente hay un caracter $c$ en la cadena $\omega$, y por tanto hay un solo estado hacia donde hacer **shift**.

Desgraciadamente nuestra gramática favorita de expresiones no es LR(0). Sin ir más lejos, en el estado $I_3$ tenemos un conflicto **shift-reduce**. Podemos reducir `T -> int`, o hacer **shift** si viene un terminal `*`. Intuitivamente el problema es que la operación de **reduce** es demasiado permisiva. Donde quiera que encontremos un item **reduce** diremos que es conveniente reducir en esa producción, aunque sabemos que esto no siempre es cierto. De hecho, ya hemos tenido que lidiar con este problema anteriormente, en el algoritmo de parsing LL.

## Parsing SLR(1)

Recordemos que en el parsing LL teníamos la duda de cuando era conveniente aplicar una producción $X \rightarrow \epsilon$, y definimos para ello el conjunto $Follow(X)$, que justamente nos decía donde era conveniente eliminar $X$. Pues en este caso, este conjunto también nos ayudará. Intuitivamente, si tenemos $X \rightarrow \beta.$, solamente tiene sentido reducir si en el $Follow(X)$ aparece el terminal que estamos analizando. ¿Por qué? Pues porque de lo contrario no es posible que lo que nos quede en la pila sea un prefijo viable.

Supongamos que $c$ es el terminal a analizar, $c \notin Follow(X)$ y hacemos la reducción. Entonces en el próximo **shift** tendremos en el tope de la pila la forma oracional $Xc$. Pero esta forma oracional no puede aparecer en niguna derivación extrema derecha, porque de lo contrario $c$ sería parte del $Follow(X)$. Por tanto, si esta forma oracional no es válida, entonces ningún **handle** puede tener este prefijo. Por tanto ya no tenemos un prefijo viable. Incluso si lo siguiente que hacemos tras reducir en $X$ no es **shift** sino otra secuencia de operaciones **reduce**, en cualquier caso si lo que queda una vez hagamos **shift** es un prefijo viable, entonces es porque $c \in Follow(X)$ (intuitivamente, aplicando las producciones en las que redujimos hasta que vuelva a aparecer X, obtendremos la forma oracional $Xc$ nuevamente).

Justamente a esta estrategia denominaremos SLR(1), o *Simple LR look-ahead 1*, dado que usamos un terminal de look-ahead para decidir si vale la pena reducir. Con esta estrategia, podemos comprobar que ya en el estado $I_2$ no hay conflicto, pues $* \notin Follow(T)$, porque cuando viene un terminal $*$ solo tiene sentido hacer **shift**, nunca **reduce**.

De forma análoga llamamos gramáticas SLR(1) a aquellas gramáticas donde, bajo estas reglas, no existen conflictos.

Intentemos entonces reconocer la cadena `int * ( int + int )` con nuestro parser SLR(1). Comenzamos por el estado inicial:

    |int * ( int + int )

Como la pila está vacía, el autómata termina en el estado $I_0$. Dado que viene un terminal `int`, buscamos la transición correspondiente, que es justamente hacia el estado $Goto(I_0,int) = I_3$. Por tanto, como existe esta transición, significa que la acción a realizar es **shift**.

     int|* ( int + int )

Ahora corremos nuevamente el autómata, ya sabemos que caerá en el estado $I_3$. Ahora podemos potencialmente reducir o hacer **shift**. Calculamos el $Follow(T)$

    Follow(T) = { +, ), $ }

Por tanto, como `*` no está incluido en el `Follow(T)`, no hay conflicto, solamente no queda hacer **shift**, en este caso al estado $I_6$.

     int *|( int + int )

Corremos de nuevo y sabemos que acabaremos en $I_6$. Aquí no hay reducciones, así que solo queda hacer **shift** hacia el estado $I_4$:

     int * (|int + int )

En $I_4$ tampoco hay reducciones, así que hacemos **shift** hacia el estado $I_3$:

     int * ( int|+ int )

Ahora interesantemente si tenemos que `+` pertenece al `Follow(X)`, por tanto la reducción aplica. Afortunadamente no hay transiciones en este estado con `+`, por lo que no hay conflicto. Aplicamos entonces la reducción:

     int * ( T|+ int )

Ahora corremos el autómata nuevamente desde el inicio, siguiendo las transiciones (recordemos que mienstras estamos leyendo el contenido de la pila no nos importan los items). Terminamos en el estado $I_2$. En este estado podemos reducir a `E` o hacer **shift**. Pero resulta que `Follow(E)` no contiene al terminal `+`, por lo que la reducción no tiene sentido. Hacemos **shift** entonces:

     int * ( T +|int )

Ahora el autómata termina en el estado $I_5$. En este estado, viniendo `int`, solamente tiene sentido hacer **shift** hacia el estado $I_3$:

     int * ( T + int|)

Ahora estamos en una situación conocida. Pero en este caso, `)` sí está en el `Follow(T)`, y no hay transiciones con este símbolo, luego lo que queda es reducir:

     int * ( T + T|)

Al correr el autómata, en vez de $I_3$ como en la última vez, ahora de $I_5$ pasaríamos directamente a $I_2$, donde nuevamente estamos en territorio conocido. Sin embargo, de nuevo en este caso `)` sí está en el `Follow(E)`, luego podemos reducir (y no hay transiciones con `)`):

     int * ( T + E|)

Ahora volvemos a correr el autómata, pero en vez de el estado $I_2$, terminaríamos en el estado $I_8$, donde la única opción es reducir (una vez comprobamos el `Follow(E)`):

     int * ( E|)

En este caso, al correr el autómata desde el inicio, terminamos en $I_7$, que nos dice **shift**:

     int * ( E )|

Ahora de $I_7$ saltaríamos para $I_{10}$, que nos indica la reducción (dado que `$` sí está en el `Follow(X)`):

     int * T|

En este caso, rápidamente caeremos en el estado $I_9$, que nos indica reducir:

     T|

El autómata con esta pila termina en el estado $I_2$ nuevamente, pero ahora `$` es el terminal a analizar, por lo que hacemos la reducción:

     E|

Y finalmente, en esta entrada el autómata nos deja en el estado $I_1$, que nos permite reducir por completo al símbolo especial `E'` y aceptar la cadena:

     E'|

De esta forma, el algoritmo de parsing SLR(1) ha logrado obtener una derivación extrema derecha de nuestra cadena favorita, pero empleando una gramática mucho más expresiva y "natural" que la gramática LL correspondiente.

De todas formas, muchas gramáticas medianamente complicadas no son SLR(1), por lo que necesitaremos un parser de mayor potencia. Para ello, tendremos que refinar aún más el criterio con el cuál se producen los **reduce**. Pero antes de pasar a eso, veamos algunas mejoras que podemos hacer al parser SLR(1).
