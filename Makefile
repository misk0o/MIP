# Compiler
LATEX = pdflatex
BIBTEX = bibtex

# Main article file
ARTICLE = clanok
# Project description file
ZAMERANIE = zameranie_tima
# Presentation file
PREZENTACIA = prezentacia

# Bibliography file
BIB = refs_tima.bib

# Output directory
OUT_DIR = build

.PHONY: all article zameranie prezentacia clean cleanall view view-zameranie view-prezentacia help

# Default target - compile all documents
all: article zameranie prezentacia

# Compile main article with bibliography
article: $(ARTICLE).pdf

$(ARTICLE).pdf: $(ARTICLE).tex $(BIB) | $(OUT_DIR)
	@echo "==> Compiling $(ARTICLE).tex (first pass)..."
	$(LATEX) -output-directory=$(OUT_DIR) $(ARTICLE).tex
	@echo "==> Running BibTeX..."
	@cp $(BIB) $(OUT_DIR)/
	$(BIBTEX) $(OUT_DIR)/$(ARTICLE)
	@echo "==> Compiling $(ARTICLE).tex (second pass)..."
	$(LATEX) -output-directory=$(OUT_DIR) $(ARTICLE).tex
	@echo "==> Compiling $(ARTICLE).tex (third pass)..."
	$(LATEX) -output-directory=$(OUT_DIR) $(ARTICLE).tex
	@cp $(OUT_DIR)/$(ARTICLE).pdf .
	@echo "==> Done! Output: $(ARTICLE).pdf"

# Compile project description
zameranie: $(ZAMERANIE).pdf

$(ZAMERANIE).pdf: $(ZAMERANIE).tex | $(OUT_DIR)
	@echo "==> Compiling $(ZAMERANIE).tex..."
	$(LATEX) -output-directory=$(OUT_DIR) $(ZAMERANIE).tex
	@cp $(OUT_DIR)/$(ZAMERANIE).pdf .
	@echo "==> Done! Output: $(ZAMERANIE).pdf"

# Compile presentation
prezentacia: $(PREZENTACIA).pdf

$(PREZENTACIA).pdf: $(PREZENTACIA).tex | $(OUT_DIR)
	@echo "==> Compiling $(PREZENTACIA).tex (first pass)..."
	$(LATEX) -output-directory=$(OUT_DIR) $(PREZENTACIA).tex
	@echo "==> Compiling $(PREZENTACIA).tex (second pass)..."
	$(LATEX) -output-directory=$(OUT_DIR) $(PREZENTACIA).tex
	@cp $(OUT_DIR)/$(PREZENTACIA).pdf .
	@echo "==> Done! Output: $(PREZENTACIA).pdf"

# Create build directory if it doesn't exist
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Clean auxiliary files but keep PDFs
clean:
	@echo "==> Cleaning auxiliary files..."
	@rm -f $(OUT_DIR)/*.aux $(OUT_DIR)/*.log $(OUT_DIR)/*.bbl $(OUT_DIR)/*.blg
	@rm -f $(OUT_DIR)/*.toc $(OUT_DIR)/*.out $(OUT_DIR)/*.lof $(OUT_DIR)/*.lot
	@rm -f $(OUT_DIR)/*.nav $(OUT_DIR)/*.snm $(OUT_DIR)/*.vrb
	@rm -f *.aux *.log *.bbl *.blg *.toc *.out *.lof *.lot *.nav *.snm *.vrb
	@echo "==> Cleaned!"

# Clean everything including PDFs
cleanall: clean
	@echo "==> Removing all generated files..."
	@rm -rf $(OUT_DIR)
	@rm -f $(ARTICLE).pdf $(ZAMERANIE).pdf $(PREZENTACIA).pdf
	@echo "==> All clean!"

# Open the article PDF (macOS)
view: $(ARTICLE).pdf
	@open $(ARTICLE).pdf

# Open the project description PDF (macOS)
view-zameranie: $(ZAMERANIE).pdf
	@open $(ZAMERANIE).pdf

# Open the presentation PDF (macOS)
view-prezentacia: $(PREZENTACIA).pdf
	@open $(PREZENTACIA).pdf

# Help target
help:
	@echo "Available targets:"
	@echo "  make all              - Compile all documents (article, description, presentation)"
	@echo "  make article          - Compile main article (clanok.tex)"
	@echo "  make zameranie        - Compile project description (zameranie_tima.tex)"
	@echo "  make prezentacia      - Compile presentation (prezentacia.tex)"
	@echo "  make clean            - Remove auxiliary files"
	@echo "  make cleanall         - Remove all generated files including PDFs"
	@echo "  make view             - Open the article PDF (macOS)"
	@echo "  make view-zameranie   - Open the project description PDF (macOS)"
	@echo "  make view-prezentacia - Open the presentation PDF (macOS)"
	@echo "  make help             - Show this help message"

# Ensure build directory exists for all targets
$(ARTICLE).pdf $(ZAMERANIE).pdf $(PREZENTACIA).pdf: | $(OUT_DIR)
