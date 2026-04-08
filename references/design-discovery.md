# Design Discovery: Finding the User's Taste

The user knows great design when they see it but can't always describe it in words.
That's normal — most people are like this. The skill's job is to help them discover
and articulate their taste through showing, not asking.

---

## DESIGN-DNA.md — Personal Design Profile

Location: `~/.claude/DESIGN-DNA.md` (global, not per-project)

This file accumulates the user's design preferences over time. It's built from
their reactions to real designs across all projects. Every time the user picks a
direction, likes something, or rejects something, update this file.

### Initial creation

If `~/.claude/DESIGN-DNA.md` doesn't exist, create it during the first design phase.
Start with the taste discovery process below, then save the results.

### Format

```markdown
# Design DNA

## Sites I love
- apple.com — clean, spacious, dramatic hero sections, premium feel
- linear.app — dark mode, precise, keyboard-first, no clutter
- stripe.com — warm, approachable, beautiful gradients, great illustrations

## Sites I don't like
- (filled in over time as user rejects things)

## My preferences
- Layout: [spacious / dense / mixed]
- Color mood: [dark & moody / light & airy / warm & friendly / bold & vibrant]
- Animation level: [dramatic / subtle / minimal]
- Typography: [clean sans-serif / distinctive / playful]
- Overall vibe: [premium / playful / minimal / bold]
- Corners: [sharp / slightly rounded / very rounded]
- Shadows: [flat / subtle depth / dramatic depth]

## Things I always want
- (accumulated from feedback, e.g., "always use dark mode first")
- (e.g., "hero sections should be full-width with large imagery")
- (e.g., "never use generic stock illustrations")

## Things I never want
- (e.g., "no three-column feature grids")
- (e.g., "no gradient text")
- (e.g., "no emojis in headings")

## Design decisions from past projects
- [Project A]: chose Direction B (bold & dynamic), user said "more like Vercel dashboard"
- [Project B]: chose mix of A and C, user wanted "Linear but warmer"
```

### Using the DNA

Before generating any design direction:
1. Read `~/.claude/DESIGN-DNA.md` if it exists
2. Use the preferences as the starting point for all 3 directions
3. Never propose directions that contradict "Things I never want"
4. Always incorporate "Things I always want"
5. Reference the user's liked sites as anchors

---

## Taste Discovery Process

Run this BEFORE generating design directions, especially if DESIGN-DNA.md doesn't
exist yet or has very little in it.

### Step 1: Build an inspiration board

Instead of asking "what style do you want?", SHOW the user real sites and let them
react. Create an HTML file with screenshots/embeds of 8-10 real sites spanning
different styles.

Use Playwright to screenshot these reference sites (or use `browser_navigate` to
open them in tabs for the user to browse):

**Premium / Apple-style:**
- apple.com — spacious, dramatic, product-focused
- porsche.com — luxury, dark, cinematic
- bang-olufsen.com — minimal, premium materials

**Modern SaaS / Tool:**
- linear.app — precise, dark, keyboard-first
- vercel.com — clean, developer-focused, great dark mode
- raycast.com — bold, dynamic, powerful feel

**Warm / Approachable:**
- stripe.com — friendly, great gradients, illustrations
- cal.com — clean, open source feel, approachable
- notion.so — simple, content-focused, playful touches

**Bold / Creative:**
- framer.com — animated, creative, pushes boundaries
- liveblocks.io — modern, interactive, glass effects

Save as `.deep-audit/inspiration-board.html`:
```html
<!-- Simple grid of site thumbnails with names -->
<!-- Each thumbnail links to the actual site -->
<!-- User can click through and browse -->
```

Open the inspiration board AND open 3-4 of the actual sites in browser tabs:
```bash
open .deep-audit/inspiration-board.html
```

Ask the user:
"I've opened some reference sites. Browse through them and tell me which ones
feel closest to what you want. Even just 'I like the vibe of X' or 'definitely
not like Y' helps me dial in the direction."

**STOP and wait.** Let them browse. Don't rush this part.

### Step 2: Extract the taste signal

From the user's reaction, identify:
- Which sites they liked → what do those sites have in common?
- Which sites they rejected → what should we avoid?
- Specific elements they called out ("I like the animations on framer.com")
- The overall mood (premium, playful, minimal, bold, etc.)

Update DESIGN-DNA.md with what you learned.

### Step 3: Generate directions anchored to references

Now generate 3 directions, but anchor each one to the sites the user liked:

Instead of:
- Direction A: "Clean & Minimal"
- Direction B: "Bold & Dynamic"

Do this:
- Direction A: "Apple meets Linear — spacious layout, dark mode, precise typography,
  dramatic hero with your product front and center"
- Direction B: "Stripe's warmth with Vercel's structure — friendly colors, subtle
  gradients, clean dashboard layout, approachable but professional"
- Direction C: "Framer's energy toned down — scroll animations, glass effects,
  dynamic elements, but not overwhelming"

Each direction should reference specific things from the sites the user liked.
This makes the choice much easier than picking between abstract concepts.

---

## When the User Can't Choose

Sometimes none of the 3 directions feel right. That's fine.

Ask: "What's missing? Or is there a site you've seen recently that had the right feel?"

If they name a new reference site:
1. Open it with Playwright
2. Screenshot key pages
3. Analyze what makes it work (colors, spacing, typography, motion, layout)
4. Generate a new direction based on that specific reference
5. Update DESIGN-DNA.md

If they can't name anything specific:
1. Show them 2-3 more reference sites in a different style range
2. Ask "closer to this or further from this?" for each
3. Narrow down through elimination

The goal is to never loop on abstract preferences. Always ground the conversation
in real, visible examples.

---

## When the Design Goes in a Loop

If the user keeps saying "not quite right" after multiple iterations:

1. Take a screenshot of the current state
2. Open 2-3 of their liked reference sites side by side
3. Ask specifically: "Looking at [reference site] and then at your app — what
   feels different? Is it the spacing, the colors, the typography, the motion,
   or something else?"

This forces a concrete comparison instead of vague "it's not right" feedback.
Narrow down to a SPECIFIC dimension, fix that one thing, and re-check.

---

## Accumulating Taste Over Time

Every time a design decision is made, update DESIGN-DNA.md:
- What was chosen and why
- What was rejected and why
- Any specific feedback ("make it more spacious", "darker background")

After 3-4 projects, the DNA file becomes a reliable taste profile and design
direction generation gets much more accurate. The first project is the hardest.
