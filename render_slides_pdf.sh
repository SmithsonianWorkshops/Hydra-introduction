#!/usr/bin/env bash
# Render hydra_intro_slides.md to revealjs HTML with Quarto, then export the
# slides to hydra_intro_slides.pdf with decktape.
#
# Requirements: quarto and decktape on PATH. Locally these live in the
# "quarto" mamba env:
#   mamba create -n quarto -c conda-forge quarto nodejs
#   mamba run -n quarto npm install -g decktape
# then run:  mamba run -n quarto ./render_slides_pdf.sh
set -euo pipefail

cd "$(dirname "$0")"

# 1. Build the revealjs slides (a single self-contained hydra_intro_slides.html)
quarto render hydra_intro_slides.md --to revealjs

# 2. Export each slide to a PDF page (reveal.js default slide size is 1050x700).
#    --no-sandbox is needed on GitHub's Ubuntu runners.
decktape reveal --size 1050x700 --chrome-arg=--no-sandbox \
  hydra_intro_slides.html hydra_intro_slides.pdf
