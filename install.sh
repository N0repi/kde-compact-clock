#!/usr/bin/env bash
# Install or upgrade this plasmoid for the current user.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [[ ! -f metadata.json ]]; then
  echo "metadata.json not found in $ROOT" >&2
  exit 1
fi

ID="$(python3 -c 'import json; print(json.load(open("metadata.json"))["KPlugin"]["Id"])')"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/plasma/plasmoids/${ID}"

mkdir -p "$(dirname "$DEST")"

if command -v kpackagetool6 >/dev/null 2>&1; then
  if [[ -e "$DEST" ]]; then
    kpackagetool6 --type Plasma/Applet --upgrade "$ROOT"
  else
    kpackagetool6 --type Plasma/Applet --install "$ROOT"
  fi
else
  # Fallback: symlink/copy so the directory name matches KPlugin.Id
  ln -sfn "$ROOT" "$DEST"
  echo "kpackagetool6 not found; symlinked to $DEST"
fi

echo "Installed as ${ID}"
echo "Restart Plasma to reload QML if the widget is already on a panel:"
echo "  plasmashell --replace &"
echo "Then add \"Compact Clock\" from the widget explorer if needed."
