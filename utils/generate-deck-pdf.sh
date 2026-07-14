#!/usr/bin/env bash
# Regenerate the presentation PDF from utils/deck-print.html.
#
# Prints the seven slide pages from docs/slides/ (one 1280x720 page
# each) with headless Chrome and writes the result to
# docs/assets/5p-framework-deck.pdf.
#
# Usage: ./utils/generate-deck-pdf.sh
# Requires: Google Chrome. Needs network access for Google Fonts.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DECK="$REPO_ROOT/utils/deck-print.html"
OUT="$REPO_ROOT/docs/assets/5p-framework-deck.pdf"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [[ ! -x "$CHROME" ]]; then
  CHROME="$(command -v google-chrome || command -v chromium || true)"
fi
if [[ -z "${CHROME:-}" || ! -x "$CHROME" ]]; then
  echo "error: Google Chrome / Chromium not found" >&2
  exit 1
fi

"$CHROME" --headless --disable-gpu --hide-scrollbars \
  --virtual-time-budget=10000 \
  --no-pdf-header-footer \
  --print-to-pdf="$OUT" \
  "file://$DECK" 2>/dev/null

echo "Wrote $OUT"
file "$OUT"
