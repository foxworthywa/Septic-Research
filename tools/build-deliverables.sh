#!/usr/bin/env bash
#
# build-deliverables.sh — rebuild the collaborator document package.
#
# Every .docx and .zip in deliverables/ is a SNAPSHOT generated from the
# markdown sources. Editing a source file does not update them. Run this
# after any change to the synthesis, pathway files, outreach articles, or
# poster so the package never drifts out of sync again.
#
#   ./tools/build-deliverables.sh           rebuild everything
#   ./tools/build-deliverables.sh --check   report staleness, change nothing
#   ./tools/build-deliverables.sh --help
#
# Requires: pandoc, zip.  (Debian/Ubuntu: apt-get install pandoc zip)
# Windows:  run under Git Bash or WSL, or use tools/build-deliverables.ps1

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

OUT="deliverables"
ZIP_NAME="ESVA_Septic_Project_Deliverables.zip"

# Source markdown, in the order they should appear to a reader.
# Add new documents here (or they will simply be picked up by the globs).
SOURCES=(
  ECOLOGICAL_EFFECTS_SYNTHESIS.md
  ECOLOGICAL_BIBLIOGRAPHY.md
  ECOLOGICAL_RESEARCH_STRATEGY.md
  poster/POSTER_CONTENT_AND_LAYOUT.md
)
# Everything under these directories is included automatically.
for f in outreach/*.md research/*.md; do
  [ -e "$f" ] && SOURCES+=("$f")
done

# Non-markdown assets copied verbatim into the package.
ASSETS=(poster/ESVA_Symposium_Poster.html)

# ---------------------------------------------------------------- helpers ---
c_red()   { printf '\033[31m%s\033[0m\n' "$*"; }
c_green() { printf '\033[32m%s\033[0m\n' "$*"; }
c_dim()   { printf '\033[2m%s\033[0m\n'  "$*"; }

usage() { sed -n '3,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0; }

MANIFEST="$OUT/.build-manifest"

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d" " -f1
  else shasum -a 256 "$1" | cut -d" " -f1; fi
}

write_manifest() {
  : > "$MANIFEST"
  local f
  for f in "${SOURCES[@]}" "${ASSETS[@]}"; do
    [ -f "$f" ] && printf '%s  %s\n' "$(hash_file "$f")" "$f" >> "$MANIFEST"
  done
}

# ----------------------------------------------------------------- --check ---
# Compares a content hash of every source against the manifest written at the
# last build. Exact — unlike timestamps, which cannot resolve two changes made
# in the same second. Catches the drift that shipped a retracted figure to
# collaborators in June 2026.
check_stale() {
  if [ ! -f "$MANIFEST" ]; then
    c_red "STALE: no build manifest — deliverables/ predates this script."
    echo "Run: ./tools/build-deliverables.sh"
    exit 1
  fi

  local drift=0 f recorded current
  for f in "${SOURCES[@]}" "${ASSETS[@]}"; do
    [ -f "$f" ] || continue
    recorded=$(awk -v p="$f" '$2==p {print $1}' "$MANIFEST")
    current=$(hash_file "$f")
    if [ -z "$recorded" ]; then
      echo "  + $f  (new — not yet in the package)"; drift=1
    elif [ "$recorded" != "$current" ]; then
      echo "  ~ $f  (changed since last build)"; drift=1
    fi
  done
  while read -r _ p; do
    [ -n "${p:-}" ] || continue
    [ -f "$p" ] || { echo "  - $p  (source removed)"; drift=1; }
  done < "$MANIFEST"

  if [ "$drift" -eq 1 ]; then
    echo
    c_red "STALE: deliverables/ does not match the current sources."
    echo "Run: ./tools/build-deliverables.sh"
    exit 1
  fi
  c_green "Deliverables are up to date."
  exit 0
}

# -------------------------------------------------------------------- main ---
case "${1:-}" in
  --help|-h) usage ;;
  --check)   check_stale ;;
  "")        ;;
  *)         c_red "Unknown option: $1"; echo "Try --help"; exit 2 ;;
esac

command -v pandoc >/dev/null || { c_red "pandoc not found. Install it (apt-get install pandoc)."; exit 1; }
command -v zip    >/dev/null || { c_red "zip not found. Install it (apt-get install zip)."; exit 1; }

mkdir -p "$OUT"

# Remove previously generated artifacts so deleted sources don't linger.
rm -f "$OUT"/*.docx "$OUT"/*.html "$OUT/$ZIP_NAME"

built=0
for f in "${SOURCES[@]}"; do
  [ -f "$f" ] || { c_red "  missing source: $f"; continue; }
  target="$OUT/$(basename "$f" .md).docx"
  pandoc "$f" -o "$target" --from=markdown --to=docx
  printf '  %-46s -> %s\n' "$f" "$(basename "$target")"
  built=$((built+1))
done

for a in "${ASSETS[@]}"; do
  [ -f "$a" ] || { c_red "  missing asset: $a"; continue; }
  cp "$a" "$OUT/"
  printf '  %-46s -> %s\n' "$a" "$(basename "$a")"
  built=$((built+1))
done

write_manifest
zip -jq "$OUT/$ZIP_NAME" "$OUT"/*.docx "$OUT"/*.html

echo
c_green "Built $built documents into $OUT/"
c_dim   "Package: $OUT/$ZIP_NAME ($(du -h "$OUT/$ZIP_NAME" | cut -f1))"
echo
c_dim   "Commit the result so the package on the remote matches the sources:"
c_dim   "  git add $OUT && git commit -m 'Rebuild deliverables' && git push"
