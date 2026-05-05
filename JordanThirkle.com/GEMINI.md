# GEMINI.md

<!--
  WHAT THIS FILE IS:
  The single source of truth you paste at the start of every AI session.
  It tells the model who it is, what the project is, and how to behave.
  It is NOT a README. It is NOT documentation for humans.
  Every word here costs context tokens. Earn your place or get cut.

  WHAT THIS FILE IS NOT:
  - A philosophy essay
  - A place to congratulate yourself on having a good system
  - Self-referential meta-commentary (irony noted, this comment block is the only exception)

  HOW TO MAINTAIN IT:
  - Update PROJECT_STATUS.md after every session, not this file.
  - Only edit GEMINI.md when architecture, tooling, or workflow changes.
  - If a section hasn't changed in 2 weeks, ask whether it belongs here at all.
-->

---

## 1. Session Bootstrap

<!--
  This section is read FIRST. It must orient the model in under 10 seconds.
  No fluff. Stack rank: what matters most goes first.
  The model needs to know: what is this, what am I doing, what are my constraints.
-->

**Project**: Personal site — Astro 6 + React Islands  
**Owner**: Solo dev ("Architect-Dad"). One person. Decisions are final unless challenged with a reason.  
**Current phase**: Phase 2 Completion / Pre-Deployment Hardening  
**Next hard milestone**: Vercel deployment — 2026-04-25  
**Status file**: Always read `PROJECT_STATUS.md` after this file. That file has current state. This file has rules.

---

## 2. Stack & Constraints

<!--
  Keep this to facts the model cannot infer from the codebase.
  If it's obvious from package.json, don't repeat it here — you're wasting tokens.
  What belongs here: decisions that aren't obvious, and the WHY behind them.
-->

| Layer | Choice | Why it matters to you |
|---|---|---|
| Framework | Astro 6 | Rust build pipeline — do not suggest webpack or vite workarounds |
| UI | React Islands only | Not full React SPA. Don't add client-side state where it isn't needed |
| Styling | Tailwind + `clamp()` fluid typography | No arbitrary px values. Use fluid scales |
| Fonts | Astro Fonts | Already handled. Don't add Google Fonts `<link>` tags |
| OG Images | Satori pipeline (local fonts) | Automated. Do not hand-craft OG images |
| Deploy | Vercel | `npm run build` must pass before any commit. Not negotiable |

<!--
  WHY A TABLE INSTEAD OF PROSE:
  The model scans tables faster than paragraphs for factual lookups.
  Each row answers "what + why" in one line.
  If you can't justify a row's "why", the technology choice needs re-examining.
-->

---

## 3. Architectural Decisions (ADR Log)

<!--
  This is the single most important section for preventing the model
  from "helpfully" suggesting you undo a decision you already made deliberately.

  FORMAT RULES:
  - Date + decision + reason. Three things. Nothing else.
  - Newest first. Oldest entries get pruned after 60 days if superseded.
  - If a decision was reversed, strike it through and note why: ~~old~~ → new

  DO NOT add ADRs for things that are just "using the framework normally".
  Only log decisions where a reasonable engineer might have gone a different way.
-->

| Date | Decision | Rationale |
|---|---|---|
| 2026-04-25 | Migrated to Astro 6 | Rust build performance; Astro 5 slower on large content collections |
| 2026-04-25 | Tiered crawler strategy in `robots.txt` | GEO (Generative Engine Optimisation) — AI crawlers get selective access |
| 2026-04-25 | Centered UI headers site-wide | Symmetrical Authority aesthetic — intentional, not an oversight |
| 2026-04-25 | Satori OG pipeline with local fonts | Avoids runtime font fetching; consistent renders across Vercel edge |
| 2026-04-25 | Dev Log as vertical timeline with timestamps | Readability over density; matches "Architect-Dad" brand voice |

---

## 4. Commit Protocol

<!--
  This section governs how every single commit is structured.
  The model must follow this WITHOUT being reminded every session.

  WHY CONVENTIONAL COMMITS:
  - Machine-parseable for changelog automation later (standard-version, semantic-release)
  - Enforces atomic thinking BEFORE writing code, not after
  - Makes git blame genuinely useful six months from now

  THE GOLDEN RULE:
  One logical change per commit. If you can't write a single-line subject,
  the commit is too big. Split it.
-->

### Format

```
<type>(<scope>): <imperative verb> <what changed>

[optional body: WHY this change, not WHAT — the diff shows what]

[optional footer: BREAKING CHANGE: <detail> | Closes #<issue>]
```

### Types

<!--
  Only the types that actually apply to this project are listed.
  Removed: test (no test suite yet), ci (no pipeline yet).
  Add them back when they become real, not aspirational.
-->

| Type | Use for |
|---|---|
| `feat` | New feature or meaningful UI addition |
| `fix` | Bug or structural correction |
| `refactor` | Code change with no behaviour difference |
| `style` | Whitespace, formatting, no logic changes |
| `perf` | Measurable performance improvement |
| `docs` | Documentation only |
| `chore` | Deps, config, build tooling |

### Scopes

`ui` · `content` · `navbar` · `og` · `deps` · `build` · `devlog` · `seo` · `layout`

<!--
  ADD scopes here as new areas of the codebase emerge.
  REMOVE scopes when a feature area is complete and unlikely to change.
  Stale scopes in the list are noise.
-->

### Rules (non-negotiable)

1. Subject line ≤ 72 characters
2. Imperative mood — "add", "fix", "remove", "refactor" (not "added", "fixes", "removed")
3. `npm run build` passes before every commit. No exceptions.
4. No lint or TypeScript errors in committed code
5. `PROJECT_STATUS.md` updated in the same commit if task status changed
6. Breaking changes use `feat!:` or include `BREAKING CHANGE:` in footer

### The "Commit the work" trigger

<!--
  When the user says "Commit the work", this is the exact sequence.
  No improvising. No asking clarifying questions first.
  Infer the type/scope from what was just done.
-->

```bash
# 1. Stage everything
git add .

# 2. Commit with inferred conventional message
git commit -m "<type>(<scope>): <what you just built>"

# 3. Push
git push
```

---

## 5. AI Behaviour Rules

<!--
  This section changes how the model operates, not what it builds.
  These are hard constraints, not suggestions.
  Written as imperatives because soft language ("try to", "aim to") gets ignored.

  WHY THIS SECTION EXISTS:
  Without it, the model will: hallucinate file contents, make sweeping refactors
  without asking, produce commits that bundle unrelated changes, and generate
  confident-sounding but wrong explanations for decisions it didn't witness.
-->

**Before touching any file:**
- Read the relevant file(s) first. Do not infer contents from filename alone.
- If a change affects more than one logical area, flag it and ask whether to split.

**Before any architectural or structural change:**
- State the plan in plain English.
- Wait for explicit confirmation before writing code.
- "I think this would be better if..." is a proposal, not a mandate.

**During implementation:**
- Make the smallest change that solves the problem.
- Do not refactor unrelated code in the same pass.
- Do not add dependencies without flagging them and stating the reason.

**After every major task:**
- Update `PROJECT_STATUS.md` (blocked items, completed items, next up).
- Propose the commit message. Do not commit unilaterally unless told "Commit the work".

**Never:**
- Hallucinate file paths or contents
- Silently change behaviour while "fixing" something else
- Add TODOs to code without immediately raising them as blockers in `PROJECT_STATUS.md`
- Suggest a rewrite when a targeted fix will do

---

## 6. Definition of Done

<!--
  A task is not done until ALL of these are true. Not most. All.
  If any item can't be checked, the task is still open.

  WHY THIS IS HERE AND NOT IN PROJECT_STATUS.md:
  This is a rule, not a status. Rules live in GEMINI.md.
  Status lives in PROJECT_STATUS.md. Keep the two concerns separated.
-->

- [ ] `npm run build` exits clean
- [ ] No TypeScript errors (`tsc --noEmit`)
- [ ] No ESLint errors or warnings
- [ ] Tested locally on mobile viewport and desktop viewport
- [ ] OG image renders correctly (if SEO metadata was touched)
- [ ] `PROJECT_STATUS.md` updated
- [ ] Atomic commit with valid Conventional Commit message pushed

---

## 7. Tech Debt Register

<!--
  Known debt lives here, not scattered in code comments.
  Format: item + severity (High / Med / Low) + owner (you, deferred, blocked-on-X).
  Items with no owner and no date get deleted at the next session — they're wishes, not debt.

  SEVERITY GUIDE:
  High   = blocks deployment or causes user-facing bugs
  Med    = degrades quality or will compound if ignored
  Low    = cosmetic or nice-to-have
-->

| Item | Severity | Notes |
|---|---|---|
| Replace placeholder images in `public/projects/` | High | Blocks polish pass; deployment can proceed but embarrassing |

<!--
  Add new items during sessions. Review and prune at the start of each sprint.
  If something stays at "Low" for 3 sprints, either do it or delete it.
-->
