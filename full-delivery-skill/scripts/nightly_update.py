#!/usr/bin/env python3
import json, os, pathlib, datetime

BASE = pathlib.Path(__file__).resolve().parents[1]
DATA = BASE / "data"
REF = BASE / "references" / "personalization.md"
PROFILE = DATA / "personalization-profile.json"
LOG = DATA / "feedback-log.jsonl"


def load_json(path, default):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def main():
    profile = load_json(PROFILE, {"version": 1, "updated_at": None, "preferences": [], "recent_learnings": []})
    lines = []
    if LOG.exists():
        for raw in LOG.read_text(encoding="utf-8").splitlines():
            raw = raw.strip()
            if not raw:
                continue
            try:
                lines.append(json.loads(raw))
            except Exception:
                continue
    accepted = [x.get("signal") for x in lines if x.get("accepted") and x.get("signal")]
    # de-dup keeping order
    merged = []
    for item in profile.get("preferences", []) + accepted:
        if item and item not in merged:
            merged.append(item)
    profile["preferences"] = merged[:20]
    profile["recent_learnings"] = accepted[-10:]
    profile["updated_at"] = datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat()
    PROFILE.write_text(json.dumps(profile, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    summary = "\n".join(f"- {p}" for p in profile["preferences"]) or "- 暂无"
    content = f"# Personalization Rules\n\n夜间维护只能做以下事情：\n\n1. 汇总 `data/feedback-log.jsonl`\n2. 更新 `data/personalization-profile.json`\n3. 重写本文件中的“当前偏好摘要”\n4. 重新打包 `.skill`\n5. 提交并推送到当前仓库\n\n禁止：\n- 修改 skill 名称\n- 删除核心流程\n- 擅自扩大作用范围\n- 触碰仓库外文件\n\n## 当前偏好摘要\n\n{summary}\n"
    REF.write_text(content, encoding="utf-8")
    print("Updated personalization profile and reference.")


if __name__ == "__main__":
    main()
