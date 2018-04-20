.PHONY: all book slides notebooks clean

all: book slides notebooks

book: compilers.pdf

slides:

notebooks:
	python make_notebooks.py

clean:
	git clean -fx

compilers.pdf: content/*.md meta/header.tex meta/metadata.yaml
	pandoc -h --toc meta/header.tex -v lang=es -o compilers.pdf meta/metadata.yaml content/*.md

instructors.pdf: instructors/*.md meta/header.tex meta/metadata-instructors.yaml
	pandoc -h meta/header.tex -v lang=es -o instructors.pdf meta/metadata-instructors.yaml instructors/*.md

slides/%o.pdf: meta/%o.pdf
	pandoc -t beamer -o meta/%o.pdf meta/%o.md
