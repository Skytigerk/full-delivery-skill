#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SKILL_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
REPO_DIR=$(CDPATH= cd -- "$SKILL_DIR/.." && pwd)
DATA_DIR="$SKILL_DIR/data"
REF_FILE="$SKILL_DIR/references/personalization.md"
PROFILE_JSON="$DATA_DIR/personalization-profile.json"
LOG_JSONL="$DATA_DIR/feedback-log.jsonl"
TS=$(date '+%Y-%m-%dT%H:%M:%S%z')

mkdir -p "$DATA_DIR"
[ -f "$LOG_JSONL" ] || : > "$LOG_JSONL"

# Extract unique accepted signals into a temp file
PREF_TMP="$DATA_DIR/.prefs.tmp"
awk 'match($0,/"signal":"[^"]+"/){ s=substr($0,RSTART+10,RLENGTH-11); if(!(s in seen)){ seen[s]=1; print s } }' "$LOG_JSONL" > "$PREF_TMP" || true

# Rewrite personalization.md summary
{
  echo '# Personalization Rules'
  echo ''
  echo '夜间维护只能做以下事情：'
  echo ''
  echo '1. 汇总 `data/feedback-log.jsonl`'
  echo '2. 更新 `data/personalization-profile.json`'
  echo '3. 重写本文件中的“当前偏好摘要”'
  echo '4. 重新打包 `.skill`'
  echo '5. （可选）如果开启推送，则提交并推送当前仓库'
  echo ''
  echo '禁止：'
  echo '- 修改 skill 名称'
  echo '- 删除核心流程'
  echo '- 擅自扩大作用范围'
  echo '- 触碰仓库外文件'
  echo ''
  echo '## 当前偏好摘要'
  echo ''
  if [ -s "$PREF_TMP" ]; then
    sed 's/^/- /' "$PREF_TMP"
  else
    echo '- 暂无'
  fi
} > "$REF_FILE"

# Write a minimal JSON profile (no jq/python required)
{
  echo '{'
  echo '  "version": 1,'
  printf '  "updated_at": "%s",\n' "$TS"
  echo '  "preferences": ['
  if [ -s "$PREF_TMP" ]; then
    awk '{ gsub(/"/,"\\\""); printf("    \"%s\"", $0); if (NR<total) printf(",\n"); else printf("\n") }' total="$(wc -l < "$PREF_TMP" | tr -d ' ')" "$PREF_TMP"
  fi
  echo '  ],'
  echo '  "recent_learnings": ['
  tail -n 10 "$PREF_TMP" 2>/dev/null | awk '{ gsub(/"/,"\\\""); printf("    \"%s\"", $0); if (NR<total) printf(",\n"); else printf("\n") }' total="$(tail -n 10 "$PREF_TMP" 2>/dev/null | wc -l | tr -d ' ')" || true
  echo '  ]'
  echo '}'
} > "$PROFILE_JSON"

"$SCRIPT_DIR/package_skill.sh" || true

# Optional: push back to origin if explicitly enabled.
# This keeps the default behavior safe for everyone.
if [ "${FULL_DELIVERY_PUSH:-0}" = "1" ] && [ -d "$REPO_DIR/.git" ]; then
  cd "$REPO_DIR"
  git add full-delivery-skill/references/personalization.md full-delivery-skill/data/personalization-profile.json full-delivery-skill.skill || true
  git diff --cached --quiet || git commit -m "Nightly personalize full-delivery-skill" || true
  git push origin HEAD:main || true
fi

rm -f "$PREF_TMP"
echo "Nightly update complete: $TS"
