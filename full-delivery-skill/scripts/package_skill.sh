#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SKILL_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$SKILL_DIR/.." && pwd)
OUT="$REPO_DIR/full-delivery-skill.skill"

# Prefer zip if available (a .skill is a zip). If zip is missing, fall back to
# OpenClaw's packager (python3 + package_skill.py) if present.
if command -v zip >/dev/null 2>&1; then
  TMP="$REPO_DIR/.tmp-full-delivery-skill"
  rm -rf "$TMP"
  mkdir -p "$TMP"
  cp -R "$SKILL_DIR" "$TMP/full-delivery-skill"
  cd "$TMP"
  rm -f "$OUT"
  zip -qr "$OUT" full-delivery-skill
  rm -rf "$TMP"
  echo "Packaged skill -> $OUT"
  exit 0
fi

# Fallback: use OpenClaw skill packager if installed.
PKG1="$HOME/.openclaw/extensions/wecom/node_modules/.pnpm/openclaw@2026.3.13_@napi-rs+canvas@0.1.97_@types+express@5.0.6/node_modules/openclaw/skills/skill-creator/scripts/package_skill.py"
PKG2="$HOME/.openclaw/extensions/openclaw-qqbot/node_modules/.pnpm/openclaw@2026.3.13_@napi-rs+canvas@0.1.97_@types+express@5.0.6/node_modules/openclaw/skills/skill-creator/scripts/package_skill.py"

if command -v python3 >/dev/null 2>&1 && [ -f "$PKG1" ]; then
  python3 "$PKG1" "$SKILL_DIR" "$REPO_DIR"
  echo "Packaged skill (openclaw packager) -> $OUT"
  exit 0
fi

if command -v python3 >/dev/null 2>&1 && [ -f "$PKG2" ]; then
  python3 "$PKG2" "$SKILL_DIR" "$REPO_DIR"
  echo "Packaged skill (openclaw packager) -> $OUT"
  exit 0
fi

echo "ERROR: cannot package .skill (need zip, or OpenClaw packager script)." >&2
echo "Tip: install zip, or run packaging on a machine with OpenClaw CLI installed." >&2
exit 1
