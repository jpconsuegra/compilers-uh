.PHONY: clean

all: book slides notebooks web

book: compilers.pdf

markdown: content/*.pmd
	pweave -f markdown -o markdown/1-intro.md -i markdown content/1-intro.pmd
	pweave -f markdown -o markdown/2-lexer.md -i markdown content/2-lexer.pmd
	pweave -f markdown -o markdown/3-parsing-desc.md -i markdown content/3-parsing-desc.pmd
	pweave -f markdown -o markdown/4-parsing-asc.md -i markdown content/4-parsing-asc.pmd
	pweave -f markdown -o markdown/5-ast.md -i markdown content/5-ast.pmd
	pweave -f markdown -o markdown/6-attr-gram.md -i markdown content/6-attr-gram.pmd
	pweave -f markdown -o markdown/7-type-check.md -i markdown content/7-type-check.pmd
	pweave -f markdown -o markdown/8-code-gen.md -i markdown content/8-code-gen.pmd

web: docs/index.html images

images:
	inkscape -e graphics/mountain.png -f graphics/mountain.svg

slides:
	echo $*

notebooks:
	python make_notebooks.py

clean:
	git clean -fdX

compilers.pdf: markdown meta/header.tex meta/metadata.yaml images
	(cd markdown && pandoc --toc -H ../meta/header.tex -V lang=es -o ../compilers.pdf ../meta/metadata.yaml *.md)

instructors.pdf: instructors/*.md meta/header.tex meta/metadata-instructors.yaml
	pandoc -H meta/header.tex -V lang=es -o instructors.pdf meta/metadata-instructors.yaml instructors/*.md

docs/index.html: markdown markdown/*.md
	touch docs/index.html
	pandoc --toc -s -o docs/1-intro.html markdown/1-intro.md
	pandoc --toc -s -o docs/2-lexer.html markdown/2-lexer.md
	pandoc --toc -s -o docs/3-parsing-desc.html markdown/3-parsing-desc.md
	pandoc --toc -s -o docs/4-parsing-asc.html markdown/4-parsing-asc.md
	pandoc --toc -s -o docs/5-ast.html markdown/5-ast.md
	pandoc --toc -s -o docs/6-attr-gram.html markdown/6-attr-gram.md
	pandoc --toc -s -o docs/7-type-check.html markdown/7-type-check.md
	pandoc --toc -s -o docs/8-code-gen.html markdown/8-code-gen.md

slides/%.pdf: slides/$*.md
	pandoc -t beamer -o slides/$*.pdf slides/$*.md
