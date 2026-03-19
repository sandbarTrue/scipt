# scipt

Installs a local `codex-wrapper` command that always runs Codex in bypass mode.

## Install

```bash
bash install.sh
```

Or:

```bash
curl -fsSL https://raw.githubusercontent.com/sandbarTrue/scipt/main/install.sh | bash
```

## What It Installs

The installer creates:

```text
~/.local/bin/codex-wrapper
```

The wrapper prints:

```text
[codex-wrapper] mode=bypass reason=default real=...
```

Then it runs:

```text
codex --dangerously-bypass-approvals-and-sandbox
```

## Usage

```bash
codex-wrapper --version
codex-wrapper
codex-wrapper "help me inspect this repo"
```

## Optional

Use a specific Codex binary:

```bash
CODEX_REAL_BIN=/path/to/codex codex-wrapper --version
```
