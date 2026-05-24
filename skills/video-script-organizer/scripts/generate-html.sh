#!/bin/bash
# generate-html.sh — 使用 markmap 从 mindmap .md 文件生成交互式 HTML
# Usage: ./generate-html.sh <mindmap_md_file>
#
# 输入：包含 mindmap Markdown 的文件
# 输出：同目录下的 .html 文件

if [ $# -ne 1 ]; then
  echo "Usage: $0 <mindmap_md_file>"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: File not found: $INPUT_FILE"
  exit 1
fi

if ! command -v markmap &> /dev/null; then
  echo "Error: markmap CLI not found. Install with: npm install -g markmap-cli"
  exit 1
fi

BASENAME="${INPUT_FILE%.*}"
OUTPUT_FILE="${BASENAME}.html"

markmap "$INPUT_FILE" -o "$OUTPUT_FILE"

if [ -f "$OUTPUT_FILE" ]; then
  echo "HTML generated: $OUTPUT_FILE"
else
  echo "Error: Failed to generate HTML"
  exit 1
fi
