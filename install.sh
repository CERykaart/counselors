#!/bin/bash
set -euo pipefail

REPO="aarondfrancis/counselors"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)       ARCH="x64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

case "$OS" in
  darwin|linux) ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

ASSET="counselors-${OS}-${ARCH}"
LATEST=$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)

if [ -z "$LATEST" ]; then
  echo "Failed to fetch latest release version." >&2
  exit 1
fi

URL="https://github.com/${REPO}/releases/download/${LATEST}/${ASSET}"

mkdir -p "$INSTALL_DIR"
echo "Downloading counselors ${LATEST} (${OS}/${ARCH})..."
curl -fSL "$URL" -o "${INSTALL_DIR}/counselors"
chmod +x "${INSTALL_DIR}/counselors"

echo "Installed counselors to ${INSTALL_DIR}/counselors"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "Note: ${INSTALL_DIR} is not in your PATH."
  echo "Add it with: export PATH=\"${INSTALL_DIR}:\$PATH\""
fi
