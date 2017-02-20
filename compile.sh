pandoc -o Compilers.pdf \
    Metadata.yaml \
    Prefacio.md \
    Intro.md \
    Sintactico/Intro.md \
    Sintactico/Lexer.md \
    Sintactico/ParsingDesc.md \
    Semantico/Intro.md \
    Semantico/AST.md \

xdg-open Compilers.pdf
