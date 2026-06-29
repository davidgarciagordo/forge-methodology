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
- [ ] **External visual fidelity verified per surface** — each UI surface side-by-side against the *reference's* equivalent screen, to the fidelity bar the spec demanded (see *External Visual Fidelity Gate* below). This is **not** the same as the next line.
- [ ] Visual parity across all themes (light/dark, high-contrast if applicable) — *internal* theme correctness within our own design system
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

## External Visual Fidelity Gate (per surface, not deferred)

There are **two different visual checks**, and the failure mode is conflating them:

| | Internal theme parity | **External visual fidelity** |
|---|---|---|
| **Question** | Is the surface correct in light/dark/high-contrast within *our* design system? | Does the surface match the *reference's* equivalent screen? |
| **Reference** | Our own design tokens | The external Reference Standard (competitor screen, screenshot set, prior system) |
| **Already covered by** | "Visual parity across all themes" in the DoD | This gate |

The CRM-parity failure was an **external** fidelity miss (the build looked unlike the reference) that an
internal theme-parity check could never catch. So fidelity to the reference is gated **per UI surface,
during execution** — not batched and deferred to the owner's final sign-off:

1. For each in-scope UI `req-id` whose `fuente` is a reference screen, run the **`visual-fidelity-checker`**
   agent: it captures the reference screen and the built surface and produces a **side-by-side**.
2. Grade against the **fidelity bar the spec demanded** (pixel-match vs. structural/IA fidelity with our
   design layer applied) — not against taste.
3. A missing element/affordance of the reference screen is **both** a fidelity delta **and** a completeness
   finding (escalate to `completeness-critic`).
4. The side-by-side is the **evidence** for those UI rows in the Acceptance Matrix. A UI row cannot be marked
   `built = yes` without it.

## Visual Gate Process

Accumulate all verification screenshots (light/dark/mobile across all affected surfaces) into a single async review queue. The owner reviews all at once — this avoids serial per-PR bottlenecks.

For components that cannot be storied (RSC, data-fetching, authenticated routes), gate live in a staging environment.

> The async owner queue does **not** replace the per-surface external fidelity gate above — the per-surface
> check happens *during* execution and produces the evidence; the owner queue is the final human review *on
> top of* it. Deferring fidelity entirely to the owner queue is exactly the failure this gate prevents.

---

## Frontend Principles

- **Reuse-first.** Build on existing primitives; create new ones only when genuinely new. Every primitive that will be used in more than one place becomes a shared component before it is duplicated.
- **Atomic design.** New UI compounds an existing component, extends it, or promotes it — it does not reimplement it.
- **No hardcoded values.** Colors, spacing, shadows, and typography come from design tokens. If a token does not exist, add it to the design system; do not inline the value.
- **Stories are not optional.** They are the contract that the component works in isolation and survives future refactors.
