# File names
BASE	= report
SOURCES = sources

# How to view output files
VIEWER  = zathura

.SUFFIXES:
.SUFFIXES:.ps .pdf .dvi .tex .toc .aux .bbl .bib

.PHONY: default all dvi ps pdf view clean powerclean

# What should 'make' run by default ?
default: pdf

# build everything
all: ps pdf view-pdf

# The output files
dvi: ${BASE}.dvi
ps:  ${BASE}.ps
pdf: ${BASE}.pdf

# Default view
view: view-pdf

# --- PDF ---------------------------------------
${BASE}.pdf: ${BASE}.dvi
	@echo "PDF  $<"
	@dvipdf -q $<

# --- PS ----------------------------------------
${BASE}.ps: ${BASE}.dvi
	@echo "PS   $<"
	@dvips -q $<

# --- DVI ---------------------------------------
${BASE}.dvi: ${BASE}.tex ${BASE}.toc 
	@echo "TEX  ${BASE}.tex"
	@latex ${BASE}.tex >/dev/null

# --- TOC ---------------------------------------
${BASE}.toc: ${BASE}.tex ${BASE}.aux ${BASE}.bbl
	@echo "TOC  ${BASE}.tex"
	@latex -draftmode ${BASE}.tex >/dev/null

# --- AUX ---------------------------------------
${BASE}.aux: ${BASE}.tex 
	@echo "AUX  ${BASE}.tex"
	@latex -draftmode ${BASE}.tex >/dev/null

# --- BBL ---------------------------------------
${BASE}.bbl: ${BASE}.aux ${SOURCES}.bib
	@echo "BIB  ${BASE}.tex"
	@bibtex ${BASE}.aux >/dev/null

# --- VIEW --------------------------------------
view-%: ${BASE}.%
	${VIEWER} $< &

clean:
	@rm -vf *.aux *.log *.dvi *.lof *.lot *.toc *.bbl *.blg *.out

powerclean: clean
	@rm -vf *.pdf *.ps

