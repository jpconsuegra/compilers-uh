# Input
CONTENT_DIR = content
SLIDES_DIR = slides
GRAPHICS_DIR = graphics

# Output
BUILD_DIR = build

CONTENT_MD_DIR = $(BUILD_DIR)/markdown
CONTENT_PDF_DIR = $(BUILD_DIR)/pdf
CONTENT_PDF = $(CONTENT_PDF_DIR)/compilers.pdf

HTML_DIR = $(BUILD_DIR)/html

SLIDES_MD_DIR = $(BUILD_DIR)/slides/markdown
SLIDES_PDF_DIR = $(BUILD_DIR)/slides/pdf

## Output files collections
CONTENT_SOURCE = $(wildcard $(CONTENT_DIR)/*.pmd)
CONTENT_MD = $(patsubst $(CONTENT_DIR)/%.pmd, $(CONTENT_MD_DIR)/%.md, $(CONTENT_SOURCE))
CONTENT_HTML = $(patsubst $(CONTENT_DIR)/%.pmd, $(HTML_DIR)/%.html, $(CONTENT_SOURCE))

GRAPHICS_SOURCE = $(wildcard $(GRAPHICS_DIR)/*.svg)
GRAPHICS_PNG = $(patsubst $(GRAPHICS_DIR)/%.svg, $(GRAPHICS_DIR)/%.png, $(GRAPHICS_SOURCE))

SLIDES_SOURCE = $(wildcard $(SLIDES_DIR)/*.pmd)
SLIDES_MD = $(patsubst $(SLIDES_DIR)/%.pmd, $(SLIDES_MD_DIR)/%.md, $(SLIDES_SOURCE))
SLIDES_PDF = $(patsubst $(SLIDES_DIR)/%.pmd, $(SLIDES_PDF_DIR)/%.pdf, $(SLIDES_SOURCE))

# Main build rules
all: main html slides

## Main content
main: folders $(CONTENT_PDF) clean-images

$(CONTENT_PDF): $(CONTENT_MD) meta/header.tex meta/metadata.yaml images
	pandoc --toc -H meta/header.tex -V lang=es -o $(CONTENT_PDF) meta/metadata.yaml `ls $(CONTENT_MD_DIR)/*.md`

$(CONTENT_MD_DIR)/%.md: $(CONTENT_DIR)/%.pmd
	pweave -f markdown -i markdown -o $@ $<

## Images
images: folders $(GRAPHICS_PNG)
	cp -r $(GRAPHICS_DIR) $(HTML_DIR)/$(GRAPHICS_DIR)

$(GRAPHICS_DIR)/%.png: $(GRAPHICS_DIR)/%.svg
	inkscape -e $@ -f $<

### HTML version
html: folders $(CONTENT_HTML) images

$(HTML_DIR)/%.html: $(CONTENT_MD_DIR)/%.md
	pandoc --toc -s -o $@ $<

## Slides
slides: folders $(SLIDES_PDF)

$(SLIDES_PDF_DIR)/%.pdf: $(SLIDES_MD_DIR)/%.md
	pandoc -t beamer -o $@ $<

$(SLIDES_MD_DIR)/%.md: $(SLIDES_DIR)/%.pmd
	pweave -f markdown -i markdown -o $@ $<


# Utility rules
folders:
	mkdir -p $(CONTENT_MD_DIR)
	mkdir -p $(CONTENT_PDF_DIR)
	mkdir -p $(SLIDES_MD_DIR)
	mkdir -p $(SLIDES_PDF_DIR)
	mkdir -p $(HTML_DIR)

clean: clean-images
	rm -rf $(BUILD_DIR)

clean-images:
	rm -f $(GRAPHICS_PNG)

dependencies:
	pip install pweave
	apt install pandoc
