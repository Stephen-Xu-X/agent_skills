---
name: skills-inventory
description: 管理 Claude Code skills/plugins 安装清单。当用户说"更新skill清单""检查插件状态""列出已安装skill""同步skill记录""备份配置""我装了哪些skill""换设备""恢复配置""一键安装"时触发。用于维护 ~/.claude/skills/ 和 ~/.claude/plugins/ 的安装记录。适配维护和恢复两种场景。
metadata:
  version: 2.0.0
---

# Skills Inventory

维护当前设备上所有自建 skill（私人合集）和第三方插件（Marketplace）的安装清单。
支持变更检测、增量更新、一键同步到 GitHub、以及新设备双轨恢复。

---

## 核心概念：双源管理

所有 skill 按来源分为两类：

| 来源 | 路径 | 管理方式 |
|------|------|----------|
| 🧑 **自建 Skills** | `~/.claude/skills/` | 打包为 Plugin 推送到 GitHub（`E:/github/agent_skills/`） |
| 📦 **第三方插件** | `~/.claude/plugins/` | 只记录安装方式和来源，不混入私人合集 |

---

## 扫描范围

1. 列出 `~/.claude/skills/` 下所有子目录（自建 skills）
2. 读取 `~/.claude/plugins/installed_plugins.json`（已安装插件）
3. 读取 `~/.claude/plugins/known_marketplaces.json`（marketplace 源）
4. 读取 `~/.claude/settings.json` 中 `enabledPlugins` 字段
5. 读取 `E:/github/agent_skills/skills/`（备份仓库，路径从 [`references/config.md`](references/config.md) 读取）

---

## 模式一：查看模式

用户说"列出所有skill""查看清单"等时，直接输出 [`references/inventory.md`](references/inventory.md) 当前有效清单。

---

## 模式二：维护模式（当前设备）

### 流程

1. 加载 [`references/inventory.md`](references/inventory.md)
2. 扫描环境（见上方扫描范围）
3. 对比 inventory，分类：**matched / 新增 / 缺失**

### 变更检测（内置，所有入口均执行）

每次触发 skills-inventory（不论何种模式），先检测自建 skill 是否有变更：

1. 加载 [`references/state.json`](references/state.json)（记录各 skill 上次同步时的 mtime）
2. 对比当前 `~/.claude/skills/*/` 的 mtime + 仓库 `E:/github/agent_skills/skills/*/` 的 mtime
3. 输出变更报告，格式：
   ```
   📋 变更检测
     ▸ jd-analyzer — 本地已修改（上次同步：2026-05-28）
     ▸ diary-organizer — 仓库比本地旧，可同步
     ▸ 其余 4 个 skill 无变更
   是否需要同步到 GitHub？(Y/N)
   ```
4. 用户确认后进入同步模式。

### 无变更

直接执行触发时的原定模式（查看/更新清单/恢复配置等）。

---

## 模式三：同步模式

触发词：`同步到仓库` / `推送到GitHub` / `sync` / `备份skill`

将本地自建 skill 同步到 `E:/github/agent_skills/`，更新 plugin.json 和 README，并推送到 GitHub。

### 流程

1. **仓库检查**
   - 确认 `E:/github/agent_skills/` 存在且是 git 仓库（路径从 [`references/config.md`](references/config.md) 读取）
   - 不存在则提示用户先克隆仓库

2. **差异对比**
   - 本地 `~/.claude/skills/`（自建） vs 仓库 `E:/github/agent_skills/skills/`
   - 三类结果：
     - **新增**：本地有、仓库无 → 需要拷贝
     - **更新**：两边都有，本地 mtime 更新 → 需要覆盖
     - **仅仓库**：仓库有、本地无 → 询问是否删除

3. **询问用户确认** → "检测到以下变更，是否同步到 GitHub？"
   - 展示变更摘要
   - Y → 执行同步
   - N → 取消

4. **执行同步**
   - 拷贝自建 skill 目录到 `E:/github/agent_skills/skills/<name>/`
   - 排除规则（[`references/config.md`](references/config.md)）：
     - `node_modules/`、`.git/`、`references/CV.md`、`__pycache__/`、`*.log`
   - 重写 `E:/github/agent_skills/.claude-plugin/plugin.json`
     - 根据 `skills/` 目录实际内容生成 skills 数组
   - 重写 `E:/github/agent_skills/README.md`
     - 根据 `skills/` 目录生成技能表格

5. **Git 操作**（提示用户确认后执行）
   ```bash
   cd E:/github/agent_skills
   git add .
   git commit -m "sync: update skills - <names>"
   git push
   ```

6. **更新 [`references/state.json`](references/state.json)**
   - 记录各 skill 同步后的 mtime 和 git SHA
   - 更新 `last_sync` 时间戳

7. **同步 [`references/inventory.md`](references/inventory.md)**
   - 更新章节一（自建 Skills）表格与最后同步时间

---

## 模式四：恢复模式（新设备）

### 触发条件

缺失率 = 缺失数 / inventory 总数
- **缺失率 > 70%** → 恢复模式
- **否则** → 维护模式

### 流程

1. 报告检测结果："检测到新设备环境，当前仅安装了 X 项，完整清单有 Y 项"
2. 输出双轨恢复指引：

   ```markdown
   ## 恢复步骤

   ### 1. 自建 skill 合集（先装）
   claude plugins marketplace add https://github.com/Stephen-Xu-X/agent_skills
   claude plugins install agent-skills

   ### 2. 第三方插件（按需选择安装）
   claude plugins install claude-md-management@claude-plugins-official
   claude plugins install obsidian-visual-skills@axton-obsidian-visual-skills
   claude plugins install andrej-karpathy-skills@karpathy-skills
   ```
3. 询问用户是否一键安装所有 plugin
   - **是** → 逐条执行 install 命令
   - **否** → 询问是否选择性安装
4. 完成后将本次恢复记录写入 changelog

---

## 输出风格

- **标题**：章节编号 + emoji 分类
- **变更报告**：紧凑格式，每条一行
- **恢复指引**：直接给出可执行的命令，不废话
- **检测到无变更**：一句话带过，不输出长篇报告
