#!/usr/bin/env bash
# Regenerate the social-preview (Open Graph) image from utils/og-card.html.
#
# Renders the card at 1200x630 with headless Chrome and writes it to
# docs/assets/5p-framework.png (the URL referenced by the og:image /
# twitter:image tags on every page).
#
# Usage: ./utils/generate-og-image.sh
# Requires: Google Chrome. Needs network access for Google Fonts.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CARD="$REPO_ROOT/utils/og-card.html"
OUT="$REPO_ROOT/docs/assets/5p-framework.png"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [[ ! -x "$CHROME" ]]; then
  CHROME="$(command -v google-chrome || command -v chromium || true)"
fi
if [[ -z "${CHROME:-}" || ! -x "$CHROME" ]]; then
  echo "error: Google Chrome / Chromium not found" >&2
  exit 1
fi

"$CHROME" --headless --disable-gpu --hide-scrollbars \
  --window-size=1200,630 \
  --virtual-time-budget=8000 \
  --screenshot="$OUT" \
  "file://$CARD" 2>/dev/null

echo "Wrote $OUT"
file "$OUT"
