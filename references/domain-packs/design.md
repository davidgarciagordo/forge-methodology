# Forge — Design Pack

> Domain pack for Forge methodology. Instantiates the universal 7-step loop for product design (UX/UI, visual design, design systems).
> Core references: [the-loop.md](../the-loop.md) · [grill.md](../grill.md) · [verification.md](../verification.md)

---

## Grill Lenses for Design

| Lens | Perspective | Focus |
|------|------------|-------|
| **User / Usability** | Human reality | Does the hierarchy and flow match how real users think and what they expect? What gets missed or misread? What edge state (empty, error, overload, mobile) isn't handled? What would a user with no context do wrong? |
| **Accessibility** | Technical depth | WCAG compliance, assistive technology support (screen readers, switch access), color contrast, keyboard operability, cognitive load for users with disabilities or in low-attention contexts. |
| **Brand / Design System** | System view | Does it fit the established visual language (tokens, patterns, component library)? Does it introduce inconsistency at scale — across surfaces, locales, themes, or future product lines? |

---

## Definition of Done — Design

Design work is done when **all** of the following are true:

- [ ] Usability validated: tested with real users or reviewed against established usability criteria (task completion, findability, error recovery)
- [ ] Accessibility checked: contrast ratios, keyboard flow, screen reader semantics
- [ ] Design system consistency verified: tokens used correctly, no unexplained divergence from established patterns
- [ ] **External visual fidelity verified per screen** against the Reference Standard (when one exists): each designed screen side-by-side with the reference's equivalent screen, graded to the spec's fidelity bar (`visual-fidelity-checker`). Distinct from internal design-system consistency above.
- [ ] All key states designed and documented: default, hover/focus, active, disabled, empty, loading, error, overflow/long content
- [ ] Responsive behavior specified for all target breakpoints
- [ ] Owner visual gate passed: human sign-off on the design at all themes and breakpoints
- [ ] Handoff artifacts complete: specs, annotations, and assets ready for implementation

---

## What to Verify

### Usability
- Can a user with no context complete the primary task without instruction?
- Are error states recoverable and self-explanatory?
- Is the visual hierarchy clear at a glance (most important → least important)?
- Does the interaction model match the user's mental model and platform conventions?

### Accessibility
- Color contrast meets WCAG AA (4.5:1 for normal text, 3:1 for large text and UI components)
- No information is conveyed by color alone
- All interactive elements are keyboard-operable and have visible focus indicators
- Form fields have labels; images have meaningful alt text; icons have accessible names
- Reading and focus order is logical

### Design system consistency
- Design tokens (color, spacing, typography, shadow, radius) used throughout — no hardcoded values
- New components extend or compose existing primitives; they do not re-implement them
- Divergences from the design system are intentional, documented, and approved

### Completeness
- All required states and variants are designed (not left to "figure out in implementation")
- Designs exist for all required locales, themes (light/dark), and breakpoints
- **Every in-scope screen/flow of the Reference Standard is present** (the `completeness-critic` cross-walk): a reference screen with no equivalent design is a blocking completeness gap, not a "phase 2" item — unless explicitly cut in Non-goals
- **External fidelity per screen** vs. the reference (the `visual-fidelity-checker` side-by-side) — internal design-system consistency is necessary but does not prove the design matches the reference it promised

---

## Design Principles

- **Design for the hardest user first.** A design that works for the most constrained user (accessibility needs, low-bandwidth, unfamiliar with the product) works for everyone.
- **States are not optional.** An undesigned state becomes a developer's guess in production.
- **Consistency compounds.** Every unexplained divergence from the design system makes the next divergence easier to rationalize and the system harder to maintain.
- **The handoff is part of the design.** Ambiguous specs produce inconsistent implementations. Annotations, measurements, and interaction notes are design outputs, not optional extras.
