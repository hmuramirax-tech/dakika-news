# OneNews App — UI/UX Requirements Document

**Document Code:** ON-2026-UIUX-001  
**Version:** v1.0  
**Status:** DRAFT  
**Date:** September 2026  
**Author:** OneNews Design Team  

---

## 1. Design Direction

### 1.1 Concept

**"A newsroom that fits in your pocket — read the day in 60 seconds."**

OneNews is designed for the commuter who has 60 seconds to become informed. Every design decision serves one goal: **get the user from "I need to know what's happening" to "I know what matters" in under 60 seconds.**

### 1.2 Who, Where, Holding What

| Constraint | Implication |
|---|---|
| **Standing, one hand, sunlight** | High contrast, huge touch targets, no hover states, no fine text |
| **Interrupted, distracted** | Save state instantly, resume seamlessly, no lost progress |
| **Cracked 10-inch screen over 3G** | Low data usage, works on small screens, graceful degradation |
| **60-second time budget** | Every screen must be scannable in < 5 seconds |
| **Low trust in digital news** | Source attribution always visible, no clickbait, no sensationalism |

### 1.3 The Emotional Job

**Trust and speed.** The user must feel: "This app respects my time and tells me the truth." Not "This app is entertaining." Not "This app is comprehensive." Respect and truth.

### 1.4 The One Thing Legible from Two Feet Away

**The story card.** Each story must be scannable at a glance: headline, source, category, and a visual indicator of reading time. If you can't understand what a story is about from 2 feet away in 2 seconds, the card has failed.

### 1.5 The Register

**Who this product sounds like:** A well-informed friend who gets straight to the point. Concise. Confident. Never chatty. Never corporate. Never sensational.

**Who this product must NOT sound like:** A news anchor (too formal), a social media feed (too noisy), a tech bro (too casual), a government bulletin (too stiff).

### 1.6 What the Competition Looks Like

| Competitor | What They Do | Why It Fails |
|---|---|---|
| **Google News** | Endless scroll, algorithmic, overwhelming | Too much choice, no curation, no time boundary |
| **Inshorts** | 60-word cards, swipe | Not in Africa, no local content, no local languages |
| **KandaNews** | Digital flipbook | 15–30 min to read, not concise, no AI |
| **WhatsApp groups** | Forwarded messages | No verification, no structure, no trust |
| **Radio** | Audio broadcast | Not on-demand, no personalization, no visual |

---

## 2. The Signature — The 60-Second Ring

### 2.1 What It Is

A **circular progress indicator** that sits in the top-right corner of every screen, always visible. It fills as the user reads through the digest, showing:
- **How many stories they've read** (filled portion)
- **How many remain** (empty portion)
- **Estimated time remaining** (numerical countdown)

### 2.2 Why It's the Signature

1. **It's unique** — no news app has a reading progress ring
2. **It's functional** — it tells the user exactly how much time they're spending
3. **It's motivating** — it creates a gamified "finish the digest" feeling
4. **It's always visible** — it appears on every screen, becoming the app's identity
5. **It's shareable** — users can screenshot their completed ring and share it

### 2.3 Where It Appears

| Screen | Behavior |
|---|---|
| **Digest Feed** | Fills as user swipes through stories; shows "3 min left" → "Done!" |
| **Category Feed** | Resets per category; shows progress within that category |
| **Full Article** | Shows reading progress through the article |
| **Offline Mode** | Shows download progress, then reading progress |
| **Premium Paywall** | Shows "Go ad-free in 60 seconds" with animated ring |

### 2.4 The Ring's States

| State | Visual | Meaning |
|---|---|---|
| **Empty** | Thin grey circle, 0% filled | Digest not started |
| **Reading** | Green arc filling clockwise | Currently reading |
| **Paused** | Yellow arc, paused animation | User stopped for > 10 seconds |
| **Complete** | Full green circle, checkmark | Digest finished |
| **Shared** | Full circle with share icon | Screenshot ready |

---

## 3. Visual Design System

### 3.1 Palette

| Token | Light Mode | Dark Mode | Usage |
|---|---|---|---|
| **Ground** | `#FAFAF8` | `#0F0F0E` | App background |
| **Surface** | `#FFFFFF` | `#1A1A18` | Cards, sheets |
| **Ink** | `#1A1A18` | `#F5F5F0` | Primary text |
| **Ink Secondary** | `#6B6B60` | `#A0A098` | Secondary text |
| **Accent** | `#1B7A3D` | `#4ADE80` | Brand, progress, links |
| **Accent Warm** | `#D97706` | `#FBBF24` | Breaking news, alerts |
| **Accent Cool** | `#2563EB` | `#60A5FA` | Links, sources |
| **Danger** | `#DC2626` | `#F87171` | Errors, destructive |
| **Rule** | `#E5E5DE` | `#2A2A26` | Borders, dividers |

**Why this palette:** The ground is warm off-white (`#FAFAF8`), not pure white — it reduces eye strain in sunlight and feels more "paper" than "screen." The accent is a deep forest green (`#1B7A3D`), not a generic blue — it signals "growth, trust, East Africa" and is distinct from every competitor's blue.

### 3.2 Typography

| Role | Family | Size | Weight | Tracking | Line Height |
|---|---|---|---|---|---|
| **Display** | Fraunces | 28px | 700 | -0.02em | 1.15 |
| **Headline** | Fraunces | 22px | 600 | -0.01em | 1.25 |
| **Body** | Inter | 16px | 400 | 0 | 1.5 |
| **Label** | Inter | 12px | 500 | +0.04em | 1.4 |
| **Caption** | Inter | 14px | 400 | 0 | 1.4 |
| **Mono** | JetBrains Mono | 12px | 400 | 0 | 1.4 |

**The type decision:** Fraunces (a serif with character) for headlines gives the app editorial credibility — it feels like a newspaper, not a social feed. Inter for body text ensures readability on small screens. JetBrains Mono for timestamps and metadata gives a "newsroom data" feel.

**Tabular figures everywhere numbers stack** — all timestamps, counts, and statistics use `font-variant-numeric: tabular-nums`.

### 3.3 Spacing

| Token | Value | Usage |
|---|---|---|
| **xs** | 4px | Icon padding, tight gaps |
| **sm** | 8px | Inline gaps, label spacing |
| **md** | 16px | Card padding, section gaps |
| **lg** | 24px | Screen margins, major sections |
| **xl** | 32px | Hero spacing, page breaks |
| **xxl** | 48px | Empty states, onboarding |

**The spacing rule:** 4/8/16/24/32/48 — each step is perceptibly different. No 12, 20, or 28. If something doesn't fit, it goes to the next step up.

### 3.4 Radius

| Token | Value | Usage |
|---|---|---|
| **sm** | 4px | Tags, labels, small elements |
| **md** | 8px | Cards, buttons, inputs |
| **lg** | 16px | Sheets, modals, large containers |
| **full** | 9999px | Avatars, pills, the 60-Second Ring |

**Concentric radii:** Inner radius = outer radius − padding. A card with 8px radius and 16px padding contains elements with 4px radius.

### 3.5 Elevation

| Level | Shadow | Usage |
|---|---|---|
| **0** | None | Flat elements, text |
| **1** | `0 1px 2px rgba(0,0,0,0.06)` | Cards, story items |
| **2** | `0 4px 12px rgba(0,0,0,0.08)` | Sheets, modals |
| **3** | `0 8px 24px rgba(0,0,0,0.12)` | Floating action buttons, dialogs |

**Shadows are tinted toward the ground's hue** — in light mode, shadows have a warm tint; in dark mode, they have a cool tint. Never pure black.

---

## 4. Screen-by-Screen Specifications

### 4.1 Splash Screen

| Element | Specification |
|---|---|
| **Duration** | 1.5 seconds max |
| **Background** | Solid ground color (`#FAFAF8`) |
| **Logo** | OneNews wordmark + 60-Second Ring icon, centered |
| **Animation** | Ring draws itself from 0% to 100% in 1 second |
| **Transition** | Fades to Digest Feed |

**Anti-generic:** No spinner. No "Loading..." text. The ring drawing itself IS the loading indicator — it teaches the user what the ring means before they even start using the app.

### 4.2 Onboarding (First Run Only)

**3 screens, skippable, 15 seconds total.**

| Screen | Content | Interaction |
|---|---|---|
| **1. Welcome** | "Read the day in 60 seconds." + illustration of ring | Swipe right to continue |
| **2. Choose Language** | English / Kinyarwanda / Swahili (radio buttons) | Tap to select, auto-advance |
| **3. Pick Interests** | 6 category chips (Sports, Business, Tech, Politics, Entertainment, Health) — multi-select | Tap to toggle, "Start Reading" button |

**The first run is a demonstration, not a tour.** After onboarding, the user lands on a pre-populated digest with 5 stories already loaded. They can start reading immediately — no empty state, no "add sources" friction.

### 4.3 Digest Feed (Home Screen)

**The core screen. This is where 90% of user time is spent.**

| Element | Position | Specification |
|---|---|---|
| **60-Second Ring** | Top-right | 44px diameter, always visible |
| **Greeting** | Top-left | "Good morning" / "Good afternoon" / "Good evening" based on time |
| **Date** | Below greeting | "Monday, 28 September" in label case |
| **Category Tabs** | Below date | Horizontal scroll: All, Sports, Business, Tech, Politics, Entertainment, Health |
| **Story Cards** | Main area | Vertical stack, swipeable |
| **Bottom Navigation** | Bottom | 4 tabs: Digest, Explore, Saved, Profile |

**Story Card Specification:**

| Element | Specification |
|---|---|
| **Category Tag** | Small pill, top-left, color-coded by category |
| **Headline** | Fraunces 22px, max 2 lines, bold |
| **Summary** | Inter 16px, max 3 lines, regular |
| **Source + Time** | Bottom row: source name (Inter 14px, accent cool) + "2h ago" (Inter 14px, ink secondary) |
| **Reading Time** | Top-right (below ring): "1 min" in JetBrains Mono 12px |
| **Card Padding** | 16px all sides |
| **Card Gap** | 12px between cards |
| **Card Radius** | 8px |
| **Card Elevation** | Level 1 (subtle shadow) |

**Interactions:**

| Gesture | Action |
|---|---|
| **Swipe up** | Next story |
| **Swipe down** | Previous story |
| **Swipe right** | Save story |
| **Swipe left** | Share story |
| **Tap card** | Open full article |
| **Long press** | Quick actions (save, share, hide source) |
| **Pull down** | Refresh digest |

**The card is the unit of consumption.** Users don't scroll through a list — they swipe through cards, one at a time, like a deck. This creates a "just one more" feeling that drives engagement without infinite scroll fatigue.

### 4.4 Explore Screen

| Element | Specification |
|---|---|
| **Search Bar** | Top, full width, "Search news..." placeholder |
| **Trending Topics** | Horizontal scroll of trending hashtags/topics |
| **Categories Grid** | 2x3 grid of category cards with icons and story counts |
| **Sources List** | "Followed sources" with follow/unfollow toggles |

### 4.5 Saved Screen

| Element | Specification |
|---|---|
| **Saved Stories** | List of saved stories with swipe-to-delete |
| **Read Later** | Stories marked for later reading |
| **Downloaded** | Offline-downloaded digests |

**Empty state:** "No saved stories yet. Swipe right on any story to save it here." + illustration of a bookmark with a ring around it.

### 4.6 Profile Screen

| Element | Specification |
|---|---|
| **User Avatar** | Generated from phone number (first letter of name) |
| **Phone Number** | Display only |
| **Language** | Current language, tappable to change |
| **Subscription Tier** | Free / Premium, with upgrade CTA |
| **Notifications** | Toggle: Breaking news, Daily digest, Weekly summary |
| **Data Saver** | Toggle: Reduce image quality, limit prefetch |
| **Display Density** | Toggle: Comfortable (default) / Compact (reduced spacing, smaller text for low-end devices) |
| **About** | App version, terms, privacy policy |

### 4.7 Full Article View

| Element | Specification |
|---|---|
| **Header** | Back arrow, source name, share button |
| **Headline** | Fraunces 28px, full width |
| **Byline** | Author (if available), date, reading time |
| **Hero Image** | Full width, 16:9 ratio, lazy-loaded |
| **Article Body** | Inter 16px, 65ch max width, justified left |
| **AI Summary Box** | Highlighted box at top: "AI Summary: [40-80 word summary]" |
| **Related Stories** | 3 related story cards at bottom |
| **Bottom Bar** | Save, Share, Listen (audio), Open in Browser |

**The AI Summary Box is the differentiator.** Even when reading the full article, the AI summary is prominently displayed at the top — reinforcing the value proposition and giving users the option to read just the summary and leave.

### 4.8 Premium Paywall

| Element | Specification |
|---|---|
| **Trigger** | User taps "Go Ad-Free" or encounters 5th ad |
| **Design** | Full-screen modal, ground color background |
| **Headline** | "Read without interruptions." |
| **Price** | "Rwf 300/month — less than a coffee" |
| **Features** | 3 checkmarks: Ad-free reading, Offline mode, Audio summaries |
| **CTA** | "Start Free Trial" (7 days free) |
| **Ring Animation** | Ring fills from 0% to 100% with "60 seconds" label |
| **Terms** | "Cancel anytime. Auto-renews monthly." |

---

## 5. Interaction Design

### 5.1 Motion Principles

| Principle | Specification |
|---|---|
| **Duration** | 200–300ms for micro-interactions, 400–600ms for screen transitions |
| **Easing** | Ease-out for entrances, ease-in for exits, ease-in-out for state changes |
| **Properties** | Only opacity and transform — never animate layout properties |
| **Exits** | 0.7x entrance duration (exits are faster than entrances) |
| **Distance** | Duration scales with distance: 4px toggle = 120ms, 600px transition = 320ms |

### 5.2 Key Micro-Interactions

| Interaction | Animation | Duration |
|---|---|---|
| **Story card entrance** | Fade in + slide up 8px | 250ms |
| **Story card exit** | Fade out + slide down 8px | 175ms |
| **Ring progress** | Arc fills clockwise, smooth | Continuous |
| **Save action** | Bookmark icon fills with accent color | 200ms |
| **Share action** | Share sheet slides up from bottom | 300ms |
| **Pull to refresh** | Ring spins, then fills to 100% | 800ms |
| **Tab selection** | Indicator slides to active tab | 200ms |
| **Button press** | Scale down to 0.97, then back | 100ms |
| **Ad insertion** | Fade in, no layout shift | 200ms |

### 5.3 Gesture Design

| Gesture | Action | Feedback |
|---|---|---|
| **Swipe up** | Next story | Card slides up, next card peeks from bottom |
| **Swipe down** | Previous story | Card slides down, previous card peeks from top |
| **Swipe right** | Save | Card slides right, bookmark icon appears |
| **Swipe left** | Share | Card slides left, share sheet appears |
| **Tap** | Open | Card scales to 0.98, then opens |
| **Long press** | Quick actions | Haptic feedback, action sheet appears |
| **Pull down** | Refresh | Ring spins, haptic on release |

**Haptic feedback:** Light tap on save, medium tap on refresh complete, heavy tap on error. Haptics are used sparingly — only for confirmations and errors, not for every interaction.

### 5.4 State Transitions

| State | Visual | Transition |
|---|---|---|
| **Loading** | Skeleton cards (grey placeholders) | Fade in content when ready |
| **Empty** | Illustration + message + CTA | N/A |
| **Error** | Icon + message + retry button | Slide down from top |
| **Offline** | Banner at top + offline indicator | Slide down, stays until online |
| **Success** | Checkmark + message | Auto-dismiss after 2 seconds |

---

## 6. Accessibility Requirements

### 6.1 WCAG 2.2 AA Compliance

| Requirement | Specification |
|---|---|
| **Contrast ratio** | Minimum 4.5:1 for body text, 3:1 for large text |
| **Touch targets** | Minimum 44x44px for all interactive elements |
| **Text spacing** | Line height 1.5x, paragraph spacing 2x, letter spacing 0.12x |
| **Focus indicators** | Visible focus ring on all interactive elements |
| **Screen reader** | All images have alt text, all buttons have labels |
| **Dynamic type** | Supports system font size settings up to 200% |

### 6.2 Low-Vision Support

| Feature | Specification |
|---|---|
| **High contrast mode** | Increases contrast ratio to 7:1 |
| **Large text mode** | Scales all text by 1.5x |
| **Bold text** | Increases font weight across all text |
| **Reduce motion** | Disables all non-essential animations |

### 6.3 Display Density Modes

| Mode | Target User | Spacing | Text Size | Card Padding |
|---|---|---|---|---|
| **Comfortable** (default) | Most users | Full (4/8/16/24/32/48) | Full scale | 16px |
| **Compact** | Low-end devices, power users | Reduced (4/8/12/16/24/32) | 90% scale | 12px |

**Behavior:**
- Toggle in Profile → Settings → Display Density
- Preference persists across sessions
- Compact mode reduces data usage by ~20% (fewer pixels, smaller images)
- All touch targets remain ≥ 44x44px in both modes

### 6.4 Color Independence

**No information is conveyed by color alone.** Category tags use both color AND text labels. The 60-Second Ring uses both color AND a numerical percentage. Error states use both color AND an icon.

### 6.5 Design System Decision

**Why OneNews does NOT adopt the AfroBridge "Institutional Brutalism" palette:**

| Aspect | AfroBridge ABI | OneNews | Rationale |
|---|---|---|---|
| **Palette** | Obsidian #0A0A0C + Amber #D4AF37 | Warm off-white #FAFAF8 + Forest green #1B7A3D | ABI targets investors/professionals; OneNews targets commuters. Warm + green signals "East Africa, growth, trust" |
| **Type** | Neo-grotesque sans only | Fraunces serif + Inter + JetBrains Mono | Serif headlines give editorial credibility — feels like a newspaper, not a terminal |
| **Mood** | Cold, data-dense, "Stripe-like" | Warm, concise, "informed friend" | OneNews is a consumer product, not a B2B tool |
| **Density** | Compact only | Comfortable + Compact toggle | OneNews serves both low-end Android and premium devices |

**Adopted from AfroBridge:**
- Supabase as backend/database (faster MVP than raw AWS/GCP)
- Flutterwave for pan-African payments (M-Pesa, cards, multi-currency)
- JetBrains Mono for data/timestamps (already in spec)
- Adaptive density controls (Comfortable vs. Compact)

---

## 7. Performance Requirements

### 7.1 Speed

| Metric | Target | Maximum |
|---|---|---|
| **App launch** | < 2 seconds | 3 seconds |
| **Digest load** | < 1 second | 2 seconds |
| **Story card render** | < 100ms | 200ms |
| **Search results** | < 500ms | 1 second |
| **Article load** | < 2 seconds | 3 seconds |

### 7.2 Data Usage

| Metric | Target | Maximum |
|---|---|---|
| **Digest load (text only)** | < 100KB | 200KB |
| **Digest load (with images)** | < 500KB | 1MB |
| **Per-story images** | < 50KB | 100KB |
| **Offline digest (3 days)** | < 2MB | 5MB |

### 7.3 Battery

| Metric | Target |
|---|---|
| **Background refresh** | Every 30 minutes max |
| **Push notifications** | Batched, not instant |
| **Location** | Never accessed |
| **Animation** | GPU-accelerated, 60fps |

---

## 8. Usability Testing Criteria

### 8.1 First-Time User Test

| Task | Success Criteria |
|---|---|
| **Complete onboarding** | < 30 seconds, no errors |
| **Read first story** | < 10 seconds from app launch |
| **Understand the ring** | Can explain what the ring shows without prompting |
| **Find a category** | < 5 seconds to navigate to a category |
| **Save a story** | < 5 seconds to save a story |
| **Upgrade to premium** | < 60 seconds from paywall to payment |

### 8.2 Returning User Test

| Task | Success Criteria |
|---|---|
| **Resume reading** | App opens to exact story where they left off |
| **Find saved stories** | < 5 seconds to find a saved story |
| **Switch language** | < 10 seconds to switch language |
| **Search** | < 15 seconds to find a specific story |
| **Share** | < 10 seconds to share a story |

### 8.3 Accessibility Test

| Task | Success Criteria |
|---|---|
| **Navigate with screen reader** | All elements reachable and labeled |
| **Use high contrast mode** | All text readable, all interactions visible |
| **Use large text mode** | No text clipping, no layout breakage |
| **Navigate with one hand** | All primary actions reachable with thumb |

---

## 9. Differentiation — Why OneNews Is Better

### 9.1 vs. Google News

| Dimension | Google News | OneNews |
|---|---|---|
| **Time to informed** | 30+ minutes | 60 seconds |
| **Content** | Endless scroll | Curated digest |
| **Local languages** | None | Kinyarwanda, Swahili, English |
| **Offline mode** | Limited | Full offline digests |
| **Price** | Free (data harvesting) | Free or $0.20/month |
| **Trust** | Algorithmic, opaque | Transparent sources |

### 9.2 vs. Inshorts

| Dimension | Inshorts | OneNews |
|---|---|---|
| **Market** | India only | East Africa |
| **Local content** | None | Deep local coverage |
| **Local languages** | Hindi, English | Kinyarwanda, Swahili, English |
| **Mobile money** | No | Yes (MoMo, M-Pesa) |
| **Audio** | No | AI voice summaries |
| **Offline** | Yes | Yes |

### 9.3 vs. KandaNews

| Dimension | KandaNews | OneNews |
|---|---|---|
| **Format** | Digital flipbook | AI summaries |
| **Time to read** | 15–30 minutes | 60 seconds |
| **AI-powered** | No | Yes |
| **Price** | $2.25/month | $0.20/month |
| **Personalization** | No | Yes |
| **Offline mode** | No | Yes |
| **Scale** | 1,000+ readers/country | Target: 100K+ users |

### 9.4 vs. WhatsApp News

| Dimension | WhatsApp | OneNews |
|---|---|---|
| **Verification** | None | Source attribution |
| **Structure** | Chaotic | Curated digest |
| **Time** | Hours of scrolling | 60 seconds |
| **Trust** | Low | High (transparent sources) |
| **Data usage** | High (images, videos) | Low (text-first) |

---

## 10. Design Tokens Summary

```json
{
  "color": {
    "ground": { "light": "#FAFAF8", "dark": "#0F0F0E" },
    "surface": { "light": "#FFFFFF", "dark": "#1A1A18" },
    "ink": { "light": "#1A1A18", "dark": "#F5F5F0" },
    "inkSecondary": { "light": "#6B6B60", "dark": "#A0A098" },
    "accent": { "light": "#1B7A3D", "dark": "#4ADE80" },
    "accentWarm": { "light": "#D97706", "dark": "#FBBF24" },
    "accentCool": { "light": "#2563EB", "dark": "#60A5FA" },
    "danger": { "light": "#DC2626", "dark": "#F87171" },
    "rule": { "light": "#E5E5DE", "dark": "#2A2A26" }
  },
  "type": {
    "display": { "family": "Fraunces", "size": "28px", "weight": 700, "tracking": "-0.02em" },
    "headline": { "family": "Fraunces", "size": "22px", "weight": 600, "tracking": "-0.01em" },
    "body": { "family": "Inter", "size": "16px", "weight": 400, "tracking": "0" },
    "label": { "family": "Inter", "size": "12px", "weight": 500, "tracking": "+0.04em" },
    "caption": { "family": "Inter", "size": "14px", "weight": 400, "tracking": "0" },
    "mono": { "family": "JetBrains Mono", "size": "12px", "weight": 400, "tracking": "0" }
  },
  "space": { "xs": "4px", "sm": "8px", "md": "16px", "lg": "24px", "xl": "32px", "xxl": "48px" },
  "radius": { "sm": "4px", "md": "8px", "lg": "16px", "full": "9999px" },
  "elevation": {
    "0": "none",
    "1": "0 1px 2px rgba(0,0,0,0.06)",
    "2": "0 4px 12px rgba(0,0,0,0.08)",
    "3": "0 8px 24px rgba(0,0,0,0.12)"
  },
  "motion": {
    "fast": "120ms",
    "normal": "250ms",
    "slow": "400ms",
    "easing": {
      "enter": "cubic-bezier(0.16, 1, 0.3, 1)",
      "exit": "cubic-bezier(0.7, 0, 0.84, 0)",
      "inOut": "cubic-bezier(0.65, 0, 0.35, 1)"
    }
  }
}
```

---

## 11. Design Principles

### 11.1 The 60-Second Rule
Every screen must be scannable in under 5 seconds. If a user can't understand what they're looking at within 5 seconds, the design has failed.

### 11.2 The Card Is the Unit
Users don't scroll through lists — they swipe through cards, one at a time. This creates a "just one more" feeling that drives engagement without infinite scroll fatigue.

### 11.3 The Ring Is the Identity
The 60-Second Ring appears on every screen, always visible, always ticking. It's the app's signature — the one element that makes OneNews unmistakably OneNews.

### 11.4 Sources Are Sacred
Every story shows its source. Every summary shows its confidence. Every article shows its origin. Trust is the product.

### 11.5 Offline Is Not Optional
The app must work flawlessly offline. Downloads must be automatic. Reading must be seamless. Offline is a feature, not a limitation.

### 11.6 Motion Serves Meaning
Every animation communicates something. The ring filling means "you're making progress." The card sliding means "there's more to read." If an animation doesn't mean something, it doesn't exist.

---

## 12. Next Steps

| Step | Action | Owner | Timeline |
|---|---|---|---|
| 1 | Create high-fidelity mockups of all screens | Design | Week 1–2 |
| 2 | Build interactive prototype (Figma) | Design | Week 2–3 |
| 3 | Conduct usability testing with 10 users | Design | Week 3–4 |
| 4 | Iterate based on feedback | Design | Week 4–5 |
| 5 | Create design system in code (Flutter) | Dev | Week 5–8 |
| 6 | Build and test all screens | Dev | Week 8–12 |
| 7 | Conduct accessibility audit | QA | Week 12 |
| 8 | Final design polish | Design | Week 12–13 |

---

*Document generated: September 2026*  
*Next review: October 2026*
