---
name: video-script-organizer
description: Organize long video/audio transcripts with C1+ vocabulary highlighting, compact vocabulary guide, and Markdown mindmap with CN annotations. Preserves all original content with minimal token overhead.
metadata:
  version: 1.0.0
---

## Critical Rules
1. **Preserve all original content** — do not omit, summarize, or rephrase any substantive material.
2. **No fabrication** — do not add, infer, or generate any concept, topic, term, or example not explicitly present in the transcript.
3. **Minimize token usage** — compact format, no verbose labels, no repeated structural boilerplate.

## Workflow

### Step 1: Transcript Output (Original Language)
Output the entire transcript verbatim, organized into logical sections with `---` separators.
**Bold** C1+ vocabulary for extraction in Step 2.
Format template: [`references/step1-transcript-format.md`](references/step1-transcript-format.md)

### Step 2: Vocabulary Guide
Append `## Vocabulary Guide` with one-term-per-line format.
Format template: [`references/step2-vocabulary-format.md`](references/step2-vocabulary-format.md)

### Step 3: Topic Mindmap (Separate File)
Create `{input_filename}_mindmap.md` in the same directory as the source file.
Format template: [`references/step3-mindmap-format.md`](references/step3-mindmap-format.md)

### Step 4: Generate Interactive HTML
Run the script to produce a self-contained `.html` file via markmap:

```bash
bash scripts/generate-html.sh {input_filename}_mindmap.md
```

## Output Structure

Main response format and generated files table: [`references/output-structure.md`](references/output-structure.md)

## Verification

Checklist: [`references/verification-checklist.md`](references/verification-checklist.md)
