#!/usr/bin/env bash
set -euo pipefail

target_root=""
skill=""

while [[ $# -gt 0 ]]; do
  case "$1" in
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

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$target_root" ]]; then
  if [[ -n "${CODEX_HOME:-}" ]]; then
    target_root="${CODEX_HOME}/skills"
  else
    target_root="${HOME}/.codex/skills"
  fi
fi

if [[ ! -d "$target_root" ]]; then
  echo "Target directory does not exist, nothing to remove: $target_root"
  exit 0
fi

resolved_target_root="$(cd "$target_root" && pwd)"

skill_names=()
while IFS= read -r -d '' dir; do
  name="$(basename "$dir")"
  if [[ -n "$skill" && "$name" != "$skill" ]]; then
    continue
  fi
  skill_names+=("$name")
done < <(find "$repo_root" -mindepth 1 -maxdepth 1 -type d -exec test -f "{}/SKILL.md" \; -print0)

if [[ ${#skill_names[@]} -eq 0 ]]; then
  if [[ -n "$skill" ]]; then
    echo "Skill not found: $skill" >&2
  else
    echo "No uninstallable skill definitions found." >&2
  fi
  exit 1
fi

removed=()
for name in "${skill_names[@]}"; do
  dest="${resolved_target_root}/${name}"
  if [[ -e "$dest" ]]; then
    rm -rf "$dest"
    removed+=("$dest")
  fi
done

echo "Removed ${#removed[@]} skill(s) from: $resolved_target_root"
for path in "${removed[@]}"; do
  echo " - $path"
done
