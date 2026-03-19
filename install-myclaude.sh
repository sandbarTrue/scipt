#!/usr/bin/env bash

set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/myclaude"
TARGET="${BIN_DIR}/myclaude"
CONFIG_FILE="${CONFIG_DIR}/config.sh"
EXAMPLE_FILE="${CONFIG_DIR}/config.sh.example"

mkdir -p "${BIN_DIR}" "${CONFIG_DIR}"

cat > "${TARGET}" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

CMD="${MYCLAUDE_CMD:-claude}"
CONFIG_FILE="${HOME}/.config/myclaude/config.sh"

if [[ -f "${CONFIG_FILE}" ]]; then
  # shellcheck disable=SC1090
  source "${CONFIG_FILE}"
fi

if ! command -v "${CMD}" >/dev/null 2>&1; then
  echo "claude executable not found: ${CMD}" >&2
  exit 1
fi

PERM_ARGS=()
if "${CMD}" --help 2>/dev/null | command grep -q -- '--permission-mode'; then
  PERM_ARGS=(--permission-mode bypassPermissions)
elif "${CMD}" --help 2>/dev/null | command grep -q -- '--dangerously-skip-permissions'; then
  PERM_ARGS=(--dangerously-skip-permissions)
fi

case "${1:-}" in
  --glm-5)
    export ANTHROPIC_BASE_URL="${MYCLAUDE_GLM5_BASE_URL:-}"
    export ANTHROPIC_AUTH_TOKEN="${MYCLAUDE_GLM5_AUTH_TOKEN:-}"
    export ANTHROPIC_MODEL="${MYCLAUDE_GLM5_MODEL:-GLM-5}"
    shift
    ;;
  --claude-4.5)
    export ANTHROPIC_BASE_URL="${MYCLAUDE_CLAUDE45_BASE_URL:-}"
    export ANTHROPIC_AUTH_TOKEN="${MYCLAUDE_CLAUDE45_AUTH_TOKEN:-}"
    export ANTHROPIC_MODEL="${MYCLAUDE_CLAUDE45_MODEL:-claude-sonnet-4-5-20250929-thinking}"
    shift
    ;;
  *)
    echo "Usage: myclaude --glm-5 | --claude-4.5 [args]" >&2
    echo "Set credentials in ~/.config/myclaude/config.sh or environment variables." >&2
    exit 1
    ;;
esac

if [[ -z "${ANTHROPIC_BASE_URL:-}" ]]; then
  echo "Missing base URL for selected profile." >&2
  exit 1
fi

if [[ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]]; then
  echo "Missing auth token for selected profile." >&2
  exit 1
fi

exec "${CMD}" --model "${ANTHROPIC_MODEL}" "${PERM_ARGS[@]}" "$@"
EOF

chmod +x "${TARGET}"

cat > "${EXAMPLE_FILE}" <<'EOF'
#!/usr/bin/env bash

# Copy this file to ~/.config/myclaude/config.sh and fill in your private values.

export MYCLAUDE_GLM5_BASE_URL="https://your-glm-endpoint.example.com/api/anthropic"
export MYCLAUDE_GLM5_AUTH_TOKEN="your-glm-token"
export MYCLAUDE_GLM5_MODEL="GLM-5"

export MYCLAUDE_CLAUDE45_BASE_URL="https://your-claude-endpoint.example.com"
export MYCLAUDE_CLAUDE45_AUTH_TOKEN="your-claude-token"
export MYCLAUDE_CLAUDE45_MODEL="claude-sonnet-4-5-20250929-thinking"
EOF

ensure_path_in_file() {
  local rc_file="$1"
  local block
  block='export PATH="$HOME/.local/bin:$PATH"'

  if [[ ! -f "${rc_file}" ]]; then
    touch "${rc_file}"
  fi

  if ! grep -Fq "${block}" "${rc_file}"; then
    {
      printf '\n# myclaude\n'
      printf '%s\n' "${block}"
    } >> "${rc_file}"
  fi
}

ensure_path_in_file "${HOME}/.bashrc"
ensure_path_in_file "${HOME}/.bash_profile"
ensure_path_in_file "${HOME}/.zshrc"

echo "Installed: ${TARGET}"
echo "Example config: ${EXAMPLE_FILE}"
echo "Create your private config with:"
echo "  cp ${EXAMPLE_FILE} ${CONFIG_FILE}"
echo
echo "Then fill in your real endpoints and tokens, and use:"
echo "  myclaude --glm-5"
echo "  myclaude --claude-4.5"
