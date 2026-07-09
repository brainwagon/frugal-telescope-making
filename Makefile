.PHONY: all pdf html site clean

SRC   = dobsonian-frugal-build.md
PDF   = dobsonian-frugal-build.pdf
CLEAN = .clean.md
SITE  = site

TITLE = Dobsonian Telescope -- Frugal Build Notes

all: pdf html

pdf: $(PDF)

# The sed pass rewrites a handful of Unicode glyphs that pdflatex chokes on.
# HTML needs no such massaging, so only the PDF path consumes the cleaned copy.
$(CLEAN): $(SRC)
	cat "$<" | sed \
		-e 's/≤/<=/g' \
		-e 's/≥/>=/g' \
		-e 's/″/"/g' \
		-e 's/—/ -- /g' \
		-e 's/★/*/g' \
		-e 's/×/x/g' \
		-e "s/′/'/g" \
		> "$@"

$(PDF): $(CLEAN) table-widths.lua
	pandoc "$(CLEAN)" \
		--pdf-engine=pdflatex \
		--lua-filter=table-widths.lua \
		--metadata title="$(TITLE)" \
		--metadata date="$$(date '+%B %Y')" \
		--toc \
		--toc-depth=2 \
		-V geometry:margin=1in \
		-V fontsize=10pt \
		-V colorlinks=true \
		-o "$@"

# Build the browsable web page (and bundle the PDF as a download) into $(SITE)/.
site: html
html: $(SITE)/index.html $(SITE)/$(PDF)

$(SITE)/index.html: $(SRC) table-widths.lua assets/style.css assets/download-banner.html
	mkdir -p $(SITE)
	pandoc "$(SRC)" \
		--standalone \
		--lua-filter=table-widths.lua \
		--metadata title="$(TITLE)" \
		--metadata date="$$(date '+%B %Y')" \
		--toc \
		--toc-depth=2 \
		--section-divs \
		--css=style.css \
		--include-before-body=assets/download-banner.html \
		-o "$@"
	cp assets/style.css $(SITE)/style.css

$(SITE)/$(PDF): $(PDF)
	mkdir -p $(SITE)
	cp "$(PDF)" "$@"

clean:
	rm -f $(PDF) $(CLEAN)
	rm -rf $(SITE)
