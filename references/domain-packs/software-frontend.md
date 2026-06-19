# Forge — Software Frontend Pack

> Domain pack for Forge methodology. Instantiates the universal 7-step loop for frontend development.
> Core references: [the-loop.md](../the-loop.md) · [grill.md](../grill.md) · [verification.md](../verification.md)

---

## Grill Lenses for Frontend

| Lens | Perspective | Focus |
|------|------------|-------|
| **UX / User** | Human reality | Does the visual hierarchy and interaction flow match how real users think? Are edge states (empty, loading, error, disabled) handled? What gets missed in the happy-path spec? |
| **Accessibility** | Technical depth | WCAG compliance, keyboard navigation (all interactive elements reachable and operable), screen reader semantics, color contrast ratios, focus management on modals and drawers. |
| **Design System Consistency** | System view | Does it use the established design tokens (color, spacing, typography, shadow)? Does it diverge from existing component patterns? Will it break or look wrong in all themes, locales, and screen sizes? |

---

## Definition of Done — Frontend

Frontend work is done when **all** of the following are true:

- [ ] Typecheck passes
- [ ] Unit and integration tests green
- [ ] Visual parity across all themes (light/dark, high-contrast if applicable)
- [ ] Responsive layout verified at all defined breakpoints (mobile, tablet, desktop)
- [ ] Accessibility audit passed: keyboard navigation, screen reader output, contrast ratios
- [ ] Design tokens used (no hardcoded color/spacing/font values)
- [ ] Component stories created (all new components have at least one story covering their key states)
- [ ] Owner visual gate passed (human sign-off on screenshots covering all themes and breakpoints)
- [ ] No regressions in adjacent components or shared layout

---

## What to Verify

### Visual correctness
- Screenshots of every affected surface in **light mode** and **dark mode** (and any other themes)
- Screenshots at every defined breakpoint: mobile, tablet, desktop
- Edge states covered: empty state, loading state, error state, disabled state, overflow/long content

### Accessibility
- All interactive elements reachable by keyboard (Tab, Shift+Tab, Enter, Space, arrow keys where applicable)
- Screen reader announces the right label, role, and state for every element
- Color contrast meets WCAG AA (minimum) for all text and meaningful UI
- Focus indicator visible and not clipped by overflow containers
- Modal/drawer focus trap: focus enters on open, returns to trigger on close

### Design system
- No hardcoded color, spacing, or typography values — use design tokens
- Components extend or compose existing design system primitives; they do not re-implement them
- New patterns that diverge from the design system are intentional and documented

### Component stories
- Every new or significantly changed component has a story file
- Stories cover: default, key variants, edge states (empty, loading, error, disabled), responsive behavior where relevant
- Stories are reviewed in the component workbench (Storybook or equivalent) before the visual gate

---

## Visual Gate Process

Accumulate all verification screenshots (light/dark/mobile across all affected surfaces) into a single async review queue. The owner reviews all at once — this avoids serial per-PR bottlenecks.

For components that cannot be storied (RSC, data-fetching, authenticated routes), gate live in a staging environment.

---

## Frontend Principles

- **Reuse-first.** Build on existing primitives; create new ones only when genuinely new. Every primitive that will be used in more than one place becomes a shared component before it is duplicated.
- **Atomic design.** New UI compounds an existing component, extends it, or promotes it — it does not reimplement it.
- **No hardcoded values.** Colors, spacing, shadows, and typography come from design tokens. If a token does not exist, add it to the design system; do not inline the value.
- **Stories are not optional.** They are the contract that the component works in isolation and survives future refactors.
