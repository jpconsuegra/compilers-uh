## Árboles de Sintaxis Abstracta

Recordemos los árboles de derivación, que representan en una estructura computacionalmente cómoda de manipular el conjunto de producciones y el orden en que son aplicadas para producir la oración correspondiente. Este árbol de derivación a menudo se denomina árbol de sintaxis concreta, pues representa exactamente todos los elementos de la sintaxis descritos en la gramática.

Tomemos por ejemplo la siguiente gramática, que genera un lenguaje de expresiones aritméticas simples:

    E = T + E | T
    T = int * T | int | (E)

Y la cadena siguiente:

    2 * (3 + 5)

Esta cadena es generada **de forma única** por el siguiente árbol de derivación:

        E
        |
        T
      / | \
    int *  T
         / | \
        (  E  )
         / | \
        T  +  E
        |     |
       int    T
              |
             int

Este árbol de derivación efectivamente codifica todas las operaciones necesarias a realizar para **evaluar** la expresión (que es en última instancia el problema a resolver). Sin embargo, este árbol representa con demasiado detalle la expresión. Supongamos que queremos diseñar una jerarquía de clases para representar este árbol. Dicha jerarquía tendría varias clases innecesarias, como aquellas que representan a los nodos `(` y `)`. Por otro lado, la estructura del árbol es poco eficiente para representar la expresión, pues hay varios nodos que son redundantes. Por ejemplo, el nodo raíz `E` no nos da ninguna información sobre el tipo concreto de la expresión. De forma general podemos reconocer dos tipos de elementos innecesarios:

* Nodos que representan elementos sintácticos innecesarios (e.j. los paréntesis)
* Nodos que derivan en un solo hijo (e.j. `E -> T`)

Los elementos sintácticos innecesarios, como los paréntesis, se emplean en la gramática para representar la prioridad entre sub-expresiones. Sin embargo, una vez construído el árbol de derivación, la prioridad entre las sub-expresiones queda explícitamente descrita en la propia estructura del árbol. Por otro lado, los nodos que derivan en un solo nodo hijo, tales como `E -> T`, son necesarios desde el punto de vista de la gramática para resolver las ambigüedades, pero una vez que se construye el árbol de derivación, no aportan ninguna información adicional.

Intentemos eliminar estos elementos innecesarios en el árbol de derivación anterior:

        T
      / | \
    int *  E
         / | \
       int + int

Este árbol representa exactamente la misma expresión aritmética, y quedan explícitamente descritos el orden y el tipo de las operaciones. Una vez llegado a este punto, podemos notar que hay otro elemento innecesario en el árbol. Si nos fijamos con atención, veremos que el nodo asociado a un operador (`*` o `+`) siempre estará como hijo de exactamente el mismo tipo de nodo (`T` o `E`) respectivamente. Este hecho se desprende directamente de la gramática, pues el terminal `*` solo se genera por `T` y el terminal `+` solo se genera por `E`. Por tanto, ambos nodos respectivos (`T` y `*` o `E` y `+`) siempre aparecerán juntos, y por tanto es redundante tener ambos.

Pensemos ahora en la jerarquía de clases que representa este árbol, y un posible algoritmo recursivo de evaluación. Una vez en el nodo `T`, evaluados recursivamente las expresiones izquierda y derecha, ¿qué operación es necesario aplicar? Evidentemente, dependerá del nodo que representa la operación. Pero este nodo (`*` o `+`) siempre es un terminal, por lo tanto, nunca será necesario "bajar" recursivamente para descubrir que tipo de operación hay que hacer en un nodo `T` o `E`. Podemos entonces conformarnos con un árbol donde la operación a realizar esté explícita en el nodo padre (`T` o `E`) y no como un hijo adicional:

        *
      /   \
    int    +
         /   \
       int   int

Intuitivamente, el árbol anterior es capaz de representar con todo el detalle necesario la semántica de la expresión a evaluar, y no tiene ningún elemento innecesario.

A este tipo de estructura se le denomina **árbol de sintaxis abstracta (AST)**, precisamente porque representa solamente la porción de sintaxis necesaria para evaluar la expresión o programa reconocido. En el AST solamente existen nodos por cada tipo de elemento semántico diferente.