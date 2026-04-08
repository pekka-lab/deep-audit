# Phases 6-12: Accessibility, SEO, Resilience, Production, Security, Integrations, Consistency

Detailed instructions for the later phases of a deep audit.
Read this file when entering Phase 6.

---

## Phase 6: Accessibility

Goal: Make the app usable for everyone, not just mouse users on a desktop.

This is non-negotiable for a professional product. Many markets have legal requirements
for accessibility (WCAG 2.1 AA). Even if you don't care about the law, 15% of the
world's population has some form of disability.

### 12a: Keyboard Navigation
- **Tab through every page** — can you reach all interactive elements with Tab alone?
- **Is the focus visible?** Every focused element needs a clear visual indicator (ring, outline)
- **Tab order logical?** Does focus move left-to-right, top-to-bottom, or does it jump around?
- **Can you activate everything?** Enter/Space should activate buttons, Enter should submit forms
- **Escape closes modals/drawers?** Standard expectation, often broken
- **No keyboard traps** — can you always Tab OUT of any component?

Test using Playwright: `browser_press_key` with Tab, Enter, Escape, Arrow keys.

### 12b: Screen Reader Basics
- **Alt text on all images** — `<img>` without alt is invisible to screen readers
- **ARIA labels on icon buttons** — a button with just an icon needs `aria-label`
- **Form labels** — every input needs a connected `<label>` or `aria-label`
- **Heading hierarchy** — h1 → h2 → h3, no skipping levels, one h1 per page
- **Landmark regions** — main, nav, aside should use semantic HTML or ARIA roles

Scan with: `grep -rn "aria-\|role=" --include="*.tsx"` to see what exists,
and `grep -rn "<img" --include="*.tsx" | grep -v "alt="` to find missing alt text.

### 12c: Color Contrast
- **Text contrast ratio** — minimum 4.5:1 for body text, 3:1 for large text
- **Don't rely on color alone** — error states need icons or text, not just red
- **Check dark mode contrast too** — often forgotten
- Test by evaluating in browser: use CSS `filter: grayscale(100%)` to check
  if information is still conveyed without color

### 10d: Motion & Vestibular
- **`prefers-reduced-motion`** — all animations should respect this media query
- Users with vestibular disorders get motion sick from animations
- Check: `grep -rn "prefers-reduced-motion" --include="*.css" --include="*.tsx"`
  If zero results and the app has animations, this needs fixing

---

## Phase 7: SEO, Meta & Social Presence

Goal: Make the app look professional when shared, indexed, and bookmarked.

### 12a: Meta Tags & SEO
For every public page (not behind auth):
- **Title tag** — unique per page, descriptive, under 60 characters
- **Meta description** — unique per page, under 160 characters
- **Canonical URL** — set correctly
- **robots.txt** — exists and makes sense (not blocking important pages)
- **sitemap.xml** — exists if the app has public pages

Scan with:
```bash
# Check which pages set metadata
grep -rn "metadata\|generateMetadata\|<title\|<meta" --include="*.tsx" --include="*.ts" app/
```

### 12b: Open Graph & Social Cards
When someone pastes the app link into Slack, LinkedIn, Twitter, or iMessage,
it should show a nice preview — not a blank card.

- **og:title** — set per page
- **og:description** — set per page
- **og:image** — exists and looks good (1200x630px recommended)
- **twitter:card** — set to "summary_large_image" for best preview

Test by navigating to each public page and checking the `<head>`:
```javascript
// Via browser_evaluate
const metas = document.querySelectorAll('meta[property^="og:"], meta[name^="twitter:"]');
return Array.from(metas).map(m => ({
  name: m.getAttribute('property') || m.getAttribute('name'),
  content: m.getAttribute('content')
}));
```

### 12c: Favicon & App Identity
- **Favicon** — exists, loads, not the default Next.js icon
- **Apple touch icon** — for iOS home screen bookmarks
- **manifest.json / site.webmanifest** — app name, colors, icons for PWA
- **Theme color** — browser tab color matches the brand

### 10d: Link Preview Test
For the most important pages (home, signup, pricing if public):
- Check the meta tags manually
- Screenshot what the social preview would look like

---

## Phase 8: Resilience & Error Handling

Goal: The app should handle everything gracefully, not just the happy path.

### 12a: Error Boundaries
- **Does the app have error boundaries?** Check for `error.tsx` files in Next.js app dir
- **What happens when a component crashes?** Navigate to a page and use `browser_evaluate`
  to intentionally throw an error — does the app show a useful fallback or a white screen?
- **Is the error page branded?** Default Next.js error page = unprofessional

### 12b: Custom 404 Page
- Navigate to a URL that doesn't exist (e.g., `/this-page-does-not-exist`)
- Screenshot it. Is it a custom page that matches the app's design?
- Does it link back to home or suggest alternatives?
- Or is it the default Next.js 404?

### 12c: Offline & Network Errors
- What happens when an API call fails mid-use?
  Use `browser_evaluate` to intercept fetch and simulate a failure:
  ```javascript
  // Save original fetch, then break it
  window.__originalFetch = window.fetch;
  window.fetch = () => Promise.reject(new Error('Network error'));
  ```
  Then interact with the app. Does it show a useful error, or does it just hang?
  Restore: `window.fetch = window.__originalFetch;`

### 10d: Data Validation Parity
- For each form: submit valid data via the UI → note what gets accepted
- Then send the same fields but with edge case data directly to the API:
  - Empty strings where required
  - Very long strings (10000+ chars)
  - HTML/script tags (`<script>alert('xss')</script>`)
  - SQL-like input (`'; DROP TABLE users;--`)
  - Unicode edge cases (emoji, RTL text, zero-width characters)
- Backend should reject invalid data the same way frontend does
- Backend should NEVER return 500 for bad input — always 400

### 9e: Rate Limiting
- For sensitive endpoints (login, signup, password reset, contact forms):
  Send 20 rapid requests with `browser_evaluate`:
  ```javascript
  const results = [];
  for (let i = 0; i < 20; i++) {
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({email: 'test@test.com', password: 'wrong'})
    });
    results.push(res.status);
  }
  return results;
  ```
  If all 20 return 401 (not 429), there's no rate limiting. Log it.

---

## Phase 9: Production Readiness

Goal: Everything that separates "works on my machine" from "ready for real users."

### 12a: Image Optimization
- **`next/image` usage** — grep for `<img` vs `<Image` from next/image
  Every `<img>` should be replaced with `<Image>` for automatic optimization
- **Image sizes** — are images larger than needed? Check for 5MB hero images
- **Missing width/height** — causes layout shift (CLS)
- **Lazy loading** — below-the-fold images should be `loading="lazy"` or use
  next/image's default lazy loading

```bash
# Find raw img tags (should use next/image instead)
grep -rn "<img " --include="*.tsx" --include="*.jsx" | grep -v "node_modules"
```

### 12b: Performance Basics
- **Page load time** — use `browser_evaluate` to measure:
  ```javascript
  const timing = performance.getEntriesByType('navigation')[0];
  return {
    domContentLoaded: Math.round(timing.domContentLoadedEventEnd),
    loadComplete: Math.round(timing.loadEventEnd),
    firstPaint: Math.round(performance.getEntriesByType('paint')
      .find(p => p.name === 'first-contentful-paint')?.startTime || 0)
  };
  ```
- **Bundle size concerns** — check for large imports:
  ```bash
  # Large dependencies that should be dynamically imported
  grep -rn "import.*from ['\"]moment\|import.*from ['\"]lodash['\"]" --include="*.ts" --include="*.tsx"
  ```
- **Dynamic imports** — heavy components should use `next/dynamic` or `React.lazy`

### 12c: Console Cleanliness
- **Zero errors** — already covered, but recheck after all fixes
- **Zero warnings** — React warnings about missing keys, deprecated APIs,
  development-only warnings that would clutter production
- **No console.log** — already covered in Phase 2, but verify again

### 10d: Dependency Health
```bash
# Check for known vulnerabilities
npm audit --production 2>/dev/null || pnpm audit --production 2>/dev/null
# Check for outdated packages
npm outdated 2>/dev/null || pnpm outdated 2>/dev/null
```
- Critical/high vulnerabilities need fixing
- Major version outdated on core framework (Next.js, React) — flag it

### 9e: Environment Variables
- **Are all required env vars documented?** Check `.env.example` or `.env.local.example`
- **Are any secrets exposed to the client?** NEXT_PUBLIC_ vars are visible to everyone
  Scan: `grep -rn "NEXT_PUBLIC_.*SECRET\|NEXT_PUBLIC_.*KEY\|NEXT_PUBLIC_.*PASSWORD" .env*`
- **Production vs development parity** — are there env vars only set in dev?

### 9f: Viewport & Responsive Testing
Test at these breakpoints (not just mobile and desktop):
- **375px** — iPhone SE / small phones
- **390px** — iPhone 14 / standard phones
- **768px** — iPad / tablets
- **1024px** — small laptops
- **1440px** — standard desktop
- **1920px** — large desktop

For each breakpoint: resize with Playwright, screenshot key pages.
Check for: horizontal scrollbars, overlapping text, cut-off content, tiny tap targets.

### 9g: i18n Completeness
- Compare key counts across language files
- Flag keys missing in non-primary languages
- Flag keys with placeholder values (empty, "TODO", "FIXME")
- Grep for hardcoded strings in components that should use i18n
- Check that longer translations (German, Finnish) don't break layouts
- Date/time/number formatting uses locale-aware formatters

---

## Phase 10: Authorization & Data Isolation

Goal: Make sure users can't see each other's data. This is the #1 security hole
in AI-built apps because AI often skips row-level security or writes incomplete policies.

### 12a: Multi-User Data Isolation

This is the most important test in the entire phase. If the app has user accounts,
test whether User A can access User B's data.

**Setup:** You need two test accounts. If the app has a signup flow, create two.
If it uses Supabase auth, you can create test users directly.

**Test procedure for each data type** (projects, posts, settings, files, etc.):

1. Log in as User A
2. Create a test item (project, post, whatever the app stores)
3. Note the item's ID (from the URL or from `browser_evaluate`)
4. Log out, log in as User B
5. Try to access User A's item directly:
   - Via URL: navigate to `/items/[user-a-item-id]`
   - Via API: `fetch('/api/items/[user-a-item-id]')`
   - Via list: does User A's item appear in User B's list?
6. If User B can see/edit User A's data → CRITICAL security issue

Log in AUDIT.md:

```markdown
### Data Isolation Test

| Data type | User A creates | User B can see? | User B can edit? | Status |
|-----------|---------------|-----------------|------------------|--------|
| Projects  | project-123   | No              | No               | pass   |
| Documents | doc-456       | YES via API     | YES              | CRITICAL |
```

### 12b: Supabase RLS Policies (if applicable)

Check that Row Level Security is enabled and correct:

```sql
-- Via execute_sql or browser_evaluate + supabase client
-- Check which tables have RLS enabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public';
```

For each table where `rowsecurity = false`:
- Is it intentionally public? (e.g., a lookup table with no user data)
- Or is it missing RLS? → CRITICAL

For each table WITH RLS, check the policies make sense:
```sql
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE schemaname = 'public';
```

Common AI mistakes:
- Policy uses `auth.uid()` but the column is called `user_id`, not `id`
- SELECT policy exists but UPDATE/DELETE don't (can read but also accidentally delete)
- Policy is `true` (allows everything) — same as no RLS
- INSERT policy doesn't set `user_id` to `auth.uid()` (user can insert as another user)

### 12c: Protected Routes

For every page marked "Auth: Yes" in the inventory:
1. Open an incognito/private browser (or clear cookies)
2. Navigate directly to the page URL
3. Expected: redirect to login page
4. If the page loads with data → auth bypass, CRITICAL
5. If the page loads but empty → might still leak layout/structure

### 10d: API Route Auth

For every API route marked "Auth: Yes":
1. Call it without an auth token:
   ```javascript
   const res = await fetch('/api/protected-route', {
     headers: {} // no auth
   });
   return res.status; // should be 401, not 200 or 500
   ```
2. If it returns 200 with data → CRITICAL
3. If it returns 500 → bad but less critical (still leaks it exists)

---

## Phase 11: Third-Party Integrations & Email

Goal: Verify that external services actually work, not just that the code references them.

### 12a: Integration Health Check

For each integration found in the inventory:

**Stripe (if present):**
- Is the webhook endpoint configured? Check `app/api/webhooks/stripe/`
- Does the webhook verify the signature? (grep for `stripe.webhooks.constructEvent`)
- Are you using test keys in dev and live keys in prod? Check env vars
- Do the product/price IDs in the code match what's in the Stripe dashboard?
- Test: trigger a test webhook event (if test mode)

**OAuth / Social Login (if present):**
- Are callback URLs configured correctly for BOTH dev and prod?
- Common mistake: callback URL points to `localhost:3000` in production
- Test: actually complete the OAuth flow, don't just check the config
- Check: what happens if the user denies OAuth permission? (usually broken)

**Email service (Resend, SendGrid, etc.):**
- Is the API key set in production env vars?
- Is the sender domain verified?
- Is the FROM address something professional (not `onboarding@resend.dev`)?

**File storage (Supabase Storage, Uploadthing, etc.):**
- Can you upload a file? Download it? Delete it?
- Are bucket policies correct? (public vs private)
- What happens with large files? (test with a 10MB file)
- What happens with wrong file types? (upload a .exe if only images are expected)

### 12b: Email Audit

If the app sends emails, test EVERY email type:

1. **List all email triggers** — signup, password reset, invitation, notification, etc.
2. **Trigger each one** and check:
   - Does the email arrive? (check spam folder too)
   - FROM name/address — professional? Not `noreply@vercel.app`?
   - Subject line — clear and specific? Not "Notification from [App Name]"?
   - Email body — styled? Readable? Or raw text / broken HTML?
   - Links in email — do they actually work? Do they point to the right domain?
   - Unsubscribe link — present if required by law?
   - Mobile rendering — does it look OK on a small screen?

3. **If emails look generic/ugly**: suggest email templates.
   Most email services have template builders. A styled email with the app's logo
   and colors takes 30 minutes to set up and makes a huge difference.

Log in AUDIT.md:

```markdown
### Email Audit

| Email type | Triggers? | FROM address | Styled? | Links work? | Status |
|------------|-----------|--------------|---------|-------------|--------|
| Welcome    | Yes       | hello@app.com| Yes     | Yes         | pass   |
| Reset pwd  | Yes       | noreply@resend.dev | No | Yes      | FAIL — wrong sender |
| Invite     | No        | —            | —       | —           | FAIL — never sends |
```

### 12c: Webhook Verification

For any incoming webhooks (Stripe, GitHub, etc.):
1. Is the webhook signature verified? (prevents fake webhook attacks)
2. Is the webhook endpoint idempotent? (handles duplicate delivery)
3. Does it return 200 quickly? (don't do heavy processing in the handler)

---

## Phase 12: Terminology, Copy Consistency & Post-Audit

Goal: Make the app speak with one voice, and leave the user with tools for the future.

### 12a: Terminology Audit

AI uses different words for the same concept across the app. This makes the product
feel like it was assembled by different people who never talked to each other.

**Scan for common inconsistencies:**

```bash
# Find all user-visible strings
grep -rn "\".*\"" --include="*.tsx" --include="*.json" app/ messages/ | \
  grep -iv "import\|from\|require\|console\|className"
```

**Common AI terminology splits:**
| Concept | Variations to check |
|---------|-------------------|
| Sign up | "Sign up", "Register", "Create account", "Get started", "Join" |
| Log in | "Log in", "Sign in", "Login", "Sign-in" |
| Delete | "Delete", "Remove", "Discard", "Trash" |
| Save | "Save", "Submit", "Apply", "Confirm", "Update" |
| Cancel | "Cancel", "Dismiss", "Close", "Back", "Never mind" |
| Settings | "Settings", "Preferences", "Configuration", "Options" |
| Project | "Project", "Workspace", "Space", "Organization", "Team" |
| User | "User", "Member", "Account", "Profile" |

For each concept: pick ONE term and use it everywhere. Add the chosen terminology
to AUDIT.md and to the project's CLAUDE.md so future development stays consistent.

### 12b: Copy Tone Consistency

Read through all user-facing text and check:
- Is the tone the same everywhere? (not formal on settings, casual on home)
- Is it first person (your/you) or third person (the user) — pick one
- Are error messages in the same voice as success messages?
- Do tooltips match the formality of the rest of the UI?

### 12c: Date/Time/Number Formatting

```bash
# Find all date formatting
grep -rn "toLocaleDateString\|format(\|dayjs\|moment\|date-fns" --include="*.ts" --include="*.tsx"
```

Check:
- Is the same date format used everywhere? (not "Jan 5" on one page and "2026-01-05" on another)
- Are dates localized for the user's language?
- Are numbers formatted with proper separators? (1,000 vs 1.000 depending on locale)
- Are currencies displayed correctly?

### 12d: Deployment Checklist (generate at end of audit)

After the audit is complete, generate a project-specific deployment checklist and save
it to `DEPLOY-CHECKLIST.md` in the project root. This is a short, actionable list the
user can run before EVERY future deploy.

Template:

```markdown
# Deployment Checklist for [App Name]

Run these checks before every deploy. Takes ~5 minutes.

## Quick checks
- [ ] `pnpm build` completes without errors
- [ ] No TypeScript errors: `pnpm tsc --noEmit`
- [ ] No lint errors: `pnpm lint`
- [ ] Console is clean (zero errors, zero warnings)

## Verify key flows
- [ ] Can sign up a new user
- [ ] Can log in as existing user
- [ ] [App-specific flow 1, e.g., "Can create a project"]
- [ ] [App-specific flow 2, e.g., "Can upload a file"]
- [ ] [App-specific flow 3, e.g., "Can complete checkout"]

## Environment
- [ ] All env vars are set in production
- [ ] No test/dev API keys in production
- [ ] Database migrations are applied

## After deploy
- [ ] Check the live URL loads
- [ ] Check one key flow works on the live site
- [ ] Check Stripe webhooks are pointing to production URL (if applicable)

Generated by /deep-audit on [date]
```

Customize this template based on what was found during the audit. Add specific
checks for any issues that were fixed — those are likely to regress.

### 12e: Update CLAUDE.md with Learnings

At the very end, offer to add audit learnings to the project's CLAUDE.md:
- Terminology decisions (which words to use)
- Design decisions made during UI Excellence
- Known quirks or gotchas discovered during testing
- Testing commands that are useful for this project

This ensures future Claude sessions on the project have the context from the audit.
