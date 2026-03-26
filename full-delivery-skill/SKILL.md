---
name: full-delivery-skill
description: "Deliverable-first execution workflow (中文名：完整交付skill). Use when the user asks for 完整交付, 交付物, 做完, 别偷懒, 给最终结果, wants end-to-end task completion instead of advice, or asks for concrete artifacts such as files, patches, commands, checklists, or reports. Automatically classify the task as development, research, documentation, or troubleshooting and choose the matching delivery template. Triggers include full delivery skill, 完整交付skill, 交付模式, 不要只分析, 给交付物."
---

# Full Delivery Skill（完整交付skill）

把任何任务变成“可验收的交付”：先定义交付物与完成标准，再执行、验证、交付。禁止只给建议就收工。

## Non-negotiables（硬规则）

1. **先写交付契约**：必须明确 *Deliverables*（交付物清单）与 *DoD*（完成定义）。
2. **能动手就动手**：能用工具完成（读/写文件、执行命令、跑脚本、导出结果）就直接做，不要把活甩回用户。
3. **卡住也要交付**：遇到权限/信息不足时，交付“已完成部分 + 阻塞点 + 需要用户提供的最小信息”。
4. **禁止虚假完成**：没有交付物/没有验收标准对应的证据，不要说“搞定了”。
5. **每次都要选任务类型**：开发 / 调研 / 文档 / 排障，先分类再套模板。

## Step 0 — Auto Classification（自动识别任务类型）

先根据用户目标选择主类型；若混合，选“主要交付物”对应的类型，再在交付包里补副产物。

### A. Development（开发）

符合任一信号时优先归到开发：
- 写代码、改代码、实现功能、补测试、重构、发版准备、PR、脚本、配置修改
- 用户明确要“改文件 / 给补丁 / 跑测试 / 交代码”

读：`references/development.md`

### B. Research（调研）

符合任一信号时优先归到调研：
- 查资料、做对比、找方案、研究竞品、整理结论、给建议但要有证据
- 用户要“结论 + 依据 + 来源 + 建议”

读：`references/research.md`

### C. Documentation（文档）

符合任一信号时优先归到文档：
- 写文档、整理方案、起草 README / PRD / SOP / 汇报 / 提案 / 周报
- 用户要“可直接发/贴/交”的成稿

读：`references/documentation.md`

### D. Troubleshooting（排障）

符合任一信号时优先归到排障：
- 报错、异常、故障、根因分析、定位问题、恢复服务、性能问题
- 用户要“查原因 / 给修复 / 给排查步骤” 

读：`references/troubleshooting.md`

如果不确定：
- 要修改系统/代码 → 选 **开发**
- 要找信息和判断 → 选 **调研**
- 要交成稿 → 选 **文档**
- 要定位问题 → 选 **排障**

## Step 1 — Delivery Contract（交付契约）

输出以下结构（必须出现）：

- **任务类型**：开发 / 调研 / 文档 / 排障
- **Deliverables（交付物）**：编号列出最终要交的东西
- **Definition of Done（完成定义）**：每个交付物对应的验收条件
- **Execution Plan（执行计划）**：3–7 步，能并行的标注
- **Risks（风险）**：最多 3 条，写清规避策略

> 如果用户没有说清交付物：默认至少交付 **最终结论 + 过程摘要 + 可复现步骤/命令 + 下一步**。

## Step 2 — Execute（执行）

按计划推进，优先使用确定性工具：

- **文件类**：read/edit/write，给出具体文件路径与变更点
- **工程类**：exec 运行检查/测试/构建；必要时创建补丁
- **网页/资料类**：能查就查；查不到就说明限制并给替代方案

要求：
- 每个关键动作都要留下“可验证证据”（命令输出摘要、文件 diff 摘要、路径列表）
- 避免无意义长篇过程叙述；只记录对验收有用的信息

## Step 3 — Verify（自检与验收对齐）

- 对照 Step 1 的 DoD 逐条打勾
- 明确“已完成/未完成/部分完成”的边界
- 如果无法验证，交付“验证脚本/验证步骤”，并说明为什么无法在本机验证

## Step 4 — Deliver（交付）

用“交付包”的形式输出：

1. **交付物清单**（与 Deliverables 对齐）
2. **产物位置**（文件路径/链接/命令）
3. **使用说明**（最短可用路径：怎么跑、怎么验证）
4. **变更摘要**（做了什么、为什么这样做）
5. **剩余风险/后续建议**（可选，最多 5 条）

## Step 5 — Personalize（个性化积累）

当用户对结果给出偏好、否定、补充、或者明确说“这样更好/不要这样”时：

- 先在当前回复里吸收这些偏好
- 如果可以写文件，就把可复用偏好追加到：`data/feedback-log.jsonl`
- 记录内容尽量短：时间、任务类型、喜欢什么、不喜欢什么、原因、是否被接受

夜间维护任务会把这些反馈整理进：
- `data/personalization-profile.json`
- `references/personalization.md`

## Output Template（强制输出模板）

在完整交付模式下，最终回复必须包含以下小标题（顺序可微调，但都要出现）：

- **目标**
- **任务类型**
- **交付物**
- **完成定义（DoD）**
- **执行与证据**
- **最终交付包**
- **未完成/阻塞（如有）**

## Anti-Laziness Checks（反偷懒自检）

交付前自问并在心里过一遍（不必全写出来）：

- 我有没有把“能做的”变成“叫用户去做”？如果有，改成我直接做
- 我有没有给出可验收的东西？如果没有，补交付物
- 我有没有把结论写得像建议？如果用户要“做完”，就要像交付
- 我有没有根据任务类型套对模板？如果没有，回去补

## References

按需读取：
- `references/development.md`
- `references/research.md`
- `references/documentation.md`
- `references/troubleshooting.md`
- `references/deliverables.md`
- `references/personalization.md`
