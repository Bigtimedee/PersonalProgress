# Personal Progress

A private native iPhone app for intentional living.

Personal Progress is built around one idea: your annual letter — the document you write every January to define who you want to be and what you want to accomplish — should remain alive and present for the full 52 weeks that follow.

It is not a habit tracker. It is not a social goal app. It is not a corporate productivity system. It is a private operating system for a person who takes their own life seriously.

---

## What It Does

- Stores and preserves your annual planning letter in its full original form
- Organizes your life into domains (Spouse, Children, Work, Health, and others you define)
- Tracks your "I will know I succeeded if..." success statements per domain
- Holds your committed actions, rituals, and intentions for the year
- Guides a weekly planning and reflection cadence
- Facilitates a deep quarterly review against your original commitments
- Sends gentle, purposeful notifications — and nothing else

## What It Does Not Do

- No social features
- No sharing
- No analytics
- No cloud sync in v1
- No third-party SDKs
- No network access of any kind

---

## Technical Stack

| Layer | Technology |
|-------|-----------|
| Platform | iOS 17+ (iPhone) |
| Language | Swift 5.9+ |
| UI | SwiftUI |
| Persistence | SwiftData |
| Notifications | UserNotifications (local only) |
| Privacy Lock | LocalAuthentication (Face ID / Touch ID) |
| Dependencies | None |

---

## Project Structure

```
personal-progress-ios/
├── PersonalProgress/
│   ├── App/                    # App entry point, AppDelegate
│   ├── Core/
│   │   ├── Models/             # SwiftData @Model classes
│   │   ├── Services/           # Business logic
│   │   ├── Persistence/        # ModelContainer configuration
│   │   └── Utilities/          # Date helpers, constants
│   ├── Features/
│   │   ├── Onboarding/         # First-launch setup flow
│   │   ├── Home/               # Domain dashboard
│   │   ├── Domains/            # Domain detail views
│   │   ├── Letter/             # Annual letter reading view
│   │   ├── Reflect/            # Weekly planning and reflection
│   │   ├── Reviews/            # Quarterly review workflow
│   │   └── Settings/           # App configuration
│   ├── DesignSystem/           # Typography, colors, theme tokens
│   └── Resources/              # Assets, localizable strings
├── PersonalProgressTests/      # Unit tests (XCTest)
├── PersonalProgressUITests/    # UI tests (XCUITest)
└── docs/                       # Product and technical documentation
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [Product Requirements](docs/PRODUCT_REQUIREMENTS.md) | Vision, features, user stories, data model |
| [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md) | Architecture decisions, patterns, extensibility |
| [Build Plan](docs/BUILD_PLAN.md) | Phased implementation roadmap |
| [Repo Setup](docs/REPO_SETUP.md) | Xcode project setup checklist |

---

## Getting Started

### Prerequisites
- Xcode 15.2 or later
- iOS 17.0 SDK
- A physical iPhone for notification testing (recommended)

### Setup
See [docs/REPO_SETUP.md](docs/REPO_SETUP.md) for complete setup instructions.

---

## Build Phases

| Phase | Focus |
|-------|-------|
| 0 | Project foundation and CI |
| 1 | Data layer and service layer |
| 2 | App shell and navigation |
| 3 | Onboarding flow |
| 4 | Home tab and domain views |
| 5 | Letter tab |
| 6 | Reflect tab (weekly planning and reflection) |
| 7 | Reviews tab (quarterly review) |
| 8 | Settings and privacy lock |
| 9 | Polish and App Store submission |

---

## Privacy

This app contains deeply personal data. Its privacy properties are architectural, not policy-based:

- **No network entitlement** — the app cannot make outbound connections
- **No analytics SDK** — no usage data is collected
- **No crash reporting to third parties** — Apple's built-in reporting only
- **App Privacy Nutrition Label:** Data Not Collected

---

*Private repository. All rights reserved.*
