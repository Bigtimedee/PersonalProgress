# Personal Progress — Product Requirements Document

**Version:** 1.0
**Date:** April 2026
**Status:** Draft for Review

---

## 1. Product Vision

Most personal growth fails not from lack of ambition but from lack of continuity. People write extraordinary planning letters in January — articulate, honest, alive with intention — and then watch them fade by February.

Personal Progress is the app that keeps your annual letter alive all year.

It is not a habit tracker. It is not a journal app. It is not a goal manager. It is a private operating system for intentional living — a single place where the person you decided to become at the start of the year remains present, visible, and actionable in every week that follows.

The source of truth is always your annual letter. Everything else in the app is in service of that document.

---

## 2. Core User Promise

> "Your yearly intentions never fade. They become the lens through which you experience every week."

Every week, you will know exactly who you are trying to be, what you are trying to accomplish, and whether you are living accordingly. When you drift — and you will — the app brings you home without shame.

---

## 3. Target User

**Primary:** A single user: the app author. This is a deeply personal, private tool.

**Archetype for design decisions:** A driven, self-aware person (30s–50s) who:
- Writes an annual planning letter or personal manifesto
- Has clear values and long-term commitments
- Struggles to maintain connection to those commitments as weeks fill up
- Finds typical goal apps either too shallow, too gamified, or emotionally hollow
- Values depth, calm, and intentionality in the tools they use
- Does not want their inner life to feel like a project management board

**This person is not:** A productivity optimizer gaming habits, a social goal-sharer, or a person who wants AI to tell them what to do.

---

## 4. Jobs To Be Done

### Primary Jobs

**JTBD-1: Reconnect to identity when I feel reactive or adrift**
When I am caught in the busyness of life and losing sight of who I am trying to be, I want to quickly return to my anchoring commitments so that I can make decisions from my values rather than from urgency.

**JTBD-2: Plan my week against what actually matters**
When I sit down to plan my week, I want to see my priorities across all life domains so that I allocate time intentionally rather than reactively.

**JTBD-3: Hold myself accountable honestly and privately**
When a week or quarter ends, I want a structured space to reflect on my progress without external judgment so that I can be truthful with myself and carry that honesty forward.

**JTBD-4: Translate annual intentions into specific weekly actions**
When I read my annual letter, I want to see the concrete rituals and actions I committed to so that I do not lose the specificity of my intentions in the abstraction of aspirations.

**JTBD-5: Know at a glance if I am living in alignment with my commitments**
When I open the app, I want a clear, honest signal about where I am thriving and where I am neglecting things so that I can redirect my attention before a quarter slips away.

### Secondary Jobs

**JTBD-6: Preserve and re-read the emotional texture of my annual letter**
When I need motivation or perspective, I want to read my own words at their most honest and aspirational so that I remember why I started.

**JTBD-7: Conduct a meaningful quarterly review**
When a quarter ends, I want a guided process to honestly evaluate each domain so that I enter the next quarter with clarity about what to carry forward and what to change.

**JTBD-8: Remember the specific commitments I made**
When I have forgotten what I agreed to in January, I want to quickly surface my exact actions, rituals, and standards so that I can hold myself to them rather than reconstructing them from memory.

---

## 5. Design Principles

### 5.1 Dignity Over Gamification
No streaks. No badges. No points. No confetti. This app deals with the whole of a person's life. Trivializing it with game mechanics would corrupt its purpose. Progress is measured in honest self-reflection, not engagement metrics.

### 5.2 Annual Rhythm as Foundation
Every feature flows from the annual letter. Weekly and quarterly workflows are not standalone features — they are instruments for honoring annual intentions. The year is the atomic unit, not the day.

### 5.3 Emotional Fidelity
The app must preserve the voice, tone, and emotional weight of the planning letter. It must never flatten aspiration into a checklist. A success statement like "I will be the husband she deserves" must be treated with the gravity it carries, not reduced to a progress bar.

### 5.4 Privacy as Architecture
This app contains more intimate data than most people's therapy notes. It must be local-first, with no telemetry, no analytics, no server calls, and no capability to share data. Privacy is not a feature; it is a design constraint that precedes all others.

### 5.5 Pull Over Push
The app invites reflection; it does not nag. Notifications are gentle, infrequent, and chosen by the user. The experience should feel like a trusted mentor asking "how's it going?" — not a reminder system demanding compliance.

### 5.6 Calm and Serious
The visual design should feel like a high-quality physical journal, not a tech product. Whitespace, typography, and restraint. The app should feel good to open. Calm enough to think in. Serious enough to trust.

### 5.7 Depth Over Features
Every feature in v1 should be excellent. No feature should feel half-built. It is better to do six things beautifully than twelve things adequately. If a feature would compromise quality or emotional tone, defer it.

---

## 6. V1 Feature Set

### 6.1 Annual Letter
The founding document of the app. The user can paste or type their annual planning letter. The raw text is preserved exactly as written and accessible at any time. The letter is also the source from which domains, success statements, and committed actions are derived.

The letter view is not an editor after initial setup — it is a reading experience. The user reads their own words.

### 6.2 Domain Dashboard
The home screen. Displays all life domains (e.g., Spouse, Children, Family, Work, Friendships, Health, Hobbies, Investments) with:
- A color and icon per domain
- The domain's current success statements
- A visual indicator of recent attention (has this domain been reflected on recently?)
- Quick-tap to enter a domain's detail view

Domains are fully customizable: name, icon, color, order.

### 6.3 Domain Detail
Each domain has its own space containing:
- All success statements for the current year ("In 2026, I will know I succeeded if...")
- All committed actions, rituals, and commitments for that domain
- A timeline of past reflections mentioning that domain
- Space for notes

### 6.4 Weekly Reflection
A structured weekly check-in, typically completed Friday or Saturday. It consists of:
- **Intention review:** How did this week align with my weekly intention?
- **Domain pulse:** A brief rating or note per domain (the user chooses which domains to rate)
- **Highlights:** What mattered most this week?
- **Challenges:** Where did I fall short or struggle?
- **Free reflection:** Anything else on my mind
- **Next week's intention:** A single sentence that defines the coming week

Weekly reflections are saved, timestamped, and browsable.

### 6.5 Weekly Planning Prompt
Available Sunday or any chosen day. A simple view that surfaces:
- The current week's intention (to be set or confirmed)
- Each domain's most recent reflection date
- A reminder of key committed actions/rituals for this week
- Domains that have not received attention recently (surfaced gently, not alarmingly)

### 6.6 Quarterly Review
A structured deep-dive at the end of each quarter (March, June, September, December). Workflow:
- Review each domain's success statements one by one
- Write a free-form reflection on progress in that domain
- Note what should carry forward, change, or be released
- Write an overall quarterly reflection
- View a summary of the quarter's weekly reflections

The completed quarterly review is preserved and readable like a journal entry.

### 6.7 Letter Import and Structuring
The onboarding flow (and any future re-import) includes:
- Paste or type the full annual letter text
- The full text is preserved as the sacred document
- The user manually assigns success statements and committed actions to domains
- Pre-populated default domains offered; user modifies

### 6.8 Notification System
Local notifications only. Types:
- Weekly planning prompt (user-chosen day and time, default: Sunday 7pm)
- Weekly reflection prompt (user-chosen day and time, default: Friday 7pm)
- Quarterly review reminder (triggered at quarter-end)
- Optional: a mid-week intention pulse ("How is your week going?")

All notification types can be independently enabled/disabled and timed.

### 6.9 Privacy Lock
Optional biometric lock (Face ID / Touch ID) on app open. The app contains sensitive personal data and must allow the user to protect it from accidental exposure.

---

## 7. V2 Feature Set

### 7.1 AI-Assisted Letter Parsing
An on-device or privacy-respecting AI pass over the annual letter that proposes domain assignments, success statement extractions, and committed action identification — with the user approving each suggestion. This dramatically reduces the manual setup burden.

### 7.2 iCloud Sync
Encrypted, user-owned iCloud sync so data is preserved across device replacements and accessible (read-only) on iPad.

### 7.3 Home Screen Widget
A small widget showing the current week's intention and a single domain to focus on. No data is exposed; only the intention sentence.

### 7.4 Apple Watch Companion
A minimal watch face showing the current week's intention and a simple "how am I doing today?" input (1–5 scale per a chosen domain). Syncs back to the iPhone app.

### 7.5 Year-Over-Year Comparison
When a new annual letter is written, the app preserves the previous year's letter and all reflections. A comparison view shows how themes, language, and priorities have evolved across years.

### 7.6 Domain Journaling
A free-form journaling layer within each domain — unstructured writing space separate from structured reflections.

### 7.7 Siri Shortcuts
"Set my intention for the week" → opens the weekly planning screen.
"Open my planning letter" → opens the letter view.
"Start my Friday reflection" → opens weekly reflection.

### 7.8 Export
Export the full year — letter, reflections, quarterly reviews — as a beautifully formatted PDF or structured markdown file. This is the user's personal record.

---

## 8. User Stories

**US-01:** As a user, I can paste my annual planning letter into the app so that my yearly intentions are preserved and accessible.

**US-02:** As a user, I can define the life domains that matter to me and assign colors and icons so that the dashboard reflects my real life.

**US-03:** As a user, I can assign success statements from my letter to each domain so that I always know what success looks like in each area.

**US-04:** As a user, I can assign committed actions and rituals from my letter to domains so that I have a clear record of what I agreed to do.

**US-05:** As a user, I can open the app and immediately see which domains have and have not received attention recently so that I know where I am neglecting my intentions.

**US-06:** As a user, I can complete a weekly reflection that captures the quality of my week across domains so that I maintain honest awareness of my progress.

**US-07:** As a user, I can set a weekly intention — a single sentence defining what the coming week is about — so that my weeks have a guiding theme.

**US-08:** As a user, I can read my previous weekly reflections so that I can see patterns over time.

**US-09:** As a user, I can complete a quarterly review that honestly evaluates my progress against success statements so that each quarter closes with clarity.

**US-10:** As a user, I can re-read my annual letter in its original voice at any time so that I stay connected to its emotional weight and intention.

**US-11:** As a user, I can receive a gentle notification on Sunday to set my weekly intention and on Friday to complete my reflection so that the weekly cadence becomes a habit.

**US-12:** As a user, I can lock the app with Face ID so that my private reflections are protected.

**US-13:** As a user, I can customize which notifications I receive and when so that the app fits my schedule rather than imposing one.

---

## 9. Functional Requirements

### FR-01: Annual Letter
- Store raw text of annual letter verbatim
- Support multiple years (archived prior years)
- Letter text is immutable after a lock date (end of January); editable before
- Display letter in a reading-optimized view with comfortable typography

### FR-02: Domains
- Support 2–12 domains
- Each domain: name (max 30 chars), color (from curated palette), icon (from curated SF Symbols set), sort order
- Pre-populated defaults: Spouse, Children, Family, Work, Friendships, Health, Hobbies, Investments
- User can add, rename, reorder, hide, or archive domains
- Archived domains retain all historical data

### FR-03: Success Statements
- Each domain supports 1–5 success statements per year
- Text format: free form, no character limit
- Displayed prominently in domain detail
- Displayed during weekly planning and quarterly review workflows

### FR-04: Committed Actions
- Each domain supports unlimited committed actions
- Each action has: text, type (action / ritual / commitment), frequency (daily / weekly / monthly / as needed)
- Actions can be marked active or archived
- Actions surface in the weekly planning view by frequency

### FR-05: Weekly Reflection
- One reflection per week (keyed by week start date, Monday)
- Required fields: weekly intention (text), overall impression (1–5 rating)
- Optional fields: highlights (text), challenges (text), domain ratings (per-domain 1–5), free reflection (text), next week intention
- Reflections are immutable 48 hours after creation (to preserve honest record)
- All reflections are browsable in reverse chronological order

### FR-06: Weekly Planning View
- Shows: current week intention, committed actions due this week, domain last-touched dates
- Allows setting next week's intention
- Does not require completion; it is a view, not a form

### FR-07: Quarterly Review
- One review per quarter per year
- Structured: per-domain reflection (text, 1–5 rating), overall quarterly narrative (text), carry-forward notes
- Triggered by prompt or manually launched
- Reviews are immutable after a lock date (30 days after quarter end)
- Browsable history of all completed reviews

### FR-08: Notifications
- Local notifications only; no push infrastructure
- Types: weekly planning prompt, weekly reflection prompt, quarterly review reminder, optional mid-week pulse
- Each type configurable: enabled/disabled, day of week, time of day
- Notifications deep-link to the appropriate screen

### FR-09: Privacy Lock
- Optional biometric authentication (Face ID / Touch ID with passcode fallback)
- App locks after background period (user-configurable: immediate / 1 min / 5 min / never)

### FR-10: Onboarding
- First launch walks through: welcome, letter import, domain setup, success statement entry (at least one), committed action entry (at least one), notification preferences
- Onboarding can be skipped at any step and resumed later
- All onboarding steps accessible from Settings after initial setup

---

## 10. Non-Functional Requirements

### NFR-01: Performance
- App launch to home screen: under 0.8 seconds on supported hardware
- All transitions and animations: 60fps minimum
- Weekly reflection save: under 200ms

### NFR-02: Offline Behavior
- 100% of all features function without network access
- No features are degraded in offline state
- There is no online state in v1 — the app has no network calls

### NFR-03: Data Persistence
- All data persists through app restarts, device reboots, and iOS updates
- No data loss from normal app lifecycle events
- SwiftData with automatic migration support for schema evolution

### NFR-04: Privacy
- No telemetry
- No analytics
- No crash reporting to external services (use Apple's built-in crash reporting only)
- No network entitlements in v1 (sandbox network access disabled)
- No data collection of any kind

### NFR-05: Accessibility
- Dynamic Type support for all text elements
- VoiceOver labels on all interactive elements
- Sufficient color contrast ratios (WCAG AA minimum)
- No color-only information conveyance

### NFR-06: iOS Version Support
- Minimum deployment target: iOS 17.0
- SwiftData requires iOS 17+; this is a hard constraint

### NFR-07: Device Support
- iPhone only in v1
- All iPhone sizes supported (SE through Max)

### NFR-08: App Size
- App binary under 20MB
- No third-party analytics or SDK bloat

---

## 11. Data Entities

### AnnualLetter
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| year | Int | e.g., 2026 |
| rawText | String | Verbatim letter text |
| importedAt | Date | When created/imported |
| isLocked | Bool | Locked after January |

### Domain
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| name | String | Max 30 characters |
| colorHex | String | From curated palette |
| iconName | String | SF Symbol name |
| sortOrder | Int | User-defined ordering |
| isArchived | Bool | Hides from dashboard |

### SuccessStatement
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| text | String | Full statement text |
| year | Int | Tied to a specific year |
| domain | Domain | Relationship |
| sortOrder | Int | Display order |

### CommittedAction
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| text | String | Description of action |
| type | Enum | action / ritual / commitment |
| frequency | Enum | daily / weekly / monthly / asNeeded |
| domain | Domain | Relationship |
| isArchived | Bool | |
| createdAt | Date | |

### WeeklyReflection
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| weekStartDate | Date | Monday of that week |
| weeklyIntention | String | The week's guiding theme |
| overallRating | Int | 1–5 |
| highlights | String? | Optional |
| challenges | String? | Optional |
| freeReflection | String? | Optional |
| nextWeekIntention | String? | Optional |
| completedAt | Date | |
| isLocked | Bool | Immutable after 48h |

### DomainWeeklyRating
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| reflection | WeeklyReflection | Parent |
| domain | Domain | Relationship |
| rating | Int? | 1–5, optional |
| note | String? | Optional note |

### QuarterlyReview
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| year | Int | |
| quarter | Int | 1–4 |
| overallNarrative | String | Required |
| carryForwardNotes | String? | Optional |
| completedAt | Date | |
| isLocked | Bool | Immutable after 30 days |

### DomainQuarterlyReview
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| quarterlyReview | QuarterlyReview | Parent |
| domain | Domain | Relationship |
| reflection | String | Free-form text |
| rating | Int | 1–5 |
| carryForward | String? | What to bring into next quarter |

### NotificationPreferences
| Field | Type | Notes |
|-------|------|-------|
| weeklyPlanningEnabled | Bool | |
| weeklyPlanningDay | Int | 0=Sun, 1=Mon... |
| weeklyPlanningTime | DateComponents | |
| weeklyReflectionEnabled | Bool | |
| weeklyReflectionDay | Int | |
| weeklyReflectionTime | DateComponents | |
| quarterlyReviewEnabled | Bool | |
| midWeekPulseEnabled | Bool | |
| midWeekPulseDay | Int | |
| midWeekPulseTime | DateComponents | |

---

## 12. Navigation Model

### Tab Bar (persistent)
1. **Home** — Domain dashboard and week status
2. **Reflect** — Weekly reflection and planning workflow
3. **Letter** — Annual letter reading view
4. **Reviews** — Quarterly review list and history
5. **Settings** — Domains, notifications, privacy, export

### Home Tab
```
Home
├── Domain Dashboard (grid or list)
│   └── Domain Detail
│       ├── Success Statements
│       ├── Committed Actions
│       └── Reflection History (filtered)
└── This Week Card (taps to Reflect tab)
```

### Reflect Tab
```
Reflect
├── Weekly Reflection (current or create new)
├── Weekly Planning View
└── Reflection History (all past weeks, browsable)
```

### Letter Tab
```
Letter
├── Current Year Letter (reading view)
└── Past Years Archive
```

### Reviews Tab
```
Reviews
├── Current Quarter Review (create or continue)
└── Past Quarterly Reviews (browsable)
```

### Deep Links (from notifications)
- Weekly planning notification → Reflect tab, weekly planning view
- Weekly reflection notification → Reflect tab, new reflection
- Quarterly review notification → Reviews tab, current quarter review

---

## 13. Notification Philosophy

### Core Principle
Notifications are invitations, not demands. Each one should feel like a trusted friend asking a meaningful question at a good time. The moment notifications feel like nagging, the user will turn them off — and the value of the cadence is lost entirely.

### What We Notify
**Weekly Planning (Sunday):** "A new week begins. What will it be about?"
**Weekly Reflection (Friday):** "The week is almost done. How did it go?"
**Quarterly Review (quarter end):** "A quarter has passed. It is time to look at the full picture."
**Mid-week Pulse (optional, Wednesday):** "Halfway through. How are you doing?"

### What We Do Not Notify
- Domain-level nudges ("You haven't reflected on Health in 10 days")
- Missed completion reminders ("You didn't do your Friday reflection")
- Habit-style streaks or urgency
- Anything that could create anxiety or shame

### Tone of Notification Copy
All notification text should be written in the voice of a calm, wise, non-judgmental mentor. Short sentences. No exclamation points. No emoji. No urgency language.

---

## 14. Privacy Philosophy

### Statement of Principles
This app contains the user's deepest private reflections — their feelings about their marriage, their children, their fears, their failures, their aspirations. The absolute minimum ethical standard is that this data never leaves the device without explicit, informed consent.

### V1 Implementation
- **Local-only storage:** All data lives in SwiftData on the device
- **No network calls:** The app makes zero outbound network requests
- **No analytics:** No usage tracking of any kind
- **No crash reporting to third parties:** Apple's built-in crash reporting only
- **No advertising framework:** No attribution SDKs
- **App Privacy Nutrition Label:** Data Not Collected

### Biometric Lock
The user may optionally require Face ID or Touch ID to open the app. This protects against accidental exposure on shared or misplaced devices.

### Export and Backup
In v2, iCloud sync will be opt-in and encrypted end-to-end. Manual export (v2) generates an encrypted file or user-readable PDF. No data is ever transmitted to a server operated by anyone other than the user.

---

## 15. Onboarding Flow

### Screen 1: Welcome
**Headline:** "Your annual intentions, alive all year."
**Body:** Brief explanation of what the app does and what they are about to set up. One CTA: "Begin."

### Screen 2: Your Annual Letter
**Prompt:** "Paste or type your annual planning letter. This is the document your entire year is built around."
Large text input. Note that this can be done later. CTA: "Continue" / "Set up later."

### Screen 3: Your Domains
**Prompt:** "What areas of your life does this year address?"
Pre-populated list of defaults. User can remove, rename, reorder, or add. CTA: "These look right."

### Screen 4: Success Statements
**Prompt:** "For each domain, what would make 2026 a success?"
One domain shown at a time. User types the success statement for that domain. Skip option per domain. CTA: "Next domain" / "Done."

### Screen 5: Committed Actions
**Prompt:** "What specific actions, rituals, or commitments have you made to yourself this year?"
One domain shown at a time. Add one or more. Skip option. CTA: "Next domain" / "Done."

### Screen 6: Notifications
**Prompt:** "The app works best with two weekly prompts. When would you like them?"
Configure weekly planning day/time and reflection day/time. Simple, clean UI. No explanation needed. CTA: "Set these times."

### Screen 7: Ready
**Headline:** "You're set."
Brief: "Your year is loaded. Every week, return here to plan, reflect, and stay close to what matters."
CTA: "Open my year."

---

## 16. Weekly Workflow

### Sunday (or chosen planning day)
**Trigger:** Planning notification or manual open.

1. User opens Weekly Planning view
2. Sees last week's intention and this week's starting point
3. Reviews which domains have been quiet recently (no judgment — just visibility)
4. Reviews committed actions/rituals due this week
5. Sets this week's intention: one sentence
6. Optionally notes a priority domain for the week

Total time: 3–7 minutes.

### Mid-week (optional)
**Trigger:** Optional pulse notification or manual open.

Brief check-in: "How is the week going? Anything to note?" Optional 1–3 sentence free note. Not structured. Not required. Just available.

### Friday or Saturday (or chosen reflection day)
**Trigger:** Reflection notification or manual open.

1. User opens new Weekly Reflection
2. Rates the overall week (1–5)
3. Reviews their weekly intention: did they live it?
4. Rates each domain they want to address (optional, can skip any)
5. Writes highlights (1–3 sentences)
6. Writes challenges (1–3 sentences)
7. Writes free reflection (any length)
8. Sets next week's intention

Total time: 5–15 minutes.

---

## 17. Quarterly Review Workflow

### Trigger
Notification at quarter end (March 31, June 30, September 30, December 31) or manual launch from Reviews tab.

### Phase 1: Domain Reviews (30–45 minutes)
For each domain, the user sees:
- The domain's success statements
- A list of that domain's committed actions
- Summary of weekly ratings for that domain across the quarter
- A list of past weekly reflections mentioning that domain

The user writes:
- A free-form narrative about the quarter in this domain
- A rating (1–5) for the quarter in this domain
- What to carry forward to next quarter

### Phase 2: Overall Quarterly Narrative (10–15 minutes)
A single, free-form reflection on the quarter as a whole. Prompts offered (optional):
- "What mattered most this quarter?"
- "Where did I fall short, and what does that tell me?"
- "What would I tell myself at the start of this quarter if I could?"
- "What do I most need to focus on next quarter?"

### Phase 3: Carry Forward (5 minutes)
Specific actions or adjustments to bring into the next quarter. This text is surfaced prominently at the start of the next quarter's review.

### Output
A completed quarterly review, timestamped, locked after 30 days. Browsable in the Reviews tab.

---

## 18. Success Metrics

### Engagement Quality (not quantity)
This is a personal, private app. Traditional DAU/MAU are not appropriate targets. The right measures are:

**Weekly Reflection Completion Rate**
Target: User completes at least 3 reflections per month.
Measurement: Local count of completed reflections vs. elapsed weeks.

**Quarterly Review Completion Rate**
Target: User completes all four quarterly reviews in the year.
Measurement: Completed quarterly reviews vs. elapsed quarters.

**Domain Coverage**
Target: All domains rated at least once per month.
Measurement: Last-rated date per domain.

**Intention Continuity**
Target: Weekly intention set for at least 40 of 52 weeks.
Measurement: Weeks with set intentions vs. elapsed weeks.

### These metrics are private and visible only to the user — they are for personal accountability, not app analytics.

### App Store Metrics (external)
- App Store rating target: 4.8 stars
- Crash-free session rate: 99.9%
- App Store reviews: qualitative language review for alignment with vision

---

## 19. App Store Positioning

### Category
Primary: Health & Fitness
Secondary: Productivity

### Name
Personal Progress

### Subtitle (30 chars max)
Your year, lived intentionally

### Description (First Paragraph — most important)
"Personal Progress is a private operating system for intentional living. It is built around your annual planning letter — the document you write at the start of the year to define who you want to be, what you want to accomplish, and how you will know you succeeded. Every week, the app helps you stay close to that letter through weekly reflections, domain tracking, and quarterly reviews."

### Keywords
intentional living, personal growth, annual review, life planning, weekly reflection, journaling, goal setting, accountability, mindfulness, private journal

### App Privacy Nutrition Label
**Data Not Collected.** No data is collected from this app. All content is stored locally on your device and never transmitted.

### Positioning Statement
"Not a habit tracker. Not a social goal app. Not a productivity system. Personal Progress is a private sanctuary for the person who writes their intentions down every January — and wants to honor them every week of the year."

---

## 20. Risks and Tradeoffs

### Risk 1: The Cold Start Problem
**Risk:** Setting up the app requires significant effort — importing a letter, assigning success statements, adding committed actions. Users may abandon during onboarding.
**Mitigation:** Allow every onboarding step to be skipped and completed later. Make the first-run experience feel like progress, not a form. Show the value (the domain dashboard) as quickly as possible.

### Risk 2: The Engagement Cliff
**Risk:** The app provides no inherent pull after initial setup. Without social or streak mechanics, it depends entirely on the user's intrinsic motivation — which wanes.
**Mitigation:** Notifications designed as genuine invitations, not reminders. Quarterly review as an anchor event. The weekly planning/reflection cadence creates its own gravity if the design is excellent.

### Risk 3: Emotional Flattening
**Risk:** Translating an intimate, personal letter into structured app data (domains, statements, actions) may strip the life from it. The app could feel like it demotes the letter into a task list.
**Mitigation:** The letter view is sacred and always accessible in its full original form. Success statements are displayed in first-person, full-sentence format. No jargon (no "OKRs," no "KPIs," no "objectives"). Domain detail views show the statements prominently, not as metadata.

### Risk 4: Feature Creep Under Personal Use
**Risk:** Because this is built for a single known user with evolving needs, there will be pressure to keep adding features. The app could become bloated, losing its clarity and calm.
**Mitigation:** Every new feature must pass the test: "Does this help the user stay closer to their annual letter, or does it add surface area for its own sake?" If the latter, defer or reject.

### Risk 5: Data Loss
**Risk:** SwiftData on a single device without backup means a lost or broken phone could erase years of private reflections.
**Mitigation:** v1 must include a manual export option (even as raw JSON). iCloud sync in v2 is non-negotiable from a data safety standpoint. Alert the user to back up via Settings > iCloud until sync is available.

### Risk 6: Notification Fatigue
**Risk:** If notifications come too often, feel too corporate, or arrive at wrong times, the user will disable them — breaking the cadence that makes the app work.
**Mitigation:** Two notifications per week maximum in default configuration. Copy written with care. Times set by the user, not imposed. Never send a notification for a missed action.

---

*End of Document*
