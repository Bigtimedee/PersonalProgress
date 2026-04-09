# Personal Progress — Technical Architecture

**Version:** 1.0
**Date:** April 2026
**Target Platform:** iOS 17.0+ (iPhone)
**Language:** Swift 5.9+
**UI Framework:** SwiftUI
**Persistence:** SwiftData

---

## 1. Architecture Overview

Personal Progress uses a clean MVVM architecture with a service layer, built on SwiftData for local persistence. The architecture is designed to be:

- **Local-first:** Zero network dependencies. The app has no network entitlement.
- **Privacy-preserving:** No telemetry, no crash reporting to third parties, no analytics SDK.
- **Modular:** Features are organized as independent modules with clear boundaries, enabling future extensions (widgets, Watch, iCloud) without refactoring core logic.
- **Testable:** Business logic lives in the service layer, not in views or view models.

### Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                      Views (SwiftUI)                     │
│           Feature views + shared UI components           │
├─────────────────────────────────────────────────────────┤
│                    View Models                           │
│         @Observable, feature-scoped, stateful           │
├─────────────────────────────────────────────────────────┤
│                    Service Layer                         │
│    Pure Swift, no SwiftUI dependencies, testable        │
├─────────────────────────────────────────────────────────┤
│                    Data Layer                            │
│         SwiftData models + ModelContainer               │
└─────────────────────────────────────────────────────────┘
```

The `@Query` macro is used for simple reads directly in views when no transformation is needed. For complex queries, derived state, or business logic, data flows through the service layer into view models.

---

## 2. SwiftData vs CoreData Decision

**Chosen: SwiftData**

### Rationale
- SwiftData is designed for Swift and SwiftUI-first development. It eliminates the NSManagedObject ceremony that CoreData requires.
- The `@Model` macro produces clean, native Swift classes. The `@Query` macro enables reactive data in SwiftUI views without additional boilerplate.
- The data model for Personal Progress is moderate in complexity (8 entities, straightforward relationships) — well within SwiftData's strengths.
- iOS 17+ is the minimum deployment target, which aligns exactly with SwiftData availability.
- Migration support in SwiftData has improved significantly and is sufficient for the planned schema evolution.

### Tradeoff Acknowledged
CoreData has more mature tooling for complex migrations and raw query performance at scale. Neither concern applies here: schema migrations will be simple and additive, and the dataset will never be large enough to stress SwiftData's query performance.

---

## 3. Project Folder Structure

```
PersonalProgress/
├── PersonalProgressApp.swift          # App entry point, ModelContainer config
├── AppDelegate.swift                  # UIKit lifecycle hooks (notifications)
│
├── Core/
│   ├── Models/                        # SwiftData @Model classes
│   │   ├── AnnualLetter.swift
│   │   ├── Domain.swift
│   │   ├── SuccessStatement.swift
│   │   ├── CommittedAction.swift
│   │   ├── WeeklyReflection.swift
│   │   ├── DomainWeeklyRating.swift
│   │   ├── QuarterlyReview.swift
│   │   ├── DomainQuarterlyReview.swift
│   │   └── NotificationPreferences.swift
│   │
│   ├── Services/                      # Business logic, no SwiftUI
│   │   ├── DomainService.swift        # CRUD + business rules for domains
│   │   ├── ReflectionService.swift    # Weekly reflection logic
│   │   ├── ReviewService.swift        # Quarterly review logic
│   │   ├── LetterService.swift        # Letter import and management
│   │   ├── NotificationService.swift  # Schedule/cancel UNUserNotificationCenter
│   │   └── ExportService.swift        # JSON export (v1), PDF (v2)
│   │
│   └── Utilities/
│       ├── DateHelpers.swift          # Week start/end, quarter boundaries
│       ├── Extensions+SwiftData.swift # Convenience query helpers
│       └── Constants.swift            # Default domains, icons, colors
│
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingCoordinator.swift
│   │   ├── WelcomeView.swift
│   │   ├── LetterImportView.swift
│   │   ├── DomainSetupView.swift
│   │   ├── SuccessStatementSetupView.swift
│   │   ├── CommittedActionSetupView.swift
│   │   ├── NotificationSetupView.swift
│   │   └── OnboardingViewModel.swift
│   │
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   ├── DomainCardView.swift
│   │   └── WeekStatusCardView.swift
│   │
│   ├── Domains/
│   │   ├── DomainDetailView.swift
│   │   ├── DomainDetailViewModel.swift
│   │   ├── SuccessStatementRowView.swift
│   │   ├── CommittedActionRowView.swift
│   │   └── DomainSettingsView.swift
│   │
│   ├── Letter/
│   │   ├── LetterView.swift
│   │   ├── LetterViewModel.swift
│   │   └── LetterArchiveView.swift
│   │
│   ├── Reflect/
│   │   ├── ReflectTabView.swift
│   │   ├── WeeklyReflectionView.swift
│   │   ├── WeeklyReflectionViewModel.swift
│   │   ├── WeeklyPlanningView.swift
│   │   ├── WeeklyPlanningViewModel.swift
│   │   └── ReflectionHistoryView.swift
│   │
│   ├── Reviews/
│   │   ├── ReviewsTabView.swift
│   │   ├── QuarterlyReviewView.swift
│   │   ├── QuarterlyReviewViewModel.swift
│   │   ├── DomainReviewStepView.swift
│   │   └── ReviewHistoryView.swift
│   │
│   └── Settings/
│       ├── SettingsView.swift
│       ├── NotificationSettingsView.swift
│       ├── PrivacyLockSettingsView.swift
│       ├── DomainManagementView.swift
│       └── ExportView.swift
│
├── Shared/
│   ├── Components/
│   │   ├── RatingPicker.swift         # 1–5 star/circle rating component
│   │   ├── SectionHeader.swift        # Consistent section headings
│   │   ├── EmptyStateView.swift       # Reusable empty state
│   │   ├── DomainChip.swift           # Colored domain badge
│   │   └── TextEditorWithPlaceholder.swift
│   │
│   ├── Theme/
│   │   ├── AppTheme.swift             # Color, font, spacing tokens
│   │   ├── Typography.swift           # Custom type scale
│   │   └── ColorPalette.swift         # Domain color options
│   │
│   └── Extensions/
│       ├── Color+Extensions.swift
│       ├── Date+Extensions.swift
│       └── View+Extensions.swift
│
├── Resources/
│   ├── Assets.xcassets
│   └── Localizable.strings            # Even for single-language apps
│
└── Tests/
    ├── PersonalProgressTests/
    │   ├── Services/
    │   │   ├── ReflectionServiceTests.swift
    │   │   ├── ReviewServiceTests.swift
    │   │   ├── DomainServiceTests.swift
    │   │   └── NotificationServiceTests.swift
    │   └── Utilities/
    │       └── DateHelperTests.swift
    └── PersonalProgressUITests/
        ├── OnboardingUITests.swift
        └── WeeklyReflectionUITests.swift
```

---

## 4. MVVM Implementation Pattern

### View
- Pure SwiftUI, no business logic
- Reads from `@Query` (simple cases) or `@Bindable` / `@State` from view model
- No direct SwiftData container access except via injected model context
- All navigation is declarative (NavigationStack, `.navigationDestination`)

### View Model
- Marked `@Observable` (Swift 5.9 Observation framework, not ObservableObject)
- Receives model context via initializer injection (testable)
- Calls service layer for anything beyond trivial CRUD
- Handles presentation-level state: loading, error, validation

```swift
@Observable
final class WeeklyReflectionViewModel {
    private let reflectionService: ReflectionService
    private let modelContext: ModelContext

    var currentReflection: WeeklyReflection?
    var isLoading = false
    var validationError: String?

    init(modelContext: ModelContext, reflectionService: ReflectionService) {
        self.modelContext = modelContext
        self.reflectionService = reflectionService
    }

    func loadCurrentWeekReflection() {
        currentReflection = reflectionService.reflectionForCurrentWeek(in: modelContext)
    }

    func saveReflection(_ reflection: WeeklyReflection) throws {
        try reflectionService.save(reflection, in: modelContext)
    }
}
```

### Service
- Pure Swift structs or final classes
- Takes `ModelContext` as parameter (injected, not captured)
- Performs queries, transformations, and business rules
- Returns native Swift types, not SwiftData models (where practical)

```swift
struct ReflectionService {
    func reflectionForCurrentWeek(in context: ModelContext) -> WeeklyReflection? {
        let weekStart = Date.currentWeekStart()
        let descriptor = FetchDescriptor<WeeklyReflection>(
            predicate: #Predicate { $0.weekStartDate == weekStart }
        )
        return try? context.fetch(descriptor).first
    }

    func save(_ reflection: WeeklyReflection, in context: ModelContext) throws {
        context.insert(reflection)
        try context.save()
    }
}
```

---

## 5. Persistence Architecture

### ModelContainer Configuration

```swift
@main
struct PersonalProgressApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            AnnualLetter.self,
            Domain.self,
            SuccessStatement.self,
            CommittedAction.self,
            WeeklyReflection.self,
            DomainWeeklyRating.self,
            QuarterlyReview.self,
            DomainQuarterlyReview.self,
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )

        container = try! ModelContainer(for: schema, configurations: config)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
```

### Schema Migration Strategy
- v1 uses `VersionedSchema` from the start (even if only one version exists)
- All schema changes are additive where possible (new optional fields, new entities)
- Breaking changes use `MigrationStage.custom` with explicit transformation closures
- Migration plan maintained in `Core/Models/MigrationPlan.swift`

### Data Integrity
- `context.save()` is called explicitly after mutations; no implicit saves
- Service layer wraps saves in do/catch and surfaces errors to view models
- Relationship deletions use cascade rules declared in `@Relationship` macros

---

## 6. Domain Model (SwiftData)

```swift
@Model
final class AnnualLetter {
    var id: UUID
    var year: Int
    var rawText: String
    var importedAt: Date
    var isLocked: Bool

    @Relationship(deleteRule: .cascade) var domains: [Domain]
}

@Model
final class Domain {
    var id: UUID
    var name: String
    var colorHex: String
    var iconName: String
    var sortOrder: Int
    var isArchived: Bool

    @Relationship(deleteRule: .cascade) var successStatements: [SuccessStatement]
    @Relationship(deleteRule: .cascade) var committedActions: [CommittedAction]
    @Relationship(deleteRule: .nullify) var weeklyRatings: [DomainWeeklyRating]
    @Relationship(deleteRule: .nullify) var quarterlyReviews: [DomainQuarterlyReview]
}

@Model
final class SuccessStatement {
    var id: UUID
    var text: String
    var year: Int
    var sortOrder: Int
    var domain: Domain?
}

@Model
final class CommittedAction {
    var id: UUID
    var text: String
    var actionType: ActionType    // enum: action, ritual, commitment
    var frequency: ActionFrequency // enum: daily, weekly, monthly, asNeeded
    var isArchived: Bool
    var createdAt: Date
    var domain: Domain?
}

@Model
final class WeeklyReflection {
    var id: UUID
    var weekStartDate: Date
    var weeklyIntention: String
    var overallRating: Int
    var highlights: String
    var challenges: String
    var freeReflection: String
    var nextWeekIntention: String
    var completedAt: Date
    var isLocked: Bool

    @Relationship(deleteRule: .cascade) var domainRatings: [DomainWeeklyRating]
}

@Model
final class DomainWeeklyRating {
    var id: UUID
    var rating: Int?
    var note: String
    var reflection: WeeklyReflection?
    var domain: Domain?
}

@Model
final class QuarterlyReview {
    var id: UUID
    var year: Int
    var quarter: Int
    var overallNarrative: String
    var carryForwardNotes: String
    var completedAt: Date
    var isLocked: Bool

    @Relationship(deleteRule: .cascade) var domainReviews: [DomainQuarterlyReview]
}

@Model
final class DomainQuarterlyReview {
    var id: UUID
    var reflection: String
    var rating: Int
    var carryForward: String
    var quarterlyReview: QuarterlyReview?
    var domain: Domain?
}
```

---

## 7. Service Layer Design

### DomainService
Responsibilities: domain CRUD, reordering, archiving, default domain seeding on first launch.

```swift
struct DomainService {
    func seedDefaultDomains(in context: ModelContext)
    func createDomain(name: String, colorHex: String, iconName: String, in context: ModelContext) throws -> Domain
    func reorderDomains(_ domains: [Domain], in context: ModelContext) throws
    func archiveDomain(_ domain: Domain, in context: ModelContext) throws
    func domainsNeedingAttention(from domains: [Domain], thresholdDays: Int) -> [Domain]
}
```

### ReflectionService
Responsibilities: weekly reflection creation, current week lookup, locking, rating aggregation.

```swift
struct ReflectionService {
    func reflectionForWeek(startingOn date: Date, in context: ModelContext) -> WeeklyReflection?
    func createReflection(for weekStart: Date, in context: ModelContext) throws -> WeeklyReflection
    func saveReflection(_ reflection: WeeklyReflection, in context: ModelContext) throws
    func lockExpiredReflections(in context: ModelContext) throws
    func weeklyRatingsForDomain(_ domain: Domain, in context: ModelContext) -> [DomainWeeklyRating]
}
```

### ReviewService
Responsibilities: quarterly review lifecycle, domain review aggregation, quarter boundary calculation.

```swift
struct ReviewService {
    func currentQuarter() -> (year: Int, quarter: Int)
    func reviewForQuarter(year: Int, quarter: Int, in context: ModelContext) -> QuarterlyReview?
    func createReview(year: Int, quarter: Int, in context: ModelContext) throws -> QuarterlyReview
    func saveReview(_ review: QuarterlyReview, in context: ModelContext) throws
    func quarterSummary(year: Int, quarter: Int, in context: ModelContext) -> QuarterSummary
}
```

### LetterService
Responsibilities: letter import, storage, year management.

```swift
struct LetterService {
    func importLetter(text: String, year: Int, in context: ModelContext) throws -> AnnualLetter
    func currentYearLetter(in context: ModelContext) -> AnnualLetter?
    func allLetters(in context: ModelContext) -> [AnnualLetter]
}
```

### NotificationService
Responsibilities: scheduling, cancellation, permission requests.

```swift
final class NotificationService {
    func requestPermission() async -> Bool
    func scheduleWeeklyPlanningNotification(day: Int, hour: Int, minute: Int)
    func scheduleWeeklyReflectionNotification(day: Int, hour: Int, minute: Int)
    func scheduleQuarterlyReviewNotification(for date: Date)
    func cancelAllNotifications()
    func cancelNotification(id: String)
    func rescheduleAll(from preferences: NotificationPreferences)
}
```

### ExportService
Responsibilities: JSON export in v1, PDF in v2.

```swift
struct ExportService {
    func exportAsJSON(in context: ModelContext) throws -> Data
    func exportYear(_ year: Int, in context: ModelContext) throws -> Data
}
```

---

## 8. Notification Architecture

### Framework
`UserNotifications` framework. All notifications are local. No APNs, no push certificates, no server.

### Notification Identifiers (for cancellation and deduplication)
```
com.personalprogress.notification.weeklyplanning
com.personalprogress.notification.weeklyreflection
com.personalprogress.notification.quarterly.YYYY.Q
com.personalprogress.notification.midweekpulse
```

### Scheduling Strategy
- Weekly planning and reflection: `UNCalendarNotificationTrigger` with repeating weekday + time
- Quarterly review: `UNCalendarNotificationTrigger` with a specific date (non-repeating, rescheduled after completion)
- Mid-week pulse: `UNCalendarNotificationTrigger` with repeating weekday (if enabled)

### Deep Link Routing
Notifications carry a `userInfo` payload with a `notificationType` key. The app delegate or scene delegate reads this and routes to the correct tab/view on launch/foreground.

```swift
// In AppDelegate or .onOpenURL
func application(_ application: UIApplication,
                 didReceive notification: UNNotification) {
    let type = notification.request.content.userInfo["notificationType"] as? String
    // Route to appropriate tab
}
```

### Notification Content Guidelines
- Title: 5 words or fewer
- Body: one complete sentence, calm tone
- Sound: default system sound
- Badge: not used

### Example Notifications
```
Title: "A new week begins."
Body:  "What will this week be about?"

Title: "The week is almost done."
Body:  "Take a few minutes to reflect."

Title: "A quarter has passed."
Body:  "It is time to look at the full picture."
```

---

## 9. Import Pipeline for Annual Planning Letters

### V1: Manual Structured Import
The annual letter is imported as raw text and preserved verbatim. Structuring (assigning content to domains) is done manually by the user during onboarding.

**Flow:**
1. User pastes or types letter text → stored in `AnnualLetter.rawText`
2. User is presented with domains one at a time
3. For each domain, user manually types success statements and committed actions
4. Original letter remains readable at all times alongside the structured data

**Design Rationale:** Forcing manual input ensures the user re-engages with their own letter rather than passively importing it. This re-reading is itself valuable.

### V2: AI-Assisted Parsing (Architecture Placeholder)
The pipeline for v2 will use on-device NLP or a privacy-respecting API call (explicit user consent required) to:

1. Tokenize the letter into paragraphs
2. Suggest domain assignments per paragraph
3. Extract candidate success statements (sentences matching "I will know I succeeded if...")
4. Extract candidate committed actions (imperative sentences, ritual phrases)
5. Present suggestions as a review-and-approve flow — nothing is committed without user confirmation

**Interface for v2 extensibility:**
```swift
protocol LetterParserProtocol {
    func suggestDomainAssignments(for text: String) async throws -> [DomainSuggestion]
    func extractSuccessStatements(from text: String) async throws -> [String]
    func extractCommittedActions(from text: String) async throws -> [ActionSuggestion]
}

// v1 implementation: returns empty suggestions (manual only)
struct ManualLetterParser: LetterParserProtocol { ... }

// v2 implementation: uses on-device Core ML or approved API
struct AILetterParser: LetterParserProtocol { ... }
```

---

## 10. Analytics Strategy

### V1 Policy: No Analytics
The app collects zero usage data. There are no analytics SDKs, no event tracking, no user identifiers, no session data. The App Privacy Nutrition Label declares: **Data Not Collected.**

This is both an ethical requirement (the app contains intimate personal data) and a practical simplification (no third-party SDK dependencies).

### Crash Reporting
The app opts into Apple's built-in crash reporting via Xcode Organizer. This is the only telemetry — it is anonymous, managed by Apple, and requires no SDK integration.

### In-App Progress Indicators (local only)
The app does compute local usage statistics for the user's own benefit:
- Reflections completed this month
- Domains last-touched dates
- Quarter completion percentage

These are computed from local SwiftData queries and are never transmitted anywhere.

---

## 11. Testing Strategy

### Unit Tests (XCTest)
Cover the service layer comprehensively. Services are pure Swift with injected `ModelContext`, enabling in-memory testing without launching the full app.

```swift
// Setup pattern for service tests
class ReflectionServiceTests: XCTestCase {
    var context: ModelContext!
    var service: ReflectionService!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: WeeklyReflection.self, configurations: config)
        context = ModelContext(container)
        service = ReflectionService()
    }
}
```

**Coverage targets:**
- `ReflectionService`: 90%+
- `ReviewService`: 90%+
- `DomainService`: 85%+
- `NotificationService`: 80%+
- `DateHelpers`: 100%

### UI Tests (XCUITest)
Cover critical user journeys:
- Onboarding completion (full flow)
- Create and save a weekly reflection
- Complete a quarterly review
- Enable and verify notification permissions

UI tests run against a populated in-memory container seeded with fixture data.

### SwiftUI Previews
Every view has a `#Preview` macro with:
- Empty state variant
- Populated state variant
- Dark mode variant (where applicable)

Previews serve as visual regression tests during development.

### What We Do Not Test
- SwiftData internals (trust the framework)
- SwiftUI rendering (trust previews + manual verification)
- System APIs (UNUserNotificationCenter: mock with a protocol wrapper)

---

## 12. App Store Readiness Considerations

### Privacy Manifest (PrivacyInfo.xcprivacy)
Required as of Xcode 15+ for App Store submission. Declare:
- No API types accessed (no tracking domains, no user defaults for tracking, etc.)
- No third-party SDK privacy practices to declare

### App Privacy Nutrition Label
In App Store Connect, declare: **Data Not Collected.**

### Network Entitlement
Remove `com.apple.security.network.client` from entitlements. The app makes no network calls and should not have this entitlement. Its absence is a privacy signal.

### App Transport Security
No ATS configuration needed (no network calls).

### Required Device Capabilities
- `arm64` (standard)

### Permissions
- `NSFaceIDUsageDescription` — required if biometric lock is implemented
- No camera, microphone, location, contacts, or any other system permissions

### Age Rating
4+ (no objectionable content)

### In-App Purchases
None in v1.

### TestFlight
Set up TestFlight for internal testing before App Store submission. Run on physical device to verify:
- Notification scheduling and delivery
- Face ID lock behavior
- Performance on older supported devices (iPhone SE 3rd gen is the slowest relevant target)

---

## 13. Future Extensibility

### iCloud Sync (V2)
SwiftData has built-in CloudKit sync support via `ModelConfiguration` with `cloudKitDatabase: .automatic`. Enabling it requires:
- Adding CloudKit capability to the app target
- Adding `NSUbiquitousContainerId` entitlement
- Ensuring all `@Model` properties are CloudKit-compatible (no transformable types without conforming to `Codable`)

**Design decision made now:** All `@Model` properties use primitive types or `Codable` enums. No raw `Data` blobs. This keeps the CloudKit migration path clean.

### Widgets (V2)
Widget extensions read data via App Groups (shared container). Prepare now by:
- Defining a lightweight `WidgetDataProvider` struct in a shared framework target
- Writing intent for "show current week intention" from day one (even if unused in v1)
- Keeping home screen widget data surface small (just the intention sentence and a domain name)

### Apple Watch (V2)
WatchKit extension communicates via `WatchConnectivity`. The watch-side model is a lightweight struct, not SwiftData. Prepare by ensuring the key data types (`WeeklyReflection`, `Domain`) conform to `Codable` for transmission.

### AI Summarization (V2)
The `LetterParserProtocol` abstraction (see Section 9) is the primary seam. Additional AI surface areas:
- `InsightService` — analyzes patterns in reflections, surfaces observations
- `ReviewAssistantService` — offers reflection prompts based on patterns in prior quarter

All AI features must be explicitly opt-in. Any API calls require a user-visible network consent flow.

### App Intents / Siri (V2)
Define `AppIntent` types for key actions:
- `SetWeeklyIntentionIntent`
- `OpenLetterIntent`
- `StartReflectionIntent`

These can be registered as Siri shortcuts and Spotlight actions without significant architectural change if views are routed via a central `NavigationCoordinator`.

---

*End of Document*
