# deep-audit

**Systematic quality auditing for Claude Code.**

Takes your app from "it works on my machine" to genuinely ship-ready — by mapping every page, clicking every button, and testing every flow with a real browser.

![Claude Code](https://img.shields.io/badge/Claude_Code-skill-5A45FF?style=flat-square)
![Playwright MCP](https://img.shields.io/badge/Playwright_MCP-browser_testing-2EAD33?style=flat-square)
![13 Phases](https://img.shields.io/badge/13_phases-0→12-8B5CF6?style=flat-square)
![MIT License](https://img.shields.io/badge/license-MIT-gray?style=flat-square)

---

## What it does

deep-audit is a Claude Code skill that runs a phased quality audit of your entire application. It maps every page, route, API endpoint, and i18n key — then works through 13 specialized phases covering bugs, AI smell, UX flows, design, accessibility, security, and production readiness.

It uses Playwright MCP to actually interact with your app in a real browser: clicking buttons, filling forms, testing API endpoints, and taking screenshots as evidence. At the end, you get a proof gallery of every page for visual verification.

The audit maintains a living `AUDIT.md` report that persists across sessions, so you can pause and resume without losing progress.

---

## Phases

| Phase | Shortcut | What gets audited |
|:-----:|----------|-------------------|
| 0 | `inventory` | Map all pages, routes, APIs, i18n keys, integrations |
| 1 | `bugs` | Find and fix broken functionality |
| 2 | `smell` | Remove AI-generated code patterns and generic copy |
| 3 | `flow` | UX flow optimization — reduce clicks, simplify journeys |
| 4 | `ui` | UI Excellence — taste discovery, design directions, implementation |
| 5 | `buttons` | Click every button, test every form and API endpoint |
| 6 | `a11y` | Accessibility — keyboard nav, screen reader, contrast |
| 7 | `seo` | SEO, meta tags, Open Graph, social cards |
| 8 | `resilience` | Error handling, offline behavior, validation, rate limiting |
| 9 | `prod` | Images, performance, dependencies, responsive, env vars |
| 10 | `security` | Data isolation — can User A see User B's data? |
| 11 | `integrations` | Stripe, OAuth, email, webhooks |
| 12 | `consistency` | Terminology, copy tone, deploy checklist |

**Special modes:** `full` (all phases), `proof` (screenshot gallery), `checklist` (deploy checklist only)

---

## Installation

```bash
git clone https://github.com/pekka-lab/deep-audit ~/.claude/skills/deep-audit
```

That's it. Claude Code discovers skills automatically from `~/.claude/skills/`.

**Or use the install script:**

```bash
curl -fsSL https://raw.githubusercontent.com/pekka-lab/deep-audit/main/install.sh | bash
```

### Requirements

- [Claude Code](https://claude.ai/code) — the CLI tool by Anthropic
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) — needed for real browser interaction (testing, screenshots, proof gallery)

---

## Usage

**Run a full audit:**
```
/deep-audit
```

**Run specific phases:**
```
/deep-audit inventory       # Phase 0:  map every page, route, API
/deep-audit bugs            # Phase 1:  fix broken functionality
/deep-audit smell           # Phase 2:  remove AI patterns from code + UI
/deep-audit flow            # Phase 3:  optimize UX flows, reduce clicks
/deep-audit ui              # Phase 4:  taste discovery + UI redesign
/deep-audit buttons         # Phase 5:  test every button, form, endpoint
/deep-audit a11y            # Phase 6:  accessibility audit
/deep-audit seo             # Phase 7:  SEO, meta tags, social cards
/deep-audit resilience      # Phase 8:  error handling, validation
/deep-audit prod            # Phase 9:  performance, images, responsive
/deep-audit security        # Phase 10: data isolation between users
/deep-audit integrations    # Phase 11: Stripe, OAuth, email, webhooks
/deep-audit consistency     # Phase 12: terminology, copy tone, deploy checklist
```

**Combine phases:**
```
/deep-audit smell flow      # Clean up AI patterns, then optimize UX
/deep-audit a11y seo        # Accessibility + SEO pass
/deep-audit security prod   # Security + production readiness
```

When run without arguments, you get an interactive menu to pick what to audit.

---

## Key Features

- **Real browser testing** — Uses Playwright MCP to click buttons, fill forms, and verify behavior. Not just code reading.
- **Living AUDIT.md** — Quality scorecard that persists across sessions. Resume where you left off.
- **3-attempt rule** — Never loops endlessly. Three fix attempts per issue, then logs as `NEEDS_HUMAN` and moves on.
- **Proof gallery** — Before claiming any score, generates a visual gallery of every page for your own verification.
- **Watchover mode** — Install once, and it monitors quality throughout development. Catches regressions before they pile up.

---

## How It Works

deep-audit is an orchestrator. Each phase builds on the last: the inventory feeds the bug hunt, cleaned-up flows inform the UI redesign, and interactive testing verifies everything actually works.

Every fix follows a strict protocol:
1. Screenshot the broken state
2. Fix it (up to 3 attempts with different strategies)
3. Screenshot the fixed state
4. Log everything in AUDIT.md

The audit enforces a **9/10 quality gate** — it's not "done" until automated checks pass AND you've reviewed the proof gallery with your own eyes.

---

## The 9/10 Standard

| Score | Meaning |
|:-----:|---------|
| 10/10 | Everything works, polished, no AI smell, edge cases handled |
| 9/10 | **Ship-ready.** Minor issues only. |
| 8/10 | Not acceptable. Visible problems remain. |
| 7/10 | Run a full audit immediately. |

The audit does not complete until 9/10 is reached — or remaining issues are explicitly logged as `NEEDS_HUMAN` with clear instructions.

---

## File Structure

```
deep-audit/
├── SKILL.md                     # The main skill definition
├── install.sh                   # One-command installer
└── references/
    ├── ai-smell-code.md         # 10 code patterns AI leaves behind
    ├── ai-smell-ui.md           # 10 UI/copy patterns to fix
    ├── audit-checklist.md       # Per-page, per-API, per-i18n checklists
    ├── audit-doc-template.md    # AUDIT.md template
    ├── design-discovery.md      # Taste discovery process
    ├── inventory-checklist.md   # How to map the full app
    ├── phases-audit.md          # Detailed instructions for Phases 6-12
    ├── ui-excellence.md         # From vibecoded to wow
    └── ux-flows.md              # UX flow optimization methodology
```

---

## Output

When run, deep-audit creates these files in your project:

| File | Purpose |
|------|---------|
| `AUDIT.md` | Living quality report with scores, issues, and progress |
| `.deep-audit/screenshots/` | Evidence screenshots for every page and fix |
| `.deep-audit/proof-gallery.html` | Visual gallery for final verification |
| `.deep-audit/design-concepts/` | HTML mockups when running the UI phase |
| `DEPLOY-CHECKLIST.md` | Project-specific deployment checklist |

---

## License

MIT

---

Built for use with [Claude Code](https://claude.ai/code) by Anthropic.
