# Personal Progress — Build Plan

**Version:** 1.0
**Date:** April 2026
**Target:** App Store v1.0 release

---

## Recommended GitHub Repo Name

**`personal-progress-ios`**

Rationale: lowercase-hyphenated matches standard GitHub convention for iOS projects. It is specific (iOS), descriptive, and not overly branded. If an Android or web version is ever built, the naming convention scales cleanly.

---

## Repo Structure

```
personal-progress-ios/
├── .github/
│   ├── workflows/
│   │   └── ci.yml                    # Build + test on push to main
│   └── PULL_REQUEST_TEMPLATE.md
│
├── PersonalProgress/                  # Main app target
│   ├── App/
│   ├── Core/
│   ├── Features/
│   ├── Shared/
│   └── Resources/
│
├── PersonalProgressTests/             # Unit tests
├── PersonalProgressUITests/           # UI tests
│
├── docs/
│   ├── PRODUCT_REQUIREMENTS.md
│   ├── TECHNICAL_ARCHITECTURE.md
│   └── BUILD_PLAN.md
│
├── .gitignore                         # Xcode standard + xcuserdata
├── README.md
└── PersonalProgress.xcodeproj/
```

### .gitignore (critical entries)
```
xcuserdata/
*.xccheckout
*.xcscmblueprint
DerivedData/
*.ipa
*.dSYM.zip
*.dSYM
Pods/                    # No CocoaPods — no third-party dependencies
.DS_Store
```

### No Package Manager for V1
Personal Progress has **zero third-party dependencies** in v1. No SwiftPM packages, no CocoaPods, no Carthage. The entire feature set is built on Apple frameworks: SwiftUI, SwiftData, UserNotifications, LocalAuthentication. This is intentional — it eliminates supply chain risk, reduces app size, and simplifies the build.

---

## Staged Implementation Roadmap

### Phase 0: Project Foundation
**Goal:** A clean, production-standard Xcode project that compiles and passes CI before a single feature is written.

**Tasks:**
- Create Xcode project with correct bundle ID (`com.[name].personal-progress`)
- Configure deployment target: iOS 17.0
- Add unit test target and UI test target
- Configure SwiftData `ModelContainer` with all model types (stub models with minimal fields)
- Set up GitHub repo with branch protection on `main`
- Write CI workflow: build + test on every push
- Remove all default boilerplate (ContentView.swift, etc.)
- Add Privacy Manifest (`PrivacyInfo.xcprivacy`)
- Configure `.gitignore`
- Write `README.md` (what this project is, how to build it)

**Deliverable:** Empty app that launches to a blank screen, compiles cleanly, all tests pass (even if there are none yet), CI is green.

---

### Phase 1: Data Layer
**Goal:** All SwiftData models defined, relationships correct, basic CRUD working, service layer shells in place.

**Tasks:**
- Implement all `@Model` classes (all 8 entities)
- Define all relationships with correct delete rules
- Implement `DateHelpers.swift` (week start, quarter boundaries) with full test coverage
- Implement `DomainService` with tests (seed defaults, CRUD, archiving)
- Implement `ReflectionService` with tests (create, fetch by week, lock logic)
- Implement `ReviewService` with tests (create, fetch by quarter, quarter calculation)
- Implement `LetterService` with tests (import, fetch current year)
- Add `ModelContainer` preview helper for SwiftUI `#Preview` macros
- Seed fixture data for development previews

**Deliverable:** Complete data layer with 85%+ test coverage. No UI yet.

---

### Phase 2: App Shell + Navigation
**Goal:** Tab bar and navigation structure in place. All top-level screens exist as shells.

**Tasks:**
- Implement `AppTheme.swift` with typography, color tokens, spacing scale
- Implement `ColorPalette.swift` with the domain color options
- Build tab bar with all 5 tabs (Home, Reflect, Letter, Reviews, Settings)
- Create shell views for all feature tabs (no content, just correct navigation structure)
- Implement `NavigationCoordinator` or SwiftUI `NavigationStack` routing pattern
- Implement notification deep link routing (routing works even before content exists)
- Add `AppDelegate` with `UNUserNotificationCenterDelegate`

**Deliverable:** App navigates correctly between all tabs. Shell views display. Deep link routing works.

---

### Phase 3: Onboarding
**Goal:** Full onboarding flow that produces a fully populated SwiftData store.

**Tasks:**
- Build `OnboardingCoordinator` (step-tracking, skip logic, resume from incomplete)
- Build `WelcomeView`
- Build `LetterImportView` (large text input, preserve verbatim, store in `AnnualLetter`)
- Build `DomainSetupView` (pre-populated defaults, rename, reorder, remove, add custom)
- Build `SuccessStatementSetupView` (per-domain, add multiple, skip)
- Build `CommittedActionSetupView` (per-domain, type + frequency selection, skip)
- Build `NotificationSetupView` (day/time pickers for planning and reflection prompts)
- Build `OnboardingCompleteView`
- Implement first-launch detection (show onboarding if no `AnnualLetter` exists)
- Implement `NotificationService` with permission request + scheduling
- Implement resume-from-incomplete onboarding (stored step index in UserDefaults)

**Deliverable:** Complete onboarding from launch to populated app. Notifications scheduled.

---

### Phase 4: Home Tab + Domain Views
**Goal:** The domain dashboard is live and domain detail is complete.

**Tasks:**
- Build `HomeView` with domain grid/list
- Build `DomainCardView` (name, icon, color, last-reflected indicator)
- Build `WeekStatusCardView` (current week intention, days elapsed)
- Build `DomainDetailView` (success statements, committed actions, reflection history)
- Build `SuccessStatementRowView` and `CommittedActionRowView`
- Implement "domains needing attention" logic in `DomainService` (no reflection in N days)
- Build `DomainSettingsView` (edit name, color, icon, sort order, archive)
- Connect `@Query` for domain list in `HomeView`

**Deliverable:** Home dashboard shows all domains. Domain detail is complete and navigable.

---

### Phase 5: Letter Tab
**Goal:** Annual letter is readable and beautiful.

**Tasks:**
- Build `LetterView` reading experience (full-screen, comfortable typography, no chrome)
- Build `LetterArchiveView` (list past years if they exist)
- Implement letter lock date logic (editable through January, read-only after)
- Build scroll-to-top behavior and reading progress indicator (subtle)
- Add "Edit Letter" flow accessible from Settings (before lock date)

**Deliverable:** Letter tab is complete. The reading experience feels like a quality e-reader.

---

### Phase 6: Reflect Tab
**Goal:** Weekly planning and reflection workflows are complete.

**Tasks:**
- Build `WeeklyPlanningView` (this week's intention, committed actions by frequency, domain attention indicators)
- Build `WeeklyReflectionView` (all fields: intention review, domain ratings, highlights, challenges, free text, next week intention)
- Build `WeeklyReflectionViewModel` with validation logic
- Build `ReflectionHistoryView` (reverse chronological list of past reflections)
- Build `ReflectionDetailView` (read a past reflection)
- Implement reflection locking (immutable 48h after creation)
- Implement domain rating input (per-domain optional 1–5 with note)
- Add `RatingPicker` shared component

**Deliverable:** Complete weekly planning and reflection workflows. History browsable.

---

### Phase 7: Reviews Tab
**Goal:** Quarterly review workflow is complete.

**Tasks:**
- Build `ReviewsTabView` (current quarter status, past reviews list)
- Build `QuarterlyReviewView` (multi-step workflow with domain reviews + overall narrative)
- Build `DomainReviewStepView` (one domain at a time: statements visible, write reflection, rate, carry-forward)
- Build `QuarterlyReviewViewModel` with step navigation and save logic
- Build `ReviewDetailView` (read a completed review)
- Implement quarterly review prompt triggering (detect quarter end, surface CTA)
- Implement review locking (immutable 30 days after completion)
- Surface carry-forward notes from prior quarter at start of new review

**Deliverable:** Full quarterly review workflow. History browsable. Review locking works.

---

### Phase 8: Settings + Privacy
**Goal:** Settings fully functional. Privacy lock implemented.

**Tasks:**
- Build `SettingsView` (all sections: domains, notifications, privacy, export, about)
- Build `NotificationSettingsView` (per-type enable/disable, day/time pickers)
- Implement `NotificationService.rescheduleAll()` triggered on settings change
- Build `PrivacyLockSettingsView` (enable biometric, configure lock-after time)
- Implement biometric lock using `LocalAuthentication` framework
- Build `ExportView` (export to JSON, share sheet)
- Implement `ExportService`
- Add "Manage Domains" accessible from Settings (add, rename, reorder, archive)

**Deliverable:** Settings complete. Privacy lock works. Export works.

---

### Phase 9: Polish + App Store Prep
**Goal:** App is production quality, tested on real hardware, ready for submission.

**Tasks:**
- Audit all views for Dynamic Type support (test with Accessibility Inspector)
- Audit all views for VoiceOver labels
- Test on physical devices: iPhone SE (small), iPhone 16 Pro Max (large)
- Test all notification types: receive on device, verify deep link routing
- Implement empty state views for all screens (first launch, no data)
- Audit all typography for visual hierarchy and consistency
- Review all copy: every string, every notification, every empty state
- Remove any debug logging
- Verify Privacy Manifest is complete
- Configure App Store Connect: screenshots, description, keywords, privacy labels
- Submit to TestFlight for internal testing
- Run one complete user journey: onboarding → week 1 → reflection → quarter end → review
- Fix any issues found
- Submit to App Store

**Deliverable:** App Store submission.

---

## Summary Timeline

| Phase | Focus | Relative Effort |
|-------|-------|----------------|
| 0 | Project foundation | 1 |
| 1 | Data layer | 2 |
| 2 | App shell + navigation | 1 |
| 3 | Onboarding | 3 |
| 4 | Home + Domain views | 2 |
| 5 | Letter tab | 1 |
| 6 | Reflect tab | 3 |
| 7 | Reviews tab | 3 |
| 8 | Settings + privacy | 2 |
| 9 | Polish + App Store prep | 2 |

Phases 3, 6, and 7 are the most complex and are the primary risk areas for quality. Do not rush them.

---

## Development Principles for This Project

**One feature, done completely, before the next.**
Do not build thin versions of all features. Build Phase 3 until it is excellent, then move to Phase 4.

**Real device testing at every phase.**
Simulator is for speed; physical device is for reality. Notifications, Face ID, and performance only reveal their true behavior on hardware.

**Design in code, not design tools.**
Because this is a single-developer project, SwiftUI Previews serve as the design environment. Every view gets a `#Preview` with realistic data before it is considered complete.

**Commit at every meaningful checkpoint.**
Not every file save — every time a piece of functionality works end-to-end. Clean commit history is documentation.

**Do not add features between phases.**
Ideas that arise during development go into a `BACKLOG.md` file. Nothing gets added to the current phase.

---

*End of Document*
