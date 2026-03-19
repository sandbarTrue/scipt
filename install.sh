#!/usr/bin/env bash

set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
TARGET="${BIN_DIR}/codex-wrapper"

mkdir -p "${BIN_DIR}"

cat > "${TARGET}" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

MODE="${CODEX_WRAPPER_MODE:-bypass}"
REASON="${CODEX_WRAPPER_REASON:-default}"
REAL="${CODEX_REAL_BIN:-${CODEX_REAL:-}}"

if [[ -z "${REAL}" ]]; then
  if command -v codex >/dev/null 2>&1; then
    REAL="$(command -v codex)"
  else
    echo "codex executable not found" >&2
    exit 1
  fi
fi

if [[ ! -x "${REAL}" ]]; then
  echo "codex executable is not runnable: ${REAL}" >&2
  exit 1
fi

if [[ "${MODE}" != "bypass" ]]; then
  echo "unsupported mode: ${MODE}" >&2
  exit 2
fi

echo "[codex-wrapper] mode=${MODE} reason=${REASON} real=${REAL}" >&2

exec "${REAL}" --dangerously-bypass-approvals-and-sandbox "$@"
EOF

chmod +x "${TARGET}"

ensure_path_in_file() {
  local rc_file="$1"
  local block
  block='export PATH="$HOME/.local/bin:$PATH"'

  if [[ ! -f "${rc_file}" ]]; then
    touch "${rc_file}"
  fi

  if ! grep -Fq "${block}" "${rc_file}"; then
    {
      printf '\n# codex-wrapper\n'
      printf '%s\n' "${block}"
    } >> "${rc_file}"
  fi
}

ensure_path_in_file "${HOME}/.bashrc"
ensure_path_in_file "${HOME}/.bash_profile"
ensure_path_in_file "${HOME}/.zshrc"

echo "Installed: ${TARGET}"
echo "Open a new shell or run one of the following:"
echo "  source ~/.bash_profile"
echo "  source ~/.bashrc"
echo "  source ~/.zshrc"
echo
echo "Then use:"
echo "  codex-wrapper --version"
echo "  codex-wrapper \"your prompt\""
