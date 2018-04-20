.PHONY: all book slides notebooks clean

all: book slides notebooks

book: compilers.pdf

slides:

notebooks:
	python make_notebooks.py

clean:
	git clean -fdX

compilers.pdf: content/*.md meta/header.tex meta/metadata.yaml
	pandoc --toc -H meta/header.tex -V lang=es -o compilers.pdf meta/metadata.yaml content/*.md

instructors.pdf: instructors/*.md meta/header.tex meta/metadata-instructors.yaml
	pandoc -H meta/header.tex -V lang=es -o instructors.pdf meta/metadata-instructors.yaml instructors/*.md

slides/%o.pdf: meta/%o.pdf
	pandoc -t beamer -o meta/%o.pdf meta/%o.md
