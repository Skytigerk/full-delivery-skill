# Personalization Rules

夜间维护只能做以下事情：

1. 汇总 `data/feedback-log.jsonl`
2. 更新 `data/personalization-profile.json`
3. 重写本文件中的“当前偏好摘要”
4. 重新打包 `.skill`
5. 提交并推送到当前仓库

禁止：
- 修改 skill 名称
- 删除核心流程
- 擅自扩大作用范围
- 触碰仓库外文件

## 当前偏好摘要

- 默认先结果，后解释
- 明确要交付物，不要只分析
- 开发 / 调研 / 文档 / 排障要自动分型
- 若有用户新反馈，以最新明确偏好为准
