#!/usr/bin/env bash
# Re-seed the EML loader DLL after a SteamCMD validate/update overwrites it.
# Usage: ./mods/seed-eml.sh [gamefiles_dir]
set -euo pipefail

GAMEFILES="${1:-./gamefiles}"
BACKUP="./mods/eml-backup/dbghelp.dll"

if [ ! -f "$BACKUP" ]; then
  echo "No EML backup found at $BACKUP - place your EML dbghelp.dll there first."
  exit 1
fi

if [ ! -d "$GAMEFILES" ]; then
  echo "Gamefiles dir not found: $GAMEFILES"
  exit 1
fi

# Only restore if missing or differs from backup
if [ ! -f "$GAMEFILES/dbghelp.dll" ] || ! cmp -s "$BACKUP" "$GAMEFILES/dbghelp.dll"; then
  cp "$BACKUP" "$GAMEFILES/dbghelp.dll"
  echo "Restored EML dbghelp.dll into $GAMEFILES"
else
  echo "EML dbghelp.dll already in place."
fi