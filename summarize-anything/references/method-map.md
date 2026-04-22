# Method Map

## Priority

1. Use the method explicitly requested by the user.
2. Otherwise pick the closest single method by content type.
3. Use `PRISM` as the fallback.

## By Scenario

| Scenario | Primary | Backup | Focus |
|----------|---------|--------|-------|
| Article, report, non-fiction text | `SAAC` | `5W1H`, `GIST` | Core idea, key detail, source |
| News, notice, event, meeting notes | `5W1H` | `SAAC` | Who, what, when, where, why, how |
| Story, film plot, narrative case | `SWBST` | `SAAC` | Character, goal, conflict, response, ending |
| Work example, project result, interview case | `STAR` | `PRISM-FACT` | Situation, task, action, result |
| Weekly review, light reflection | `KPT+` | `3-2-1` | Keep, problem, try, next step |
| Project, event, retrospective | `AAR` | `PRISM-FACT` | Plan, actual, gap, lesson, action |
| Deep personal reflection | `Gibbs` | `KPT+` | Description, feelings, evaluation, analysis, plan |
| Reading notes, course notes, knowledge capture | `Progressive Summarization` | `SQ3R`, `Feynman` | Compression, retell, links, reuse |
| Concept understanding or explanation | `Feynman` | `GIST` | Plain-language explanation, blind spots |
| Year-end or broad work report | `Six Work Summary Angles` | `STAR`, `PRISM-FACT` | Organization, highlights, impact, next plan |
| User only says “summarize” or gives mixed material | `PRISM` | `AAR`, `KPT+` | End-to-end structure from goal to action |

## By Length

| Target Length | Prefer | Use For |
|---------------|--------|---------|
| 1 sentence | `GIST` | Extreme compression |
| 1 paragraph | `SAAC`, `SWBST` | Short summary |
| 3-6 bullets | `5W1H`, `3-2-1` | Notes, class recap, light review |
| Structured report | `STAR`, `AAR`, `KPT+`, `Gibbs` | Reporting, retros, reflection |
| Full summary loop | `PRISM-FACT` | Complex or archive-ready output |

## Useful Combos

- `PRISM + FACT` for project or work retros.
- `Progressive Summarization + Feynman` for books, courses, and concepts.
- `5W1H + SAAC` for information-dense material.
- `KPT + 3-2-1` for low-cost weekly review.

## Avoid

- Do not use `SWBST` for non-narrative material.
- Do not force `Gibbs` without subjective or emotional input.
- Do not use `KPT` alone for a large project retro.
- Do not output only `GIST` when full context matters.
- Do not stack methods without clear roles.
