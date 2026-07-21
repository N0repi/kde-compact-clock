#!/usr/bin/env bash
# Build a store.kde.org / "Install Widget From File…" package (.plasmoid).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

ID="$(python3 -c 'import json; print(json.load(open("metadata.json"))["KPlugin"]["Id"])')"
VER="$(python3 -c 'import json; print(json.load(open("metadata.json"))["KPlugin"]["Version"])')"
OUT="${ID}-${VER}.plasmoid"

rm -f "$OUT"
# Archive root must contain metadata.json + contents/ (not a nested folder).
zip -r "$OUT" metadata.json contents LICENSE README.md CREDITS.md \
  -x '*.plasmoid' -x 'install.sh' -x 'pack.sh' -x '.gitignore' -x '*~'

echo "Wrote $ROOT/$OUT"
echo "Install: right-click panel → Add Widgets → Get New Widgets → Install Widget From File…"
echo "Or: kpackagetool6 --type Plasma/Applet --install $OUT"
