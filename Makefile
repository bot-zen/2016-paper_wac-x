PDF_TARGETS = paper.pdf
TEX_SRCS := $(patsubst %pdf,%tex,$(PDF_TARGETS))
TEX_XTRA_SRCS := $(wildcard bit-*.tex)
BIB_SRCS := $(wildcard *.bib)
OTH_SRCS := $(wildcard *.tex) $(wildcard *.sty) $(wildcard *.bst) $(wildcard img/*)

LATEXMK_PDFLATEX_CMD = pdflatex -file-line-error -interaction=errorstopmode -synctex=1
LATEXMK_CE_OPTS = '$$cleanup_includes_cusdep_generated=1;'

.PHONY: draft final dynbit-draft dynbit-final clean cleanall

# set default
.DEFAULT_GOAL := final

draft: dynbit-draft $(PDF_TARGETS)

final: dynbit-final $(PDF_TARGETS)

dynbit-draft:
	$(shell grep -E '^%\aclfinalcopy' bit-aclfinalcopy.tex || echo '%\\aclfinalcopy' > bit-aclfinalcopy.tex)
# $(shell grep -qE 'Affiliation' bit-author.tex || cat bit-author_draft.tmpl > bit-author.tex)

dynbit-final:
	$(shell grep -E '^\aclfinalcopy'  bit-aclfinalcopy.tex || echo '\\aclfinalcopy'  > bit-aclfinalcopy.tex)
# $(shell grep -qE 'Affiliation' bit-author.tex && cat bit-author_final.tmpl > bit-author.tex)

$(PDF_TARGETS): %.pdf:%.tex $(TEX_SRCS) $(BIB_SRCS) $(TEX_XTRA_SRCS) $(OTH_SRCS)
	latexmk -pdf -pdflatex="$(LATEXMK_PDFLATEX_CMD)" -use-make -bibtex $<

clean:
	latexmk -c -bibtex -e $(LATEXMK_CE_OPTS)
	rm $(patsubst %pdf,%synctex.gz,$(PDF_TARGETS)) || true

cleanall:
	latexmk -C -bibtex -e $(LATEXMK_CE_OPTS)
