#!/usr/bin/env bash
set -euo pipefail

mode="copy"
target_root=""
skill=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      mode="${2:-}"
      shift 2
      ;;
    --target-root)
      target_root="${2:-}"
      shift 2
      ;;
    --skill)
      skill="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ "$mode" != "copy" && "$mode" != "link" ]]; then
  echo "Invalid mode: $mode" >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$target_root" ]]; then
  if [[ -n "${CODEX_HOME:-}" ]]; then
    target_root="${CODEX_HOME}/skills"
  else
    target_root="${HOME}/.codex/skills"
  fi
fi

mkdir -p "$target_root"
resolved_target_root="$(cd "$target_root" && pwd)"

skill_sources=()
while IFS= read -r -d '' dir; do
  name="$(basename "$dir")"
  if [[ -n "$skill" && "$name" != "$skill" ]]; then
    continue
  fi
  skill_sources+=("$dir")
done < <(find "$repo_root" -mindepth 1 -maxdepth 1 -type d -exec test -f "{}/SKILL.md" \; -print0)

if [[ ${#skill_sources[@]} -eq 0 ]]; then
  if [[ -n "$skill" ]]; then
    echo "Skill not found: $skill" >&2
  else
    echo "No installable skill directories found." >&2
  fi
  exit 1
fi

installed=()
for source in "${skill_sources[@]}"; do
  name="$(basename "$source")"
  dest="${resolved_target_root}/${name}"
  rm -rf "$dest"

  if [[ "$mode" == "link" ]]; then
    ln -s "$source" "$dest"
  else
    mkdir -p "$dest"
    cp -R "$source"/. "$dest"
  fi

  installed+=("$dest")
done

echo "Installed ${#installed[@]} skill(s) to: $resolved_target_root"
for path in "${installed[@]}"; do
  echo " - $path"
done
