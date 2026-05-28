# skills-inventory 配置

## 仓库路径

```yaml
repo_path: E:/github/agent_skills
```

## 同步排除规则

拷贝 skill 到仓库时跳过以下内容：

```
node_modules/
.git/
references/CV.md
references/cv.md
__pycache__/
*.log
```

## 第三方插件安装清单

换设备时按需安装：

| 插件 | 命令 |
|------|------|
| claude-md-management | `claude plugins install claude-md-management@claude-plugins-official` |
| obsidian-visual-skills | `claude plugins install obsidian-visual-skills@axton-obsidian-visual-skills` |
| karpathy-guidelines | `claude plugins install andrej-karpathy-skills@karpathy-skills` |
