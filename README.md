# Dobsonian Telescope — Frugal Materials & Substitutes

Build notes on making good Dobsonian telescopes for less money — using less
specialized equipment and more readily available materials — by Mark
VandeWettering, a longtime volunteer instructor at the Chabot Telescope Makers
workshop.

**Read it online:** <https://mvandewettering.com/frugal-telescope-making/>
(a PDF download is linked at the top of the page).

## What's here

The document is written in a single Markdown source and published two ways from
it, so the web page and the PDF never drift apart:

| Path                          | What it is                                          |
| ----------------------------- | --------------------------------------------------- |
| `dobsonian-frugal-build.md`   | The source of truth — edit this.                    |
| `assets/style.css`            | Stylesheet for the web page.                        |
| `assets/download-banner.html` | "Download PDF" banner injected into the HTML only.  |
| `table-widths.lua`            | Pandoc filter that sizes table columns by content.  |
| `Makefile`                    | Builds the PDF and the web site.                    |
| `.github/workflows/pages.yml` | Builds and deploys to GitHub Pages on push to main. |

## Building locally

Requires [pandoc](https://pandoc.org/) and a LaTeX distribution with `pdflatex`
(for the PDF).

```sh
make pdf     # dobsonian-frugal-build.pdf
make site    # site/ — index.html, style.css, and the PDF
make all     # both
make clean   # remove build artifacts
```

The `site/` directory is what gets published: open `site/index.html` in a
browser to preview the web version.

## Publishing

Every push to `main` triggers the GitHub Actions workflow, which runs
`make site` and deploys the result to GitHub Pages. There is nothing to publish
by hand — just edit the Markdown and push.

## License

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/)
(CC BY-NC-SA 4.0). You may share and adapt it for non-commercial purposes, with
attribution, and must distribute your contributions under the same license. See
[`LICENSE`](LICENSE) for the full text.

© Mark VandeWettering
