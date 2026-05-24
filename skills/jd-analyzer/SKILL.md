---
name: jd-analyzer
description: 岗位JD（职位描述）深度分析技能。当用户粘贴或提供招聘JD、职位描述、岗位要求时，必须使用此技能进行分析。触发场景包括：用户说"帮我分析这个JD"、"看看这个岗位要求"、"我要去面试XXX职位"、"帮我拆解这个职位"、"这个岗位要求什么"、"我看不懂这个JD"、"帮我准备面试"等。即使用户没有明确说"分析JD"，只要他们粘贴了一段看起来像招聘要求的文字，也应该使用此技能。输出包含五大模块：岗位结构化拆解、大白话解读、简历ATS针对性优化、面试题库（纯JD视角）、简历×JD 模拟对练（需简历）。此外，还支持Boss直聘等平台跟进场景的问候语生成与优化（用户说"boss没回复""发问候语""跟进""follow up"等时触发）。
metadata:
  version: 1.0.0
---

# JD 深度分析技能

## 概述

将用户提供的岗位JD转化为五个实用模块，结合候选人简历进行个性化分析，帮助求职者理解岗位、定位差距、优化简历通过ATS筛选、高效备战面试。支持同一对话连续分析多个岗位，简历只读取一次。

---

## CV 缓存机制

### 核心规则：简历在同一对话中只读取一次

每次触发 skill 时，先检查对话历史中是否已出现以下标记之一：

- `[CV已加载]`
- `[CV未找到]`
- `[CV已由用户提供]`

**已有标记** → 直接复用已有简历内容，跳过读取，不输出任何提示
**无标记** → 执行首次读取：

1. 读取 skill 所在路径下的 `references/CV.md`
2. **成功且非空** → 载入简历，回复开头输出 `[CV已加载]`
3. **不存在或为空** → 回复开头输出 `[CV未找到]` 提示

**用户在对话中临时粘贴简历** → 立即输出 `[CV已由用户提供]` 并记录。

---

## 分析流程

**Step 1** CV 缓存检查（见上方规则）

**Step 2** 提取元数据，在输出开头展示信息卡片（公司/岗位/链接）

**Step 3** 通读JD，识别：公司类型、岗位层级、核心业务方向、团队规模（如有）、隐含文化信号

**Step 4** 输出五大模块（模板见 `references/`）：

- **模块一：岗位结构化拆解** → 格式模板详见 [`references/module-1-breakdown.md`](references/module-1-breakdown.md)
- **模块二：大白话解读** → 格式模板详见 [`references/module-2-plain-language.md`](references/module-2-plain-language.md)
- **模块三：简历ATS针对性优化**（需简历） → 格式模板详见 [`references/module-3-ats-optimization.md`](references/module-3-ats-optimization.md)
- **模块四：面试题库** → 格式模板详见 [`references/module-4-interview-questions.md`](references/module-4-interview-questions.md)
- **模块五：简历×JD 模拟对练**（需简历） → 格式模板详见 [`references/module-5-simulation.md`](references/module-5-simulation.md)

**Step 5** 若用户要求导出/归档 → 按 [`references/archive-rules.md`](references/archive-rules.md) 保存到本地

**Step 6** 若用户表达"boss没回复""跟进""打招呼"等意图 → 按 [`references/greeting-templates.md`](references/greeting-templates.md) 生成问候语

> 若用户只粘贴JD要生成问候语（没要分析），跳过模块直接进入问候语模块。

---

## 多岗位连续分析

同一对话中分析第二、三个岗位时：
- 不重新读取 CV，不重复显示加载提示
- 只更新信息卡片（公司/岗位/链接）
- 五个模块照常完整输出，匹配度基于同一份简历对比新JD

---

## 输出风格

- **语言**：中文为主，英文术语保留并附解释
- **语气**：专业不生硬，像有经验的职业顾问
- **排版**：标题 + 分隔线 + emoji，便于快速扫读
- **关键要求和高频考题**加粗**标注
- **务实**：每个模块给可操作建议，不说废话

---

## 特殊情况

**JD过短/信息不足** → 指出缺失项，基于岗位名称推断并标注"推断"

**英文JD** → 结构不变，解读用中文，术语附中文对应

**跨行转职** → 匹配度评估标注"跨行场景"，重点挖掘可迁移能力，给出跨行优势呈现的具体话术

---

## 归档规则

详见 [`references/archive-rules.md`](references/archive-rules.md)
