#!/usr/bin/env bash
# Install (or uninstall) hx-update into ~/.local/bin.
set -Eeuo pipefail

DEST="${HX_UPDATE_DEST:-$HOME/.local/bin}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/hx-update"

case "${1:-}" in
    --uninstall)
        rm -f -- "$DEST/hx-update"
        echo "Removed $DEST/hx-update"
        echo "Installed Helix versions were left in ~/.local/opt (remove them manually if you want)."
        exit 0
        ;;
    "") ;;
    *)
        echo "Usage: ./install.sh [--uninstall]" >&2
        exit 1
        ;;
esac

[[ -f "$SRC" ]] || { echo "ERROR: hx-update not found next to install.sh" >&2; exit 1; }

install -Dm755 "$SRC" "$DEST/hx-update"
echo "Installed: $DEST/hx-update"

case ":$PATH:" in
    *":$DEST:"*) ;;
    *) echo "NOTE: $DEST is not in your PATH. Add this to ~/.bashrc:"
       echo "  export PATH=\"$DEST:\$PATH\"" ;;
esac

echo "Run: hx-update"
