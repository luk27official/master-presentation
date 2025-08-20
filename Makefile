TEXDIR := latex
OUTDIR := $(TEXDIR)/build

LATEXMK := latexmk
PDFLATEX := pdflatex

SOURCES := presentation.tex
PDFS := $(patsubst %.tex,$(OUTDIR)/%.pdf,$(SOURCES))

.PHONY: all clean distclean watch open help

all: $(PDFS)

$(OUTDIR)/%.pdf: $(TEXDIR)/%.tex | $(OUTDIR)
	@echo "Building $< -> $@"
ifneq ($(LATEXMK),)
	@echo "Using latexmk to build $(notdir $<)"
	@cd $(TEXDIR) && $(LATEXMK) -pdf -interaction=nonstopmode -outdir=$(CURDIR)/$(OUTDIR) $(notdir $<)
else
	@echo "latexmk not found; using pdflatex (3 runs) to build $(notdir $<)"
	@cd $(TEXDIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=$(CURDIR)/$(OUTDIR) $(notdir $<)
	@cd $(TEXDIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=$(CURDIR)/$(OUTDIR) $(notdir $<)
	@cd $(TEXDIR) && $(PDFLATEX) -interaction=nonstopmode -output-directory=$(CURDIR)/$(OUTDIR) $(notdir $<)
endif

$(OUTDIR):
	@mkdir -p $(OUTDIR)

clean:
	@rm -f $(OUTDIR)/*.aux $(OUTDIR)/*.log $(OUTDIR)/*.toc $(OUTDIR)/*.out $(OUTDIR)/*.nav $(OUTDIR)/*.snm $(OUTDIR)/*.fdb_latexmk $(OUTDIR)/*.fls $(OUTDIR)/*.synctex.gz

distclean: clean
	@rm -f $(OUTDIR)/*.pdf
	@rmdir --ignore-fail-on-non-empty $(OUTDIR) 2>/dev/null || true


watch:
ifneq ($(LATEXMK),)
	@cd $(TEXDIR) && $(LATEXMK) -pvc -pdf -interaction=nonstopmode -outdir=$(CURDIR)/$(OUTDIR) $(SOURCES)
else
	@echo "watch requires latexmk (not installed)"
endif

open: all
	@open $(OUTDIR)/presentation.pdf || true

help:
	@echo "Makefile targets:"
	@echo "  make         Build all presentations ($(SOURCES))"
	@echo "  make clean   Remove common auxiliary files in $(OUTDIR)"
	@echo "  make distclean  Remove aux files and PDFs in $(OUTDIR)"
	@echo "  make watch   Live-recompile when files change (requires latexmk)"
	@echo "  make open    Build and open the presentation PDF"
