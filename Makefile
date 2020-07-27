SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)
TEX = latexmk -pdf -silent -file-line-error -shell-escape
LAGDA = agda --latex
AGDA_POSTPROCESS_DIR := $(shell dirname $(shell dirname $(shell agda-mode locate)))

main: main.tex latex/path-properties.tex latex/hit-agda-old.tex latex/hit-agda-new.tex latex/hcomp-agda.tex latex/transp-agda.tex
	$(TEX) main.tex

latex/%.tex: %.lagda # postprocess-latex.pl
	$(LAGDA) $^
# perl postprocess-latex.pl latex/hit-agda-new.tex > latex/hit-agda-new.processed
# mv latex/hit-agda-new.processed latex/hit-agda-new.tex

postprocess-latex.pl:
	cp $(AGDA_POSTPROCESS_DIR)/postprocess-latex.pl .

clean:
	rm -f *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.pdf *.cut *.fls
	rm -rf _minted-main

