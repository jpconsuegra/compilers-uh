CONTENT_DIR = content
SLIDES_DIR = slides

BUILD_DIR = build

CONTENT_MD_DIR = $(BUILD_DIR)/markdown
CONTENT_PDF_DIR = $(BUILD_DIR)/pdf
CONTENT_PDF = $(CONTENT_PDF_DIR)/compilers.pdf

SLIDES_MD_DIR = $(BUILD_DIR)/slides/markdown
SLIDES_MD_DIR = $(BUILD_DIR)/slides/pdf

CONTENT_SOURCE = $(wildcard $(CONTENT_DIR)/*.pmd)
CONTENT_MD = $(patsubst $(CONTENT_DIR)/%.pmd, $(CONTENT_MD_DIR)/%.md, $(CONTENT_SOURCE))

all: $(CONTENT_PDF)

$(CONTENT_PDF): folders $(CONTENT_MD) meta/header.tex meta/metadata.yaml
	pandoc --toc -H meta/header.tex -V lang=es -o $(CONTENT_PDF) meta/metadata.yaml `ls $(CONTENT_MD_DIR)/*.md`

$(CONTENT_MD_DIR)/%.md: $(CONTENT_DIR)/%.pmd
	pweave -f markdown -i markdown -o $@ $<

folders:
	mkdir -p $(CONTENT_MD_DIR)
	mkdir -p $(CONTENT_PDF_DIR)
	mkdir -p $(SLIDES_MD_DIR)

# SOURCES = $(wildcard $(MD_DIR)/*.md)
# TEX_FILES = $(patsubst $(MD_DIR)/%.md, $(TEX_DIR)/%.tex, $(SOURCES))
# PDF_FILES = $(patsubst $(MD_DIR)/%.md, $(PDF_DIR)/%.pdf, $(SOURCES))

# pdf: folders $(PDF_FILES)

# tex: folders $(TEX_FILES)

# folders:
# 	mkdir -p $(TEX_DIR) $(PDF_DIR)

# $(TEX_DIR)/%.tex: $(MD_DIR)/%.md
# 	pandoc -t latex -o $@ $<

# $(PDF_DIR)/%.pdf: $(TEX_DIR)/%.tex
# 	pandoc -t beamer -o $@ $<

clean:
	rm -rf $(BUILD_DIR)

# compilers.pdf: content/*.md meta/header.tex meta/metadata.yaml
# 	pandoc --toc -H meta/header.tex -V lang=es -o Compilers.pdf meta/metadata.yaml `ls content/*.md`
