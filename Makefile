Compilers.pdf: Content/*.md Meta/Header.tex Meta/Metadata.yaml
	pandoc --toc -H Meta/Header.tex --filter ./Filters/trees.py -V lang=es -o Compilers.pdf Meta/Metadata.yaml `ls Content/*.md`