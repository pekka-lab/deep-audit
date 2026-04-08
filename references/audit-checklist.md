# Audit Checklist

Per-item audit questions for each category. Use this during Phase 1 and Phase 3.

## Per-Page Checklist

For every page in the inventory, check:

### Load & Render
- [ ] Page loads without JS errors in console
- [ ] No failed network requests (no 404s, 500s for resources)
- [ ] Page title is set (not blank or "undefined")
- [ ] Favicon loads
- [ ] No layout shift after load (content doesn't jump around)
- [ ] Page renders something meaningful within 3 seconds

### Navigation
- [ ] All links on this page lead somewhere (no 404s)
- [ ] Back button works after navigating away and returning
- [ ] Breadcrumbs (if present) are accurate

### Auth-Protected Pages
- [ ] Unauthenticated users get redirected to login (not a blank page or error)
- [ ] After login, user returns to the page they tried to access
- [ ] Logout works and clears the session

### Forms
- [ ] Submit button does something (not a dead click)
- [ ] Required fields show validation messages
- [ ] Form submits successfully with valid data
- [ ] Success feedback is shown after submit
- [ ] Error feedback is shown if submit fails
- [ ] Form doesn't submit twice on double-click

### Buttons & Interactive Elements
- [ ] Every button does something visible when clicked
- [ ] Loading states show during async operations
- [ ] Disabled buttons look disabled and can't be clicked
- [ ] Modal/dialog close buttons work
- [ ] Dropdown menus open and close properly

### Data Display
- [ ] Tables/lists load data (not empty when data exists)
- [ ] Pagination works (if present)
- [ ] Sort/filter controls work (if present)
- [ ] Data matches what's in the database

## Per-API-Route Checklist

### Happy Path
- [ ] Returns correct status code (200 for GET, 201 for POST create)
- [ ] Response body has expected shape (correct field names and types)
- [ ] Auth-protected routes reject unauthenticated requests (401)
- [ ] Response headers include appropriate content-type

### Error Handling
- [ ] Missing required fields return 400 (not 500)
- [ ] Invalid data types return 400 (not 500)
- [ ] Non-existent resources return 404 (not 500)
- [ ] Error responses have a message field (not raw stack traces)
- [ ] No internal details leaked in error responses (no file paths, SQL queries)

### Security
- [ ] Rate limiting is present on sensitive endpoints (login, signup, password reset)
- [ ] No API keys or secrets in response bodies
- [ ] CORS headers are appropriate (not wildcard * in production)
- [ ] Auth tokens are validated on every request

## i18n Checklist

### Key Completeness
- [ ] All languages have the same number of keys
- [ ] No keys have empty string values
- [ ] No keys have placeholder values ("TODO", "FIXME", "xxx")
- [ ] No keys have the English value as a placeholder in other languages

### Usage in Code
- [ ] No hardcoded user-visible strings in components (should use i18n)
- [ ] No string concatenation that breaks translation ("Hello " + name — should use interpolation)
- [ ] Date/time formatting uses locale-aware formatters
- [ ] Number formatting uses locale-aware formatters
- [ ] Pluralization rules are correct (not just adding "s")

### Visual Check
- [ ] Longer translations don't break layouts (German/Finnish tend to be longer)
- [ ] RTL languages display correctly (if supported)
- [ ] Language switcher works and persists the choice

## Cross-Page Consistency Checklist

### Visual
- [ ] Buttons use the same style across all pages
- [ ] Headings use consistent sizes and weights
- [ ] Colors are consistent (same primary, same error red, etc.)
- [ ] Spacing is consistent (same padding in cards, same gaps)
- [ ] Icons are from the same icon set

### Behavioral
- [ ] Error handling looks the same everywhere (toasts, banners, or modals — not mixed)
- [ ] Loading states look the same everywhere
- [ ] Empty states are present and consistent
- [ ] Success feedback is consistent (all toasts, or all inline — not mixed)

### Content
- [ ] Tone of voice is consistent (not formal on one page, casual on another)
- [ ] Date/time format is consistent across pages
- [ ] Number formatting is consistent
- [ ] Terminology is consistent (don't call it "project" on one page and "workspace" on another)
