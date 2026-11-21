#!/usr/bin/env bash
# Install this repo's skills so they are available in DeepSeek Harness.
#
#   ./install.sh            symlink the skills into $DSH_HOME/skills (default ~/.dsh/skills)
#   ./install.sh copy       copy them instead
#   ./install.sh check      validate the skills and report install state
#   ./install.sh uninstall  remove only what this script installed
#
# Safe to rerun. Refuses to touch a skill directory it does not own.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$here/skills"
dest="${DSH_HOME:-$HOME/.dsh}/skills"
mode="${1:-install}"

names=()
for dir in "$src"/*/; do
  [ -f "${dir}SKILL.md" ] && names+=("$(basename "$dir")")
done
[ "${#names[@]}" -gt 0 ] || { echo "error: no skills found under $src" >&2; exit 1; }

frontmatter_name() {
  awk 'BEGIN { fence = 0 }
       /^---$/ { fence++; next }
       fence == 1 && /^name:/ { sub(/^name:[[:space:]]*/, ""); print; exit }' "$1"
}

frontmatter_description() {
  awk 'BEGIN { fence = 0 }
       /^---$/ { fence++; next }
       fence == 1 && /^description:/ { sub(/^description:[[:space:]]*/, ""); print; exit }' "$1"
}

validate() {
  local name="$1" file="$src/$1/SKILL.md"
  [ -f "$file" ] || { echo "FAIL $name: missing $file"; return 1; }
  local got desc
  got="$(frontmatter_name "$file")"
  desc="$(frontmatter_description "$file")"
  [ "$got" = "$name" ] || { echo "FAIL $name: frontmatter name is '$got'"; return 1; }
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "FAIL $name: not kebab-case"; return 1; }
  [ -n "$desc" ] || { echo "FAIL $name: missing description"; return 1; }
  grep -q '^disable-model-invocation:[[:space:]]*true' "$file" || {
    echo "FAIL $name: must set disable-model-invocation: true"; return 1
  }
  echo "ok   $name"
}

installed_state() {
  local name="$1" target="$dest/$1"
  if [ -L "$target" ]; then
    if [ "$(readlink -f "$target")" = "$(readlink -f "$src/$name")" ]; then
      echo "ok   $name symlinked -> $src/$name"
    else
      echo "warn $name symlinked elsewhere -> $(readlink "$target")"
    fi
  elif [ -f "$target/.skill-install-copy" ]; then
    echo "ok   $name copied"
  elif [ -d "$target" ]; then
    echo "warn $name exists but was not installed by this repo"
  else
    echo "miss $name not installed"
  fi
}

case "$mode" in
  check)
    failed=0
    echo "skills:"
    for name in "${names[@]}"; do validate "$name" || failed=1; done
    echo "install ($dest):"
    for name in "${names[@]}"; do
      state="$(installed_state "$name")"
      echo "$state"
      case "$state" in miss*|warn*) failed=1 ;; esac
    done
    exit "$failed"
    ;;
  install|copy)
    echo "validating..."
    for name in "${names[@]}"; do validate "$name" >/dev/null; done
    mkdir -p "$dest"
    for name in "${names[@]}"; do
      target="$dest/$name"
      if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$src/$name")" ]; then
        continue
      fi
      if [ -f "$target/.skill-install-copy" ]; then
        continue
      fi
      if [ -e "$target" ] || [ -L "$target" ]; then
        echo "error: $target exists and was not installed by this repo; move it away first" >&2
        exit 1
      fi
    done
    for name in "${names[@]}"; do
      target="$dest/$name"
      if [ -L "$target" ] || [ -e "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$src/$name")" ]; then
          echo "ok   $name already symlinked"
          continue
        fi
        rm -rf "$target"
      fi
      if [ "$mode" = install ]; then
        ln -s "$src/$name" "$target"
        echo "link $name -> $src/$name"
      else
        cp -R "$src/$name" "$target"
        printf 'copied from %s on %s\n' "$src/$name" "$(date +%F)" > "$target/.skill-install-copy"
        echo "copy $name"
      fi
    done
    echo
    echo "Installed into $dest. DSH watches that folder and discovers skills from there,"
    echo "so the skill is available in a new session. Run ./install.sh check to verify."
    ;;
  uninstall)
    for name in "${names[@]}"; do
      target="$dest/$name"
      if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$src/$name")" ]; then
        rm "$target" && echo "removed $name symlink"
      elif [ -f "$target/.skill-install-copy" ]; then
        rm -rf "$target" && echo "removed $name copy"
      elif [ -e "$target" ]; then
        echo "skip $name: $target was not installed by this repo"
      fi
    done
    ;;
  help|-h|--help)
    sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
    ;;
  *)
    echo "error: unknown mode '$mode' (install, copy, check, uninstall)" >&2
    exit 2
    ;;
esac
