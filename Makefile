SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)
TEX = latexmk -pdf -silent -file-line-error
LAGDA = agda --latex

main: main.tex latex/path-properties.tex
	$(TEX) main.tex

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
