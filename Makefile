SRC = $(wildcard *.tex)

PDFS = $(SRC:.tex=.pdf)
TEX = latexmk -pdf -silent -file-line-error

all: clean main
main: main.tex
	$(TEX) main.tex

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix/Linux
  RM = rm -f
endif

clean:
	$(RM) *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.pdf *.cut *.fls
