SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)
TEX = latexmk -pdf -silent -file-line-error -shell-escape
LAGDA = agda --latex

main: main.tex latex/path-properties.tex latex/hit-agda-old.tex latex/hit-agda-new.tex
	$(TEX) main.tex

latex/hit-agda-old.tex: hit-agda-old.lagda
	$(LAGDA) hit-agda-old.lagda

latex/hit-agda-new.tex: hit-agda-new.lagda
	$(LAGDA) hit-agda-new.lagda

latex/path-properties.tex: path-properties.lagda
	$(LAGDA) path-properties.lagda

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix/Linux
  RM = rm -f
endif

clean:
	$(RM) *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.pdf *.cut *.fls
	rm -rf _minted-main
