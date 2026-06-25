.PHONY: pdf clean

SRC = dobsonian-frugal-build.md
OUT = dobsonian-frugal-build.pdf

pdf: $(OUT)

$(OUT): $(SRC)
	cat "$<" | sed \
		-e 's/≤/<=/g' \
		-e 's/≥/>=/g' \
		-e 's/″/"/g' \
		-e 's/—/ -- /g' \
		-e 's/★/*/g' \
		-e 's/×/x/g' \
		-e 's/′/'\''/g' \
	| pandoc \
		--pdf-engine=pdflatex \
		--lua-filter=table-widths.lua \
		--metadata title="Dobsonian Telescope -- Frugal Build Notes" \
		--metadata date="$$(date '+%B %Y')" \
		--toc \
		--toc-depth=2 \
		--number-sections \
		-V geometry:margin=1in \
		-V fontsize=10pt \
		-V colorlinks=true \
		-o "$@"

clean:
	rm -f $(OUT)
