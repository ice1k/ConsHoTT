SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)
TEX = latexmk -pdf -silent -file-line-error -shell-escape
LAGDA = agda --latex
AGDA_POSTPROCESS_DIR := $(shell dirname $(shell dirname $(shell agda-mode locate)))

main: main.tex latex/path-properties.tex latex/hit-agda-old.tex latex/hit-agda-new.tex
	$(TEX) main.tex

latex/hit-agda-old.tex: hit-agda-old.lagda
	$(LAGDA) hit-agda-old.lagda

latex/hit-agda-new.tex: hit-agda-new.lagda # postprocess-latex.pl
	$(LAGDA) hit-agda-new.lagda
# perl postprocess-latex.pl latex/hit-agda-new.tex > latex/hit-agda-new.processed
# mv latex/hit-agda-new.processed latex/hit-agda-new.tex

latex/path-properties.tex: path-properties.lagda
	$(LAGDA) path-properties.lagda

postprocess-latex.pl:
	cp $(AGDA_POSTPROCESS_DIR)/postprocess-latex.pl .

clean:
	rm -f *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.pdf *.cut *.fls
	rm -rf _minted-main

