pandoc --toc -H Meta/Header.tex -V lang=es -o Compilers.pdf \
    Meta/Metadata.yaml \
    Pre/Prefacio.md \
    Pre/Intro.md \
    Sintactico/Intro.md \
    Sintactico/Lexer.md \
    Sintactico/ParsingDesc.md \
    Sintactico/ParsingAsc.md \
    Semantico/Intro.md \
    Semantico/AST.md \
    && \
xdg-open Compilers.pdf
