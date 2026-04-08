#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.claude/skills/deep-audit"

if [ -d "$INSTALL_DIR" ]; then
  echo "Updating deep-audit..."
  cd "$INSTALL_DIR" && git pull
else
  echo "Installing deep-audit..."
  git clone https://github.com/pekka-lab/deep-audit "$INSTALL_DIR"
fi

echo ""
echo "deep-audit installed at $INSTALL_DIR"
echo "Use /deep-audit in any Claude Code project."
