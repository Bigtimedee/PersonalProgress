# Personal Progress — AI Layer Roadmap

*A design document for a future AI integration that assists judgment without replacing it.*

---

## Principles

Before anything else, five constraints that cannot be traded away:

1. **AI assists; you decide.** Every AI output is a suggestion, not a directive. The user always acts last.
2. **Privacy remains absolute.** No content leaves the device unless the user explicitly initiates it. AI runs locally or under an explicit, consented API call.
3. **Authorship stays with you.** AI never writes your annual letter, your reflection, or your priorities for you. It asks questions, offers framings, or surfaces patterns — you write.
4. **No preachiness.** AI never tells you what to prioritize, how to feel, or what success should look like. It reflects back what you have already said.
5. **No emotional flattening.** Nuanced, contradictory, or uncertain feelings are preserved. AI does not smooth them into productivity-speak.

---

## 1. Future-State AI Product Spec

### 1.1 Vision Refinement

**What it does:** After the user drafts their annual letter, AI can ask one or two clarifying questions that help the user sharpen the vision — not by suggesting content, but by finding vagueness or tension in what was written.

**What it does not do:** Rewrite the letter. Suggest better phrasing. Grade the quality of the vision.

**Sample interaction:**
> *"You mentioned wanting to be more present with your family and also wanting to push harder at work. Those might be in tension this year. Worth naming that explicitly?"*

The user reads, considers, and decides whether to revise. AI does not touch the letter.

---

### 1.2 Reflection-to-Action Surfacing

**What it does:** After a weekly reflection is saved, AI can optionally identify one or two things from the reflection text that sound like an intention without a home — something the user wrote about wanting to do that isn't captured as an intention or priority anywhere.

**What it does not do:** Create actions automatically. Add items to any list. Push notifications about unresolved reflections.

**Sample interaction:**
> *"You mentioned wanting to reconnect with an old friend. That hasn't appeared in your priorities before. Do you want to add it somewhere?"*

The user taps yes or dismisses. If yes, they write the priority themselves.

---

### 1.3 Drift Detection

**What it does:** AI monitors the gap between what the user said mattered (their identity statements, intentions, annual letter themes) and what they have actually written about over recent weeks. When a meaningful gap appears, AI can name it once, quietly.

**What it does not do:** Nag. Repeat the same observation. Surface drift more than once per cycle unless new evidence emerges. Assign blame or shame.

**Sample interaction (in the Year at a Glance or domain card):**
> *"You described [Domain] as central to this year, but it hasn't come up in your last four reflections. That might be fine — or worth a look."*

This surfaces once. The user can dismiss it permanently for that period.

---

### 1.4 Weekly Priority Proposals

**What it does:** At the start of a new weekly reflection, AI can optionally propose three candidate priorities — derived entirely from the user's own stated intentions, carry-forward items from the prior week, and domain status — as a starting point. The user can accept, edit, reject, or ignore entirely.

**What it does not do:** Set priorities without user action. Push priorities that contradict what the user has written they want. Inflate urgency.

**Sample interaction:**
> *"Based on what you wrote last week and your active intentions, here are three possible priorities for this week. Tap any to add, or write your own."*
>
> - [ ] *Draft Q2 strategy doc (carry-forward from last week)*
> - [ ] *Call dad (from Health domain intention)*
> - [ ] *30-minute creative session (from Creative domain)*

User modifies these freely.

---

### 1.5 Quarterly Progress Summary

**What it does:** At the start of a quarterly review, AI can generate a plain-language summary of the quarter: how many reflections were completed, which domains appeared most/least in reflections, key highlights from across the weekly entries, and patterns in priority-setting. This is a structured digest — raw material for the user's own review writing.

**What it does not do:** Write the quarterly review. Assign a grade or score to the quarter. Compare this quarter to prior quarters in a ranking.

**Sample digest:**
> *"Q1 in brief: You completed 11 of 13 weekly reflections. Health appeared in 9 of them. Work appeared in all 13 — often as a priority, sometimes as a concern. You mentioned your annual theme ([word]) 3 times across entries. The highlight you cited most often was [theme from entries]."*

---

### 1.6 Clarity Questions

**What it does:** When a user is composing a vision statement, identity statement, or annual letter, AI can offer a small set of optional Socratic questions that help the user find what they actually mean. These are triggered on-demand by the user — never automatic.

**What it does not do:** Interrupt the writing flow. Appear without being requested. Suggest that the writing needs improvement.

**Sample questions for an identity statement:**
> - *What would you do differently this year if this identity were already true?*
> - *What would someone close to you notice if this identity took hold?*
> - *Is there something in here you're afraid of committing to?*

---

## 2. UX Patterns for AI Interaction

### 2.1 The Nudge Card

A soft, dismissable card that appears in context (below a reflection, on a domain view, at the start of a quarterly review). Light background, no iconography that implies urgency. Dismiss is permanent for the period — it does not return.

```
┌─────────────────────────────────────────┐
│  You mentioned wanting to read more     │
│  this year. It hasn't appeared in your  │
│  last few reflections.                  │
│                              [Dismiss]  │
└─────────────────────────────────────────┘
```

### 2.2 The Optional Expansion

AI functionality lives behind an explicit user gesture — a button, a tap, a deliberate action. It is never ambient or automatic. The UI communicates that this is optional assistance, not a required step.

```
[ Suggest priorities from my intentions ]
```

Tapping this produces candidate content. Not tapping it is the default state.

### 2.3 The Divergence Signal

In domain cards or the Year at a Glance, a subtle indicator (not a red badge — more like a muted dot or note) that AI has detected a gap between stated intention and recent engagement. Tapping reveals the observation. The user can dismiss or explore.

No score. No percentage. No "you are 30% off track." Just a quiet signal.

### 2.4 The Digest View

Before a quarterly review, an optional one-screen digest — like a brief that a thoughtful advisor might have prepared before a meeting. Structured, factual, brief. No interpretation. The user reads it and decides what it means.

### 2.5 The Clarifying Question

A small secondary action inside writing flows: *"Ask a question"* or *"Help me think through this."* Tapping opens a focused modal with one or two questions surfaced by AI based on what was written. The modal has one job: help the user think. When the user closes it, they write.

### 2.6 Never

- No chat interface. Personal Progress is not a conversation app.
- No AI-generated content inserted into the user's entries without explicit action.
- No suggestions that persist across sessions uninvited.
- No AI features that are on by default.

---

## 3. Boundaries — When AI Should and Should Not Intervene

### AI Should Intervene When:

| Situation | AI Action | Trigger |
|---|---|---|
| Annual letter drafted and saved | Offer optional clarifying questions | On-demand only |
| Weekly reflection saved | Optionally surface unhoused intentions | On-demand only |
| Domain goes 3+ weeks without reflection mention | Surface drift signal once | Automatic but dismissable |
| Starting a quarterly review | Offer optional digest of the quarter | Presented once, not forced |
| Writing an identity statement | Offer optional Socratic questions | On-demand only |
| Starting a new weekly reflection | Offer optional priority proposals from intentions | On-demand only |

### AI Should Never Intervene When:

| Situation | Reason |
|---|---|
| User is mid-writing | Interruption breaks the reflective state |
| User has dismissed a signal | Respect the dismissal permanently |
| An entry is locked | Locked = closed. AI has no business there. |
| User has not yet written anything | No context to work from; nothing to surface |
| A reflection is emotionally heavy or ambiguous | AI cannot read emotional register reliably; silence is correct |
| The user hasn't used the app in weeks | Re-engagement nudges are manipulative |

### Hard Limits:

- AI never modifies stored data directly.
- AI never initiates contact (push notifications for AI suggestions are off by default; the user opts in explicitly).
- AI never references specific content from past entries in a way the user did not sanction (e.g., AI cannot say "in March you wrote that you were struggling" unless the user has opened that entry in the current session).
- AI features are gated behind a single settings toggle. One toggle disables the entire layer.

---

## 4. Technical Integration Roadmap

### Phase 0: Preparation (no AI yet)
*Foundation that makes AI viable without retrofitting.*

- [ ] Ensure all SwiftData models include timestamp metadata (creation, last-modified)
- [ ] Ensure `WeeklyReflection`, `DomainPlan`, `AnnualLetter`, and `QuarterlyReview` are consistently structured enough to be serialized for context assembly
- [ ] Build a `ReflectionSummary` struct (in-memory only) that aggregates recent entries for context — this is the data layer AI will consume
- [ ] Add `UserPreferences` model field: `aiAssistanceEnabled: Bool = false`

---

### Phase 1: On-Device Pattern Detection (no external API)
*Everything runs locally. No API key. No internet.*

**Capabilities:**
- Drift detection: pure Swift logic comparing domain appearance in recent reflections against stated importance. No ML required — just date math and text matching.
- Carry-forward detection: compare last week's priorities against this week's entries for unresolved items
- Frequency summary: compute reflection completion rate, domain mention frequency for quarterly digest

**Technology:** Swift, no dependencies. Runs at reflection-save time and quarter-start time. Results stored in a transient `InsightCache` object — not persisted to SwiftData.

**Timeline:** Can be built now. No external integration needed.

---

### Phase 2: Claude Integration (explicit, consented, on-demand)
*AI capabilities that require language understanding. Uses Claude API. Explicitly triggered by user.*

**Capabilities:**
- Vision refinement questions (annual letter, identity statements)
- Reflection-to-action surfacing
- Weekly priority proposals
- Quarterly digest narrative

**Architecture:**

```
[User taps "Ask a question"]
    → App assembles minimal context payload
    → Sends to Claude API via URLSession
    → Claude returns structured response (questions, suggestions)
    → App presents as dismissable UI
    → Nothing stored unless user explicitly acts
```

**Context payload design (privacy-first):**
- Assembled in-memory at request time
- Contains only what is needed for the specific feature (e.g., vision refinement only sends the current letter text — not all reflections)
- Never includes: device identifiers, name, location, or any data beyond what the user is currently viewing
- Payload is ephemeral — not cached, not logged

**Model recommendation:** Claude Haiku 4.5 (`claude-haiku-4-5-20251001`) for most features — fast, low cost, appropriate for structured tasks. Claude Sonnet 4.6 for quarterly digest narrative where quality matters more than speed.

**API key handling:**
- User-provided key stored in iOS Keychain (never in app bundle or UserDefaults)
- Alternative: future subscription model where the developer holds the key and proxies requests through a minimal server — but this reintroduces a server. Avoid unless adoption warrants it.
- Settings UI: a clearly-labeled "AI Assistance" section with a toggle and a field for the API key, with plain-language explanation of what gets sent and when

---

### Phase 3: Refined Intelligence (future, post-launch)
*Improvements once usage patterns are understood.*

- [ ] Multi-turn clarifying questions (still modal, still on-demand)
- [ ] Cross-year pattern recognition (e.g., "this theme appeared in your letters three years running")
- [ ] Domain-specific AI personas calibrated to the domain type (creative work questions differ from health questions)
- [ ] Local LLM option via Core ML when Apple's on-device models mature sufficiently (eliminates the API key requirement entirely)

---

## 5. How to Use Claude Safely and Elegantly

### The Right Mental Model

Claude is not a coach, therapist, or advisor embedded in the app. Claude is a **reading and pattern-recognition layer** — it reads what you have written, identifies structures you may not have noticed, and asks questions back. The human writes. Claude reads and asks.

This maps cleanly to what Claude is actually good at and avoids the failure modes that would damage the product.

### Prompt Design Principles

**Be explicit about the constraint.** Every system prompt for Personal Progress AI should open with:
> *"You are a reading assistant for a personal reflection app. Your role is to ask clarifying questions and surface patterns — never to write the user's content for them, never to tell them what to prioritize, and never to interpret their emotional state."*

**Ground responses in the user's own words.** When surfacing a pattern or asking a question, Claude should quote or paraphrase from the user's text — not introduce new language or concepts.

**Keep outputs short.** AI outputs in Personal Progress should be brief: one or two questions, a three-item list, a short summary. Never a paragraph of unsolicited advice.

**Structured output over prose.** Use JSON or structured formats for AI responses so the app controls how they are rendered — not Claude. This prevents Claude from accidentally writing in a tone that conflicts with the product voice.

**Sample system prompt for vision refinement:**
```
You are a reading assistant for a personal reflection app. The user has written their annual letter — a personal vision statement for the year ahead. Your only job is to ask one or two short questions that help the user sharpen what they have already written. Do not suggest what they should want. Do not rewrite their words. Do not add themes or ideas they did not introduce. Ask only questions that arise directly from the text. Return your response as a JSON array of question strings, maximum two items.
```

### Failure Modes to Prevent

| Failure Mode | Prevention |
|---|---|
| Claude writes content the user should have written | Strict prompt constraint; never ask Claude to "write" or "draft" |
| Claude interprets emotional content incorrectly | Never use Claude on emotionally sensitive entries; add detection heuristic to skip if reflection contains certain signal words |
| Claude output conflicts with app voice | All Claude output goes through a rendering layer the app controls — never injected as raw text |
| Claude output feels generic or hollow | Ground every prompt in the user's actual text; never let Claude respond to an empty context |
| API cost exceeds user's expectations | Show estimated token count before each API call; allow user to cancel |

### When to Not Use Claude

- When the user hasn't written enough for Claude to have context
- When the user has locked an entry (it is complete; leave it alone)
- When the feature can be accomplished with deterministic Swift logic (drift detection, frequency counting, carry-forward detection)
- When a user has toggled AI assistance off

### The Long-Term Vision

The most elegant version of AI in Personal Progress is invisible most of the time. It surfaces once a week, asks a single question you hadn't thought to ask yourself, and then gets out of the way. You write your reflection. You set your priorities. You make your choices.

AI earns trust in this product by staying in its lane.

---

*Last updated: 2026-04-09*
