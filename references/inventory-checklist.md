# Inventory Checklist

How to build a complete map of the app before auditing.

## 1. Pages and Routes

### Next.js App Router
```bash
# Find all page files
find app -name "page.tsx" -o -name "page.ts" -o -name "page.jsx" -o -name "page.js" | sort
# Find all layout files
find app -name "layout.tsx" -o -name "layout.ts" | sort
# Find loading/error/not-found states
find app -name "loading.tsx" -o -name "error.tsx" -o -name "not-found.tsx" | sort
```

### Other Frameworks
- **Nuxt**: scan `pages/` directory
- **Astro**: scan `src/pages/` directory
- **SvelteKit**: scan `src/routes/` directory
- **Express/Hono**: grep for `app.get`, `app.post`, `router.get`, etc.

### What to record per page
| Field | How to find |
|-------|-------------|
| Route path | Directory structure → URL path |
| Page title | Look for `<title>` or `metadata.title` in the file |
| Auth required | Check for auth middleware, `getServerSession`, redirect to login |
| Dynamic params | `[slug]`, `[id]` in path |
| Key components | Read the page file, note main sections |

## 2. API Routes

### Next.js
```bash
find app/api -name "route.tsx" -o -name "route.ts" | sort
```

### What to record per API route
| Field | How to find |
|-------|-------------|
| Path | Directory structure |
| HTTP methods | Look for exported `GET`, `POST`, `PUT`, `DELETE`, `PATCH` functions |
| Auth required | Check for auth validation at top of handler |
| Request body | Look for `request.json()` or form data parsing |
| Response shape | Look for `NextResponse.json()` calls |

## 3. i18n Keys

```bash
# Common i18n file locations
ls messages/ locales/ i18n/ public/locales/ src/locales/ 2>/dev/null

# Count keys per language file
for f in messages/*.json; do
  echo "$f: $(cat "$f" | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d))" 2>/dev/null || echo "unknown") keys"
done
```

### What to record
- Languages available
- Key count per language
- Which language is primary (usually `en`)
- Whether keys are flat or nested

## 4. Environment Variables

```bash
# List all .env files
ls -la .env* 2>/dev/null

# Find all process.env references in code
grep -r "process\.env\." --include="*.ts" --include="*.tsx" --include="*.js" -h | \
  grep -o "process\.env\.[A-Z_]*" | sort -u

# Find all env references in Next.js config
grep -r "NEXT_PUBLIC_" --include="*.ts" --include="*.tsx" -l
```

### What to record
- Variable name
- Whether it has a value in .env (don't log the actual value)
- Whether it's used in client-side code (NEXT_PUBLIC_ prefix)
- What it's used for (auth, API key, database URL, etc.)

## 5. Database Tables

### Supabase
If Supabase MCP is available, use `execute_sql`:
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' ORDER BY table_name;
```

### Prisma
```bash
cat prisma/schema.prisma | grep "^model "
```

### Drizzle
```bash
grep -r "export const.*pgTable\|sqliteTable\|mysqlTable" --include="*.ts" -l
```

### What to record
- Table name
- Key columns (id, created_at, user_id, etc.)
- Whether RLS is enabled (Supabase)

## 6. External Integrations

Scan for common integration patterns:
```bash
# Payment
grep -rl "stripe\|@stripe" --include="*.ts" --include="*.tsx" | head -5
# Email
grep -rl "resend\|sendgrid\|nodemailer\|postmark" --include="*.ts" | head -5
# Auth providers
grep -rl "google\|github\|apple.*auth\|oauth" --include="*.ts" | head -5
# Storage
grep -rl "@supabase/storage\|uploadthing\|@vercel/blob" --include="*.ts" | head -5
# Analytics
grep -rl "posthog\|mixpanel\|amplitude\|vercel/analytics" --include="*.ts" | head -5
```

### What to record
- Integration name
- What it's used for
- Config file location
- Whether API keys are present in env

## 7. Screenshots

For each page in the inventory:
1. Navigate with Playwright
2. Wait for page to be fully loaded (network idle or key element visible)
3. Take full-page screenshot
4. Save to `.deep-audit/screenshots/inventory/[page-slug].png`
5. Record path in AUDIT.md inventory table
