# LEGASH — Design-System(2).md

**Status:** Draft / in progress — web foundations are settled, mobile is in early exploration.
**Last updated:** August 13, 2026
**Owner:** Fira (Firaol Tsegaye Negash)

> This doc consolidates three things: (1) the shipped web design system extracted from `index.html` and rebuilt as Figma variables/components, (2) the mobile onboarding explorations currently in the `Legash UI` Figma file, and (3) the product requirements those designs need to satisfy. Where mobile detail is a placeholder — because Figma's Starter-plan rate limit blocked a full pull at time of writing — it's marked **[PENDING FIGMA PULL]**.

---

## 1. Product context

LEGASH is a blood-donor matching platform for Ethiopia, connecting hospitals that need blood with verified nearby donors.

**Core mechanics:**
- Two account types: **donors** and **hospitals**, each with a distinct onboarding and home flow.
- Donors register once (name, blood type, location, password) and are notified when a matching request appears nearby.
- Hospitals post blood requests; only donors matching blood type + proximity are notified.
- **Privacy-by-default reveal system**: a donor's name and blood type are visible to a matched hospital; phone/email stay hidden until the donor explicitly accepts the request. This asymmetric reveal is a core trust mechanic, not a nice-to-have.
- **Admin-reviewed verification**: registrations (including hospital license numbers) are checked before an account is marked verified and can post or respond to requests.

This context matters for the design system because two of the most distinctive web components — the **Reveal Card** (state badges + accept toggle) and the **Trust Card** (verification messaging) — exist specifically to make that privacy/trust mechanic legible to users. Any mobile equivalent needs to carry the same mechanic, not just a login form.

---

## 2. Design principles

1. **Trust is the product.** Every screen that touches personal data (name, phone, location, blood type) should visibly communicate what's shared, with whom, and why. Hiding this is a legibility bug, not a detail.
2. **Calm urgency.** Blood requests are urgent, but panic-driven UI erodes trust over repeated use. The web system leans editorial and steady (serif headings, muted paper tones) rather than alarm-red everywhere; red is reserved for actionable moments (CTA, match state, live indicator).
3. **One system, two platforms — reconciled, not duplicated.** Web and mobile currently use *different* visual languages (see §6, Open Issues). That's acceptable during exploration but needs to converge before ship.

---

## 3. Brand identity

### Logo — REVISED Aug 13, 2026

**New primary mark: the drop + hand.** A blood-drop silhouette with a hand rendered in negative space inside it — replaces the hexagon badge as the primary LEGASH mark.

This is a real upgrade over the hexagon, not just a restyle. The hexagon communicated "verified/secure" — good for trust, but silent on what the product actually asks people to do. The drop+hand does both: unmistakably a blood drop at a glance (the silhouette holds up before anyone registers the hand), and once the hand is noticed, it reframes the whole mark as *giving*, which is the correct emotional register for a donation app. It also survives the core legibility test the wordmark variants failed in §3's original review — the base shape reads correctly even at a distance, with the detail layered on top rather than required to parse it.

| Variant | Role | Use |
|---|---|---|
| Crimson tile, white drop+hand | **Primary** | App icon, favicon, dark-context brand mark |
| White tile, crimson drop+hand | **Secondary** | Light backgrounds, in-line lockups next to the wordmark, anywhere the primary tile's contrast would fight the surrounding UI |

**Before this ships as the app icon:** run it at real render size (48px, 16px favicon) — the hand is built from thin negative-space strokes that are the first thing to degrade at small sizes. If the fingers/gaps blur out below a certain size, the fallback isn't to abandon the mark, it's to simplify the hand's linework specifically for the small-size icon export while keeping the full detail version for anywhere it renders larger (splash screen, marketing, app store listing).

**What this replaces:** the hexagon badge (§3 original) is retired as the primary mark. Losing it means LEGASH no longer gets a "verified" visual metaphor for free from the logo shape — that needs its own small, separate visual language now (e.g. a checkmark badge overlay on a verified profile, distinct from the brand mark itself) rather than inheriting it implicitly the way the hexagon did.

**Wordmark:** unchanged from the original review — keep the accent-above variant ("L·EGASH" with the drop as a mark above the wordmark, not overlapping any letters), drop the overlapping-letter variant. Pair the wordmark with the new primary drop+hand mark in lockups, not the retired hexagon.

---

**Export format:** SVG for all variants — vector export solves crispness (no blur from bitmap upscaling, no compression artifacts) but does **not** by itself solve the finger-merging risk at small sizes. That's a proportional problem, not a resolution problem: the negative-space gaps between fingers shrink along with the rest of the mark, and at some point the renderer has to round a sub-pixel gap up to a visible line or down to nothing. SVG doesn't decide that for you.

**Two size-specific variants required, both SVG:**

| Variant | Use | Spec |
|---|---|---|
| Full-detail | Splash screen, marketing, app store listing — anywhere rendering large | As designed |
| Small-size (optically corrected) | Favicon, app icon tray, anywhere ≤48px | Same mark, fingers redrawn with wider negative-space gaps (fewer/fatter strokes) so it doesn't degrade into a blob at tray size — a five-minute redraw off the master file, not a redesign |

This is the same pattern Apple's and Google's own icon systems use — one mark, optically adjusted per size, not one file scaled infinitely.

**Verification badge — new visual language, separate from the brand mark.** With the hexagon's "verified" metaphor retired, verification needs its own small, explicit signal:

- **Form:** a small checkmark badge overlaid on the corner of a profile avatar — matches how people already read "verified" from every other platform, so it needs no explanation.
- **Color:** `verified` green (`#1F6F5C`), not crimson. Crimson is reserved for primary actions in this system (§4); a verified badge competing visually with a CTA button would blur that hierarchy.
- **Usage rule:** always an overlay on the thing it's vouching for (a profile avatar, a hospital listing) — never used as a standalone icon on its own. A badge only means something in context.

### Logo — original review (superseded above, kept for context)

| Variant | Verdict | Why |
|---|---|---|
| Wordmark, drop as accent above "L·EGASH" | ✅ Keep | Legible at a glance; drop reads as a mark, not noise |
| Wordmark, drop overlapping "LEG●SH" | ❌ Drop | Obscures letterforms — fails the 2-second legibility test |
| Hexagon badge, red fill, drop inside | ✅ Keep — primary app icon candidate | Reads as a verification/safety seal, which matches the trust-driven product |
| Hexagon badge, white outline on white | ❌ Drop | Insufficient contrast, disappears on light backgrounds |
| Hexagon badge, dark tile, white outline | ✅ Keep — alt/dark-mode icon | Strong contrast, works as an app tile |

**Recommendation:** wordmark (accent-above variant) for horizontal lockups (nav, footer, marketing); solid-red hexagon badge as the app icon; dark-tile hexagon as the dark-mode/alt icon.

---

## 4. Web design tokens (shipped)

Source of truth: `Tokens` variable collection in the [LEGASH — UI Component Library Figma file](https://www.figma.com/design/cgQpBmkGXqAEvS4CQ8x2Vd), mirrored from `index.html`.

### Color

| Token | Hex | Use |
|---|---|---|
| `color/ink` | `#1B1410` | Primary text, dark surfaces |
| `color/ink-soft` | `#4A4038` | Secondary text |
| `color/paper` | `#FAF6F0` | Page background |
| `color/paper-dim` | `#F2EBE1` | Recessed panels |
| `color/sand` | `#EAE0D0` | Borders, chip backgrounds |
| `color/crimson` | `#C31F3B` | Primary action, live/match state |
| `color/crimson-dark` | `#8F1329` | Hover states, emphasis text |
| `color/verified` | `#1F6F5C` | Verified/visible state (green, deliberately *not* red — reserves red for urgency) |

### Radius
`radius/sm` 8 · `radius/md` 14 · `radius/lg` 18 · `radius/pill` 999

### Spacing
`spacing/xs` 8 · `spacing/sm` 12 · `spacing/md` 16 · `spacing/lg` 24 · `spacing/xl` 32

### Typography — REVISED Aug 13, 2026

**Original pairing (Fraunces + Inter + IBM Plex Mono) is being retired.** It read as an editorial/magazine choice — picked because it looked good on a marketing page — rather than a choice built for the actual usage context: a form-heavy, verification-heavy donor app where a phone number, an OTP code, and a Fayda national ID have to be read correctly under mild urgency, at small mobile sizes, sometimes in low light. That's a usability requirement, not a branding one, and Fraunces (a display serif) and Inter (the internet's default UI sans, chosen by default rather than for any distinguishing character) don't serve it as well as they should.

**New system: IBM Plex Sans + IBM Plex Mono, full stop.**

- One family across headings and body — no serif/sans split. Plex Sans has enough character (distinctive double-story `g`, humanist warmth) to still feel designed, without the "fashion editorial" register Fraunces carries.
- Plex Mono is already in the system for chips and eyebrows — this just makes it official for anything numeric: OTP codes, phone numbers, the Fayda FIN field. Monospace numerals mean a 6-digit OTP code doesn't visually jitter as someone types it, which matters more than it sounds like it should when someone's asked to enter a code twice in one flow (register → verify, then again on password reset).
- Plex is designed as a product/software typeface family (IBM built it for their own software, not a magazine), which is the "usage over design" direction you're after.
- Practical bonus: if LEGASH ever needs Amharic/Ge'ez script support, Plex pairs cleanly with Noto Sans Ethiopic at matching weights — worth knowing now even though it's out of scope for Sprint 1.

| Style | Family | Size/Line-height | Weight |
|---|---|---|---|
| `Heading/H1` | IBM Plex Sans | 34/40 | SemiBold |
| `Heading/H2` | IBM Plex Sans | 24/30 | SemiBold |
| `Heading/H3` | IBM Plex Sans | 18/24 | SemiBold |
| `Body/Lede` | IBM Plex Sans | 17/26 | Regular |
| `Body/Medium` | IBM Plex Sans | 15/22 | Regular |
| `Body/Small` | IBM Plex Sans | 13/20 | Regular |
| `Label/Button` | IBM Plex Sans | 15/20 | SemiBold |
| `Mono/Numeric` | IBM Plex Mono | 18/24 | SemiBold — OTP, phone, FIN entry, tabular figures |
| `Mono/Chip` | IBM Plex Mono | 12/16 | SemiBold — chips, eyebrows |

Note the web H1/H2 sizes above are also toned down from the original 60px/42px — that scale was tuned for Fraunces' display proportions and reads oversized in Plex Sans at the same size. Re-check against the actual marketing page once this lands in Figma.

---

## 5. Web component inventory (shipped)

Built as real Figma variant components bound to the tokens above (not flat mockups) in the same file.

| Component | Variants | Notes |
|---|---|---|
| **Button** | Style: Primary / Outline / Ghost × Size: Default / Small | Primary = crimson fill; Outline/Ghost = ink text, bordered |
| **Badge** | Visible / Hidden / default chip / match chip / step chip | Visible=verified green, Hidden=sand/ink-soft, Match=crimson |
| **Toggle Switch** | Off / On | On = verified green track |
| **Tab** | Active / Inactive | Used for donor/hospital role switch |
| **Step Card** | — | Numbered onboarding step (chip + title + body) |
| **Trust Card** | — | Dark card, verification/trust messaging |
| **Reveal Card** | — | Field rows (Name, Blood type, Phone & email) each with a Visible/Hidden badge, plus an "accepted the request" toggle footer — **this is the privacy mechanic made visible, the most product-critical component in the system** |
| **CTA Banner** | — | Full-bleed crimson callout, dual actions |
| **Logo** | — | Hexagon mark + wordmark lockup |

An HTML reference build of all of the above (static, browser-viewable) also exists as `components.html`.

---

## 6. Mobile — Legash UI (Figma, in progress)

**File:** `Legash UI`, Commusign team — [figma.com/design/wNfczxuzrOMMCxKRhNX3FO](https://www.figma.com/design/wNfczxuzrOMMCxKRhNX3FO)
**[PENDING FIGMA PULL]** for exact spacing/layer values — Figma's Starter-plan MCP rate limit still blocks a full read. But the *field-level* spec below is no longer a guess: it's pulled directly from `AGENTS-Mobile.md`, the engineering doc for `legash-mobile`, which is the real source of truth for Sprint 1.

### Sprint 1 scope: donor-only, auth-only
`legash-mobile` is donor-facing only — hospitals and the super admin live on `legash-web` exclusively. Sprint 1 is registration, login, and password reset. No dashboard content, no request/matching UI, no Reveal Card equivalent yet — those come later. This resolves the "product gap" flagged in the previous version of this doc: the Reveal Card isn't missing from mobile by oversight, it's just out of scope for this sprint.

### Confirmed field set (replaces earlier onboarding-screenshot guesses)

**Register** (`register_screen.dart` → `POST /donor/register`):
Name · Password (8+ chars, 1 uppercase, 1 special char) · Confirm password (frontend-only) · Phone (`+251` format, required, doubles as login identifier) · Fayda national ID / FIN (plain text, stored not verified this sprint) · Gender (`male`/`female`) · Blood type (optional, `A+…O-`/`unknown`) · Location (captured via GPS permission, not typed) · Agree to Terms & Policy checkbox (links to Terms screen).
**No email field, anywhere, ever** — deliberately removed. **No date of birth** — deferred to profile, post-Sprint-1.

→ This confirms the earlier screenshot's 5× "Full Name" stack and duplicate "Phone Number" fields were placeholder artifacts, not real design intent — good, the critique's instinct to flag them was right. It also confirms FAYDA is **required**, not optional as originally guessed.

**OTP Verification** (`otp_verification_screen.dart` → `POST /donor/verify-otp`): one field, the OTP code. Reached only from Register; on success, goes to Login — **no auto-login anywhere in the system.**

**Login** (`login_screen.dart` → `POST /donor/login`): Phone, Password. A "Forgot password?" link below Password opens a dialog (not a new screen).

**Forgot Password** (`forgot_password_dialog.dart`, single widget, two internal steps, → `POST /donor/forgot-password` then `POST /donor/reset-password`):
- Step 1 — Phone only. Response is intentionally generic ("if this phone is registered, an OTP has been sent") regardless of match, then advances to Step 2.
- Step 2 — OTP code, New password, Confirm new password. On success, closes the dialog back to Login.

**Terms & Policy** (`terms_policy_screen.dart`): static text, linked only from the Register checkbox.

### Design implications of the real spec
- **GPS location capture, not a typed field** — the registration screen needs a permission-prompt moment and a way to show "location captured" state, not a text input. Worth a dedicated micro-interaction: confirm the location was captured before letting the user continue, since a silent failure here breaks matching later.
- **Fayda FIN is plain text this sprint** (not verified against the national ID system yet) — the UI should still *treat* it as a trust-relevant field visually (same visual weight as verified fields elsewhere in the system) even though the backend isn't checking it yet, so the UI doesn't need to change later when verification does land.
- **Two password-matching checks exist** (register's confirm-password, and reset's confirm-new-password) — same inline-validation pattern should be reused in both places rather than designed twice.
- **The forgot-password flow is a dialog with two states, not two screens** — design it as one component with a step indicator, not as two separate mocks that happen to look similar.
- **Numeric-heavy fields** (OTP, phone, FIN) should use `Mono/Numeric` from the revised type system (§ Typography) so digits don't jitter as they're typed.

### Open issues carried forward from the Aug 13 critique (still valid)
| Issue | Severity | Fix |
|---|---|---|
| White label/input text risks sitting on the near-white bottom of a red gradient background | 🔴 Critical | Compress any gradient so saturated red covers the full form zone, or flip to dark text in the lower half |
| Overlapping-letter wordmark variant still present in file | 🟢 Minor | Remove per §3 |
| Input style not yet converged (underline vs. boxed seen in early exploration) | 🟡 Moderate | Resolve as part of the Stitch prompt pass — recommend boxed, see § 11 |

---

## 7. Cross-platform reconciliation (needs a decision)

Web and mobile are currently two different visual systems:

| | Web (shipped) | Mobile (exploration) |
|---|---|---|
| Type | Fraunces serif headings + Inter body | Unspecified in explorations — **[PENDING FIGMA PULL]** |
| Palette | Warm paper/sand neutrals, crimson as accent | Full-bleed red gradient as primary surface |
| Tone | Editorial, calm, muted | Bold, saturated, high-contrast |

This isn't necessarily wrong — mobile onboarding is allowed a punchier first-open moment than a marketing page — but it needs to be a *decision*, not a drift. Before mobile design continues past onboarding: pick which tokens are shared (recommend: color tokens, radius scale) vs. which are allowed to diverge by platform (recommend: hero treatment only — gradient stays for splash/onboarding, but in-app screens should return to the paper/sand palette so the Reveal Card, badges, etc. feel like the same product).

---

## 8. Functional requirements

### Mobile Sprint 1 (confirmed, from `AGENTS-Mobile.md`)
- [x] Donor registration: name, password, confirm password, phone (`+251`, = login ID), Fayda FIN, gender, optional blood type, GPS location, terms agreement
- [x] SMS OTP verification, required before login is possible
- [x] Login by phone + password, JWT session
- [x] Password reset via phone → OTP → new password, as a dialog on the login screen
- [x] No email anywhere in the mobile app; no auto-login at any step; no dashboard content yet

### Later mobile scope (not Sprint 1 — noted so design doesn't scope-creep the current build)
- [ ] Donor home/dashboard real content
- [ ] Receive notification when a matching (blood type + distance) request is posted
- [ ] View request details with the same visible/hidden field split as the web Reveal Card
- [ ] Accept/decline a request — accepting reveals phone to the requesting hospital
- [ ] Profile completion (date of birth, etc.)
- [ ] Fayda FIN actually verified against national ID system (currently stored, not checked)

**Web (hospital + admin, `legash-web`)**
- [ ] Hospital registration with license number; gated behind admin verification before posting requests
- [ ] Post a blood request (type + urgency + location)
- [ ] See only the fields a matched donor has made visible, updating live as the donor accepts
- [ ] Admin review queue for both donor and hospital verification (not yet designed)

---

## 9. Appendix — BlooDoChallenge (reference only, not part of LEGASH's system)

A separate Play Store app (`com.fourgirlsforchange.bloodochallenge`) reviewed for competitive/UX reference, extracted into its own component library (`bloodo-components.html`). **Not merged into LEGASH tokens** — different product, different owner, different visual language. Worth revisiting only for its **gamification mechanics** if LEGASH ever wants a points/challenges layer:

- Points + level system tied to donation history
- "Challenges" cards (e.g. "First donation this year") with progress tracking and validity windows
- Rankings / Friends stat cards on the profile screen

If LEGASH adopts anything from this reference, it should be the *mechanic* (challenges, progress tracking) re-skinned in LEGASH's own palette and type — not the visual components directly.

---

## 10. Open questions for next session

1. ~~Confirm mobile type family~~ — **resolved**: IBM Plex Sans + IBM Plex Mono, both platforms (§ Typography).
2. ~~Is FAYDA required?~~ — **resolved**: required, donor-side, this sprint (stored, not yet verified).
3. Where does the Reveal Card mechanic live on mobile — its own screen, or inline in a request detail view? *(still open — out of scope until post-Sprint-1)*
4. Should the red-gradient treatment be scoped to onboarding/splash only, or does it extend into core app screens? *(still open — worth deciding before Sprint 2 introduces the dashboard)*
5. New: once Fayda FIN verification actually lands on the backend, does the FIN field's visual treatment need to change (e.g. gain a "verified" badge state matching web's Trust Card language)?

---

## 11. Stitch design prompts (Sprint 1 screens)

Page-by-page prompts for generating the six Sprint 1 mobile screens are in a companion file, `legash-stitch-prompts.md`, built directly against the confirmed field spec in § 6 and the revised type/color tokens in § 4/§ Typography. Each prompt is self-contained (paste one at a time into Stitch) and includes explicit anti-"AI slop" constraints — real Ethiopian phone formatting, no stock illustration, no decorative gradient blobs, consistent single-weight line icons, accurate empty/error/loading states — since a donation-ask app can't afford to look synthetic or untrustworthy.
