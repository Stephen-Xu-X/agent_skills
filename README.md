# agent_skills

个人 Claude Code skills 合集。

## 安装

```bash
claude plugins marketplace add https://github.com/Stephen-Xu-X/agent_skills
claude plugins install agent-skills
```

## 包含的 Skills

| Skill | 用途 |
|-------|------|
| diary-organizer | 日记整理：口语转书面日记、周复盘、模板填充 |
| jd-analyzer | 岗位JD深度分析、简历优化、面试准备 |
| list-models | 查询和测试API平台可用AI模型 |
| skill-creator | 创建、编辑和优化skill（含benchmark与eval） |
| skills-inventory | 管理skills/plugins安装清单，同步到GitHub |
| video-script-organizer | 长视频/音频转录整理（词汇表+思维导图） |

## 换设备恢复

```bash
# 自建 skill
claude plugins marketplace add https://github.com/Stephen-Xu-X/agent_skills
claude plugins install agent-skills

# 第三方插件（按需）
claude plugins install claude-md-management@claude-plugins-official
claude plugins install obsidian-visual-skills@axton-obsidian-visual-skills
claude plugins install andrej-karpathy-skills@karpathy-skills
```
