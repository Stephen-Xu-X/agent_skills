---
name: list-models
description: Query the third-party API platform to list all available AI models and test each model's availability. 查询和测试当前 API 平台所有可用的 AI 模型。
metadata:
  version: 1.0.0
---

# List Available Models

Query the third-party API platform to list all available AI models and test each model's availability.

## Usage

```
/list-models [thinking]
```

## Arguments

- `thinking` (optional): Test models with thinking mode enabled.

## What it does

1. Reads `ANTHROPIC_BASE_URL` and `ANTHROPIC_AUTH_TOKEN` from `~/.claude/settings.json`
2. Calls `/v1/models` to fetch available models
3. Tests each model with `/v1/chat/completions` to determine if working
4. Displays results

## Instructions

Run the test script:

```bash
bash scripts/test_models.sh [thinking]
```

The script will:
1. Parse API config from `~/.claude/settings.json`
2. Fetch model list via `/v1/models`
3. Test each model with `max_tokens: 1` (thinking mode uses `budget_tokens: 100` if `thinking` argument provided)
4. Classify: working (valid response) vs broken (error response)
5. Display results grouped by status

## Requirements

- `curl` for API calls
- API must support OpenAI-compatible `/v1/models` and `/v1/chat/completions` endpoints
