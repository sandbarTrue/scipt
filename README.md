# scipt

Small local installers for shell commands.

## Install `codex-wrapper`

```bash
curl -fsSL https://raw.githubusercontent.com/sandbarTrue/scipt/main/install.sh | bash
```

This installs:

```text
~/.local/bin/codex-wrapper
```

It prints:

```text
[codex-wrapper] mode=bypass reason=default real=...
```

Then runs:

```text
codex --dangerously-bypass-approvals-and-sandbox
```

Usage:

```bash
codex-wrapper --version
codex-wrapper
codex-wrapper "help me inspect this repo"
```

Optional:

```bash
CODEX_REAL_BIN=/path/to/codex codex-wrapper --version
```

Uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/sandbarTrue/scipt/main/uninstall.sh | bash
```

## Install `myclaude`

```bash
curl -fsSL https://raw.githubusercontent.com/sandbarTrue/scipt/main/install-myclaude.sh | bash
```

This installs:

```text
~/.local/bin/myclaude
```

No secrets are embedded in the script. The installer writes only:

```text
~/.config/myclaude/config.sh.example
```

Create your private config:

```bash
cp ~/.config/myclaude/config.sh.example ~/.config/myclaude/config.sh
```

Then edit `~/.config/myclaude/config.sh` and fill in your own endpoints and tokens.

Usage:

```bash
myclaude --glm-5
myclaude --claude-4.5
myclaude --claude-4.5 "help me review this repo"
```

Uninstall:

```bash
curl -fsSL https://raw.githubusercontent.com/sandbarTrue/scipt/main/uninstall-myclaude.sh | bash
```

This removes:

```text
~/.local/bin/myclaude
~/.config/myclaude/config.sh.example
```

It does not remove your private:

```text
~/.config/myclaude/config.sh
```

Supported private config variables:

```bash
MYCLAUDE_GLM5_BASE_URL
MYCLAUDE_GLM5_AUTH_TOKEN
MYCLAUDE_GLM5_MODEL
MYCLAUDE_CLAUDE45_BASE_URL
MYCLAUDE_CLAUDE45_AUTH_TOKEN
MYCLAUDE_CLAUDE45_MODEL
MYCLAUDE_CMD
```
