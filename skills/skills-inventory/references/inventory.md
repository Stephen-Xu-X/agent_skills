# Skills & Plugins 清单

> 最后更新：2026-05-28
> 用途：换设备或配置丢失时快速恢复
> 维护方式：触发 `skills-inventory` skill 自动更新

## 一、🧑 自建 Skills（私人合集，托管在 GitHub）

可通过以下命令一键安装所有自建 skill：

```bash
claude plugins marketplace add https://github.com/Stephen-Xu-X/agent_skills
claude plugins install agent-skills
```

| Skill 名称 | 用途 | 最后同步 |
|------------|------|----------|
| diary-organizer | 日记整理：口语转书面日记、周复盘、模板填充 | 2026-05-28 |
| jd-analyzer | 岗位 JD 深度分析、简历优化、面试准备 | 2026-05-28 |
| list-models | 查询第三方 API 平台可用模型列表 | 2026-05-28 |
| skill-creator | 创建/编辑/优化 skill（含 benchmark、eval、验证功能） | 2026-05-28 |
| skills-inventory | 管理 skills/plugins 安装清单（本 skill） | 2026-05-28 |
| video-script-organizer | 视频/音频长转录整理（词汇表 + 思维导图） | 2026-05-28 |

> 以上 skill 托管在 [Stephen-Xu-X/agent_skills](https://github.com/Stephen-Xu-X/agent_skills)，通过 Plugin 格式发布。
> 同步方式：触发 skills-inventory → 自动检测变更 → 确认后推送到仓库。

---

## 二、📦 第三方插件（Marketplace 安装）

这些插件通过独立的 marketplace 安装，不包含在私人合集中。**换设备时需单独安装。**

### 1. Karpathy Guidelines
- **插件名：** andrej-karpathy-skills
- **仓库：** [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)
- **包含 skill：** `karpathy-guidelines` — 减少常见 LLM 编码错误的行为指南
- **安装：**
  ```bash
  claude plugins marketplace add https://github.com/forrestchang/andrej-karpathy-skills
  claude plugins install andrej-karpathy-skills@karpathy-skills
  ```

### 2. Obsidian Visual Skills
- **插件名：** obsidian-visual-skills
- **仓库：** [axtonliu/axton-obsidian-visual-skills](https://github.com/axtonliu/axton-obsidian-visual-skills)
- **包含 skills：**
  - `excalidraw-diagram` — 生成 Excalidraw 图表
  - `mermaid-visualizer` — 将文本转为 Mermaid 图表
  - `obsidian-canvas-creator` — 创建 Obsidian Canvas 文件
- **安装：**
  ```bash
  claude plugins marketplace add https://github.com/axtonliu/axton-obsidian-visual-skills.git
  claude plugins install obsidian-visual-skills@axton-obsidian-visual-skills
  ```

### 3. CLAUDE.md 管理工具
- **插件名：** claude-md-management
- **仓库：** [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)（官方 Marketplace）
- **包含 skills：** `init` / `review` / `security-review` — CLAUDE.md 文件审计、质量维护、项目记忆管理
- **安装：**
  ```bash
  claude plugins install claude-md-management@claude-plugins-official
  ```

---

## 三、Claude Code Marketplaces 源

| 源名称 | 地址 | 说明 |
|--------|------|------|
| claude-plugins-official | anthropics/claude-plugins-official | 官方 Marketplace（200+ 插件，已安装 claude-md-management） |
| karpathy-skills | forrestchang/andrej-karpathy-skills | 已安装 andrej-karpathy-skills |
| axton-obsidian-visual-skills | axtonliu/axton-obsidian-visual-skills | 已安装 obsidian-visual-skills |

---

## 四、配置恢复备忘

### 新设备一键恢复

```bash
# 1. 安装自建 skill 合集
claude plugins marketplace add https://github.com/Stephen-Xu-X/agent_skills
claude plugins install agent-skills

# 2. 安装第三方插件（按需执行）
claude plugins install claude-md-management@claude-plugins-official
claude plugins install obsidian-visual-skills@axton-obsidian-visual-skills
claude plugins install andrej-karpathy-skills@karpathy-skills
```

### 手动迁移（完整备份）
1. 复制 `~/.claude/settings.json`（配置文件）
2. 复制 `~/.claude/plugins/`（插件缓存）
3. 插件安装后自动激活（enabledPlugins 配置在 settings.json 中）

---

## 变更日志

### 2026-05-28
- **重构** inventory.md 结构为"自建 Skills"+"第三方插件"双源管理
- **新增** 同步模式与变更检测机制
- **移除** `guizang-social-card-skill` — 从本地 skills 目录中消失

### 2026-05-28 (之前)
- **新增** `guizang-social-card-skill` — 本地 skill，小红书/公众号社交卡片与封面图生成
- **新增** `claude-md-management` — 来自官方 Marketplace，CLAUDE.md 文件管理工具

### 2026-05-26
- **新增** `diary-organizer` — 从本地 skill 纳入清单

### 2026-05-24
- **新增** `skills-inventory` — 本清单管理 skill 首次创建
- **新增** `video-script-organizer` — 从本地 skill 纳入清单
- **新增** `list-models` — 从本地 skill 纳入清单
- **新增** `jd-analyzer` — 从本地 skill 纳入清单
- **新增** `karpathy-guidelines` — 从本地 plugin 纳入清单
- **新增** `obsidian-visual-skills` (含 3 skills) — 从本地 plugin 纳入清单
