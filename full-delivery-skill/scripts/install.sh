#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SKILL_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$SKILL_DIR/.." && pwd)
TARGET_SKILLS_DIR="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"
TARGET_SKILL_DIR="$TARGET_SKILLS_DIR/full-delivery-skill"
LOG_DIR="$REPO_DIR/logs"
CRON_LOG="$LOG_DIR/nightly_update.log"

mkdir -p "$TARGET_SKILLS_DIR" "$LOG_DIR"
rm -rf "$TARGET_SKILL_DIR"
cp -R "$SKILL_DIR" "$TARGET_SKILL_DIR"

echo "Installed skill to: $TARGET_SKILL_DIR"

# Best-effort packaging
"$SCRIPT_DIR/package_skill.sh" >/dev/null 2>&1 || true

# NOTE: For security reasons, downloading a repo should NOT auto-run scripts.
# The user must explicitly run this installer.

# Prefer OpenClaw's built-in scheduler when available.
if command -v openclaw >/dev/null 2>&1; then
  if openclaw cron status >/dev/null 2>&1; then
    # Use Gateway scheduler. It runs an agent turn; we just need it to execute this shell.
    # We register a system-event job that runs nightly_update.sh via exec.
    # For portability, we install a job that posts a system event which the agent handles.
    # Simpler: fall back to system crontab unless user explicitly wants openclaw cron.
    :
  fi
fi

# System crontab (portable). Install/update idempotently.
UPDATE_CMD="cd '$REPO_DIR' && ./full-delivery-skill/scripts/nightly_update.sh >> '$CRON_LOG' 2>&1"
CRON_EXPR="0 2 * * * $UPDATE_CMD"

TMP_CRON=$(mktemp)
crontab -l 2>/dev/null | grep -v 'full-delivery-skill/scripts/nightly_update.sh' > "$TMP_CRON" || true
echo "$CRON_EXPR" >> "$TMP_CRON"
crontab "$TMP_CRON"
rm -f "$TMP_CRON"

echo "Cron installed (system crontab): every day at 02:00"
echo "Cron log: $CRON_LOG"
echo "If you want it to auto-push personalization updates to GitHub, set: FULL_DELIVERY_PUSH=1 in the cron environment."
echo "Done."
