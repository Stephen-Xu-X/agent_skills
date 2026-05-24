#!/bin/bash
# test_models.sh — 列出并测试第三方 API 平台的所有可用模型
# Usage: ./test_models.sh [thinking]
#
# 从 ~/.claude/settings.json 读取 API 配置
# 调用 /v1/models 获取模型列表
# 逐个测试 /v1/chat/completions 判断可用性

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "Error: settings.json not found at $SETTINGS_FILE"
  exit 1
fi

ANTHROPIC_BASE_URL=$(python3 -c "import json; print(json.load(open('$SETTINGS_FILE'))['ANTHROPIC_BASE_URL'])" 2>/dev/null || \
                     jq -r '.ANTHROPIC_BASE_URL' "$SETTINGS_FILE" 2>/dev/null)
ANTHROPIC_AUTH_TOKEN=$(python3 -c "import json; print(json.load(open('$SETTINGS_FILE'))['ANTHROPIC_AUTH_TOKEN'])" 2>/dev/null || \
                        jq -r '.ANTHROPIC_AUTH_TOKEN' "$SETTINGS_FILE" 2>/dev/null)

if [ -z "$ANTHROPIC_BASE_URL" ] || [ -z "$ANTHROPIC_AUTH_TOKEN" ]; then
  echo "Error: ANTHROPIC_BASE_URL or ANTHROPIC_AUTH_TOKEN not found in $SETTINGS_FILE"
  exit 1
fi

THINKING=false
if [ "$1" = "thinking" ]; then
  THINKING=true
fi

echo "Fetching models from $ANTHROPIC_BASE_URL ..."
RESPONSE=$(curl -s "${ANTHROPIC_BASE_URL}/v1/models" \
  -H "Authorization: Bearer ${ANTHROPIC_AUTH_TOKEN}")

MODELS=$(echo "$RESPONSE" | python3 -c "
import json, sys
try:
  data = json.load(sys.stdin)
  models = data.get('data', [])
  for m in models:
    print(m.get('id', m.get('name', '')))
except:
  sys.exit(1)
" 2>/dev/null) || {
  echo "Error: Failed to parse model list from API response"
  echo "Response: $RESPONSE"
  exit 1
}

if [ -z "$MODELS" ]; then
  echo "No models found in API response."
  exit 0
fi

echo ""
echo "Available models from $(echo "$ANTHROPIC_BASE_URL" | sed 's|/*$||') (thinking: $( [ "$THINKING" = true ] && echo "on" || echo "off" )):"
echo "--------------------------------"

WORKING=""
BROKEN=""

while IFS= read -r model_id; do
  [ -z "$model_id" ] && continue
  echo -n "  Testing $model_id ... "

  if [ "$THINKING" = true ]; then
    RESULT=$(curl -s "${ANTHROPIC_BASE_URL}/v1/chat/completions" \
      -H "Authorization: Bearer ${ANTHROPIC_AUTH_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"model\": \"$model_id\", \"messages\": [{\"role\": \"user\", \"content\": \"hi\"}], \"max_tokens\": 1, \"thinking\": {\"type\": \"enabled\", \"budget_tokens\": 100}}")
  else
    RESULT=$(curl -s "${ANTHROPIC_BASE_URL}/v1/chat/completions" \
      -H "Authorization: Bearer ${ANTHROPIC_AUTH_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"model\": \"$model_id\", \"messages\": [{\"role\": \"user\", \"content\": \"hi\"}], \"max_tokens\": 1}")
  fi

  ERROR=$(echo "$RESULT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('error',{}).get('message',''))" 2>/dev/null)

  if [ -n "$ERROR" ]; then
    echo "BROKEN ($ERROR)"
    BROKEN="$BROKEN  • $model_id (error: $ERROR)"$'\n'
  else
    echo "OK"
    WORKING="$WORKING  • $model_id"$'\n'
  fi
done <<< "$MODELS"

echo ""
echo "[Working]"
echo -n "$WORKING"
echo ""
echo "[Broken]"
echo -n "$BROKEN"
