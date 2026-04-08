# UI and Content AI Smell Patterns

Patterns in the visible interface and written content that reveal the app was built by AI.
These make the app feel generic, stock, and unfinished.

## 1. Generic Headlines

AI defaults to vague, impressive-sounding headlines that could apply to any product.

**Red flags**:
- "Welcome to [Product Name]"
- "Your all-in-one solution for..."
- "Streamline your workflow"
- "The future of [X]"
- "Empowering you to..."
- "Unlock the power of..."
- "Transform the way you..."

**Fix**: Replace with specific, action-oriented copy that tells the user exactly what
they can do. Good headlines answer: "What does this page help me do right now?"

**Examples**:
| Before | After |
|--------|-------|
| "Welcome to TaskFlow" | "Your tasks for today" |
| "Streamline your project management" | "Track deadlines, assign work, ship faster" |
| "The future of team collaboration" | "Chat with your team, share files, make decisions" |

## 2. AI Vocabulary in UI Copy

These words appear with unrealistic frequency in AI-generated text and feel hollow
in a product interface.

**Words to scan for** (in UI strings, not code):
comprehensive, robust, seamless, intuitive, cutting-edge, innovative, leverage,
empower, optimize, streamline, enhance, dynamic, holistic, scalable, granular,
actionable, synergy, ecosystem, paradigm, game-changer

**Scan**: Grep for these in component files and i18n key files.

**Fix**: Replace with concrete, specific language. "Comprehensive analytics dashboard"
becomes "See your sales, traffic, and signup numbers."

## 3. Placeholder Text That Stayed

AI generates placeholder content during development that never gets replaced.

**Scan for**:
- "Lorem ipsum"
- "[Your company name]"
- "[Description here]"
- "example@example.com" in visible UI (not in test files)
- "John Doe" / "Jane Smith" (unless they're real users)
- "Acme Corp" or "Acme Inc"
- img src="placeholder" or src="/placeholder.svg"
- "Coming soon" sections that have been "coming soon" forever

**Fix**: Replace with real content that matches the actual product. If the content
genuinely doesn't exist yet, remove the section entirely rather than leaving a placeholder.

## 4. Generic Button Copy

AI uses the same handful of button labels everywhere.

**Red flags**:
- "Click Here" (never use this)
- "Submit" (too vague — submit what?)
- "Learn More" (learn more about what?)
- "Get Started" (on every page, even after the user started)
- "Continue" (continue to where?)

**Fix**: Buttons should say what happens when you click them:
| Before | After |
|--------|-------|
| "Submit" | "Save changes" / "Send message" / "Create account" |
| "Learn More" | "See pricing" / "Read the docs" / "Watch demo" |
| "Get Started" | "Create your first project" |
| "Click Here" | Just make the relevant text a link |

## 5. Empty States That Say Nothing

When there's no data, AI shows the most minimal message possible.

**Red flags**:
- "No items found"
- "No data available"
- "Nothing to show"
- "No results"
- A completely blank page

**Fix**: Empty states should:
1. Tell the user WHY it's empty (no projects yet, no results match your filter)
2. Tell them what to DO about it (create your first project, try a different search)
3. Include a CTA button if appropriate

**Example**:
| Before | After |
|--------|-------|
| "No projects found" | "You haven't created any projects yet. Create your first one to get started." + [Create project] button |
| "No results" | "No results for 'xyz'. Try a different search term or [clear filters]." |

## 6. Error Messages That Help Nobody

AI writes error messages that are technically accurate but useless to users.

**Red flags**:
- "Something went wrong"
- "An error occurred"
- "Failed to process request"
- "Invalid input"
- "Unexpected error"
- "Please try again later" (without explaining what went wrong)
- Raw technical errors shown to users (stack traces, SQL errors)

**Fix**: Error messages should answer three questions:
1. What happened? (in user terms, not technical terms)
2. Why did it happen? (if known)
3. What can the user do about it?

**Example**:
| Before | After |
|--------|-------|
| "Something went wrong" | "We couldn't save your changes because the server is temporarily unavailable. Your work is safe — try saving again in a minute." |
| "Invalid input" | "Email address must include @ and a domain (e.g., you@example.com)" |

## 7. About/Landing Page Brochure Copy

AI writes marketing copy that sounds like every SaaS landing page ever.

**Red flags**:
- Three-column feature grid with icons and vague descriptions
- "Trusted by X+ companies" (without showing real logos)
- "Our mission is to..." followed by buzzwords
- Testimonials that sound AI-generated
- Hero section with stock gradient background
- "Start your free trial" when there is no trial

**Fix**: If this is a real product, write copy about what it actually does and who it's for.
If it's a personal project, the about page should sound like you, not like a startup pitch.

## 8. Success Messages That Sound Like a Robot

**Red flags**:
- "Your request has been processed successfully"
- "Operation completed"
- "Changes have been saved to the database"
- "Thank you for your submission"

**Fix**: Sound human and specific:
| Before | After |
|--------|-------|
| "Your request has been processed successfully" | "Done! Your invoice has been sent to client@email.com" |
| "Changes have been saved" | "Profile updated" |
| "Thank you for your submission" | "Got it! We'll get back to you within 24 hours." |

## 9. Tooltip and Help Text That Restate the Label

**Red flags**:
- Label: "Email" → Tooltip: "Enter your email address"
- Label: "Password" → Tooltip: "Enter your password"
- Label: "Name" → Tooltip: "Enter your name"

**Fix**: Tooltips should add information the label doesn't have:
- Label: "Email" → Tooltip: "We'll send your login link here"
- Label: "Password" → Tooltip: "At least 8 characters with one number"
- Or just remove the tooltip if the field is self-explanatory

## 10. Dark Mode / Theme Inconsistencies

AI sometimes only partially implements dark mode.

**Check**:
- Toggle to dark mode
- Screenshot every page
- Look for: white backgrounds that should be dark, text that becomes invisible,
  borders that disappear, images with white backgrounds that look wrong,
  hardcoded colors that don't switch

**Fix**: Fix the CSS/tailwind classes. Every color should use theme tokens, not hardcoded values.

## How to Scan Systematically

1. Grep for the red-flag phrases in all component files and i18n key files
2. For each match: read the surrounding context, decide if it's genuine content or AI filler
3. For visual patterns (empty states, error messages): navigate to those states in the browser
   and screenshot them
4. For copy quality: read each page's visible text and assess whether a human with knowledge
   of the product would have written it that way
