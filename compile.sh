for file in `ls Slides/*.md` ; do pandoc -t beamer -o $file.pdf $file ; done

pandoc --toc -H Meta/Header.tex -V lang=es -o Compilers.pdf \
    Meta/Metadata.yaml \
    Pre/Prefacio.md \
    Pre/Intro.md \
    Sintactico/Intro.md \
    Sintactico/Lexer.md \
    Sintactico/ParsingDesc.md \
    Sintactico/ParsingAsc.md \
    Semantico/AST.md;
