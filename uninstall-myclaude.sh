#!/usr/bin/env bash

set -euo pipefail

TARGET="${HOME}/.local/bin/myclaude"
EXAMPLE_FILE="${HOME}/.config/myclaude/config.sh.example"
CONFIG_FILE="${HOME}/.config/myclaude/config.sh"

if [[ -f "${TARGET}" ]]; then
  rm -f "${TARGET}"
  echo "Removed: ${TARGET}"
else
  echo "Not found: ${TARGET}"
fi

if [[ -f "${EXAMPLE_FILE}" ]]; then
  rm -f "${EXAMPLE_FILE}"
  echo "Removed: ${EXAMPLE_FILE}"
else
  echo "Not found: ${EXAMPLE_FILE}"
fi

if [[ -f "${CONFIG_FILE}" ]]; then
  echo "Kept private config: ${CONFIG_FILE}"
  echo "Remove it manually if you no longer need it."
fi

echo "If you no longer want ~/.local/bin on PATH, remove it from:"
echo "  ~/.bash_profile"
echo "  ~/.bashrc"
echo "  ~/.zshrc"
