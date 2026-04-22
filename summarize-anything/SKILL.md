---
name: summarize-anything
description: General-purpose summarization skill for articles, books, courses, meetings, interviews, project notes, work reports, stories, and reflection logs. Use when Codex needs to auto-pick PRISM, GIST, SAAC, 5W1H, SWBST, STAR, KPT, AAR, Gibbs, Progressive Summarization, or the Feynman Technique to produce one-line summaries, structured notes, reading notes, retros, action items, or archive-ready summaries.
---

# Summarize Anything

## Workflow

1. Confirm object, goal, audience, and length or format.
2. Pick one primary method by content type. Combine methods only when needed.
3. Extract facts, events, numbers, claims, and feelings before interpretation.
4. Output reusable structure: actions for retros, insights or questions for learning, results for reporting.
5. If the source is incomplete, mark `Known`, `Inferred`, and `Unknown`. Do not invent facts.

## Method Choice

- Respect a user-specified method.
- If the user only says “summarize” or the material is mixed, default to `PRISM`.
- Speed first: `GIST`, `SAAC`, `3-2-1`.
- Facts first: `5W1H`, `SAAC`, `STAR`.
- Retro or improvement first: `KPT`, `AAR`, `Gibbs`, `PRISM-FACT`.
- Learning or knowledge capture first: `Progressive Summarization`, `Feynman`, `SQ3R variant`.
- Storyline first: `SWBST`.
- Need finer mapping: read [references/method-map.md](./references/method-map.md).

## Output Defaults

- Default output when no format is given:
  1. One-line summary
  2. 3-5 key points
  3. Actions or insights when relevant
- Do not explain methodology unless the structure depends on it.
- Preserve names, numbers, dates, and causality.
- In retros, separate `Facts`, `Analysis`, `Conclusion`, and `Actions`.
- For rough notes, transcripts, or meeting raw text, deduplicate and rebuild the timeline first.

## Method Combos

- `PRISM + FACT` for project or work retros.
- `Progressive Summarization + Feynman` for books, courses, and concepts.
- `5W1H + SAAC` for information-heavy material.
- `KPT + 3-2-1` for lightweight weekly review.
- Do not stack 3+ methods without a clear reason.

## Resource Loading

- Read [references/method-map.md](./references/method-map.md) for method selection.
- Read [references/output-templates.md](./references/output-templates.md) for concrete structures.
- Read [references/source-index.md](./references/source-index.md) only when you need to trace back to the Chinese source docs.

## Trigger Examples

- “Summarize this article in one line and three bullets.”
- “Turn this meeting transcript into notes and action items.”
- “Write a retro for this project and give next-step actions.”
- “Explain this movie plot clearly without turning it into a review.”
- “Turn this book into archive-ready reading notes.”
