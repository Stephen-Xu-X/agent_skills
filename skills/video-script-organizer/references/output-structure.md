# Output Structure

## Main Response (to conversation)

```
## Vocabulary Guide

[one-term-per-line vocabulary list]

# 1. Transcript

[full transcript with **bolded** C1+ vocabulary]

---
*Mindmap file saved alongside source file:*
- `{input_filename}_mindmap.md`
- `{input_filename}_mindmap.html` (interactive, generated via `markmap` CLI)
```

## Generated Files (same directory as input)

| File | Content |
|------|---------|
| `{input_filename}_mindmap.md` | Detailed mindmap with CN annotations, readable as standalone article |
| `{input_filename}_mindmap.html` | Interactive mindmap (drag/zoom/collapse) generated via `markmap` CLI |
