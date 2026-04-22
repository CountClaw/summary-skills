#!/usr/bin/env bash
set -euo pipefail

repo="${SUMMARY_SKILLS_REPO:-CountClaw/summary-skills}"
ref="${SUMMARY_SKILLS_REF:-master}"
target_root="${SUMMARY_SKILLS_TARGET_ROOT:-}"
skill="${SUMMARY_SKILLS_SKILL:-}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo="${2:-}"
      shift 2
      ;;
    --ref)
      ref="${2:-}"
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

temp_root="$(mktemp -d)"
cleanup() {
  rm -rf "$temp_root"
}
trap cleanup EXIT

archive_url="https://github.com/${repo}/archive/refs/heads/${ref}.tar.gz"
archive_path="${temp_root}/repo.tar.gz"
extract_root="${temp_root}/extract"
mkdir -p "$extract_root"

echo "Downloading: $archive_url"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$archive_url" -o "$archive_path"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$archive_path" "$archive_url"
else
  echo "curl or wget is required." >&2
  exit 1
fi

tar -xzf "$archive_path" -C "$extract_root"

repo_dir="$(find "$extract_root" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [[ -z "$repo_dir" ]]; then
  echo "Failed to locate extracted repository." >&2
  exit 1
fi

install_script="${repo_dir}/install.sh"
if [[ ! -f "$install_script" ]]; then
  echo "install.sh not found in extracted repository." >&2
  exit 1
fi

args=()
if [[ -n "$target_root" ]]; then
  args+=(--target-root "$target_root")
fi
if [[ -n "$skill" ]]; then
  args+=(--skill "$skill")
fi

echo "Running installer from: $repo_dir"
bash "$install_script" "${args[@]}"
