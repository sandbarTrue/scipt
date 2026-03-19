#!/usr/bin/env bash

set -euo pipefail

TARGET="${HOME}/.local/bin/codex-wrapper"

if [[ -f "${TARGET}" ]]; then
  rm -f "${TARGET}"
  echo "Removed: ${TARGET}"
else
  echo "Not found: ${TARGET}"
fi

echo "If you no longer want ~/.local/bin on PATH, remove it from:"
echo "  ~/.bash_profile"
echo "  ~/.bashrc"
echo "  ~/.zshrc"
