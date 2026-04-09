# Repository Setup Checklist

This file guides you through creating the Xcode project and connecting it to the scaffolded source files. Complete every step in order.

---

## Part 1: GitHub Repository Setup

Run these commands from Terminal:

```bash
# 1. Navigate to the project directory
cd /Users/alex/Projects/PersonalProgress

# 2. Initialize git
git init

# 3. Stage all files
git add .

# 4. Make the initial commit
git commit -m "Initial scaffold: project structure, documentation, and source files"

# 5. Create the private GitHub repo (requires gh CLI installed)
gh repo create personal-progress-ios \
  --private \
  --description "Personal Progress — native iPhone app for intentional living" \
  --source=. \
  --remote=origin \
  --push
```

If `gh` is not installed, install it first:
```bash
brew install gh
gh auth login
```

---

## Part 2: Xcode Project Creation

The `.xcodeproj` file must be created in Xcode. The source files are already in place.

### Step 1: Create a New Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose: **iOS → App**
4. Click **Next**

### Step 2: Configure Project Settings

Fill in exactly as shown:

| Field | Value |
|-------|-------|
| Product Name | `PersonalProgress` |
| Team | Your Apple Developer account |
| Organization Identifier | `com.[yourlastname].personalprogress` |
| Bundle Identifier | (auto-fills from above) |
| Interface | **SwiftUI** |
| Language | **Swift** |
| Storage | **SwiftData** |
| Include Tests | **Yes** |

Click **Next**.

### Step 3: Save Location

When prompted for save location:
- Navigate to `/Users/alex/Projects/PersonalProgress/`
- **Uncheck** "Create Git repository on my Mac" (you already initialized git)
- Click **Create**

### Step 4: Replace the Default Files

Xcode creates default files (`ContentView.swift`, `Item.swift`, etc.). Replace them:

1. In Xcode's file navigator, **delete** these files (Move to Trash):
   - `ContentView.swift` (the default one)
   - `Item.swift`
   - Any auto-generated `PersonalProgressApp.swift` if it conflicts

2. Right-click each folder in the file navigator and choose **"Add Files to PersonalProgress"**, then navigate to and add the pre-written files from each folder:
   - `App/` → `PersonalProgressApp.swift`, `AppDelegate.swift`, `ContentView.swift`
   - `Core/Models/` → all `.swift` files
   - `Core/Services/` → all `.swift` files
   - `Core/Persistence/` → `PersistenceController.swift`
   - `Core/Utilities/` → all `.swift` files
   - `Features/Onboarding/` → all `.swift` files
   - `Features/Home/` → all `.swift` files
   - `Features/Domains/` → all `.swift` files
   - `Features/Letter/` → all `.swift` files
   - `Features/Reflect/` → all `.swift` files
   - `Features/Reviews/` → all `.swift` files
   - `Features/Settings/` → all `.swift` files
   - `DesignSystem/` → all `.swift` files

### Step 5: Add Preview Content

Add `Core/Utilities/PreviewData.swift` to the main target (it contains seed data for SwiftUI previews).

---

## Part 3: Build Settings

In Xcode, select the `PersonalProgress` project in the navigator, then the `PersonalProgress` target.

### Deployment Target
- Under **General → Minimum Deployments**, set **iOS 17.0**

### Capabilities
Go to **Signing & Capabilities**:

1. Click **+ Capability**
2. Add: **Face ID** (required for biometric lock)
3. Do NOT add: Push Notifications, iCloud, or any network capability in v1

### Info.plist Additions
In the target's **Info** tab, add:

| Key | Value |
|-----|-------|
| `NSFaceIDUsageDescription` | This app uses Face ID to protect your private reflections. |

---

## Part 4: Privacy Manifest

1. Right-click the `PersonalProgress` group in the navigator
2. New File → **Resource** → **App Privacy** (creates `PrivacyInfo.xcprivacy`)
3. In the file, confirm:
   - `NSPrivacyTracking` → `NO`
   - `NSPrivacyTrackingDomains` → (empty array)
   - `NSPrivacyCollectedDataTypes` → (empty array)
   - `NSPrivacyAccessedAPITypes` → (empty array — no accessed API types)

---

## Part 5: Test Target Setup

1. Select the `PersonalProgressTests` target
2. Under **General → Testing**, verify the host app is `PersonalProgress`
3. Add the pre-written test files from `PersonalProgressTests/Services/` and `PersonalProgressTests/Utilities/`

---

## Part 6: Verify the Build

```
⌘B  —  Build the project. It should compile cleanly.
⌘U  —  Run tests. All tests should pass.
⌘R  —  Run on Simulator. You should see the onboarding welcome screen.
```

If the build fails on the first try, it is almost always a missing file reference. Check that all files in the `Core/Models/` group are included in the `PersonalProgress` target (checkbox in the file inspector on the right).

---

## Part 7: Push the Xcode Project to GitHub

After the Xcode project is set up and builds cleanly:

```bash
cd /Users/alex/Projects/PersonalProgress
git add PersonalProgress.xcodeproj/
git add PersonalProgress/
git add PersonalProgressTests/
git add PersonalProgressUITests/
git commit -m "Add Xcode project and all source files"
git push origin main
```

---

## Part 8: CI Verification

The GitHub Actions workflow at `.github/workflows/ci.yml` will run automatically on push. Check it at:

`https://github.com/[your-username]/personal-progress-ios/actions`

The workflow:
1. Checks out the code
2. Runs `xcodebuild build-for-testing`
3. Runs `xcodebuild test`

If CI fails, the most common cause is the scheme name not matching. Verify the scheme name in Xcode (Product → Scheme menu) matches what's in the CI workflow file.

---

## Checklist Summary

- [ ] GitHub repo created and initial commit pushed
- [ ] Xcode project created with correct settings
- [ ] Deployment target set to iOS 17.0
- [ ] Face ID capability added
- [ ] `NSFaceIDUsageDescription` in Info.plist
- [ ] Privacy Manifest created
- [ ] All source files added to the project navigator
- [ ] Build succeeds (`⌘B`)
- [ ] Tests pass (`⌘U`)
- [ ] App runs on Simulator showing welcome screen
- [ ] Xcode project committed and pushed to GitHub
- [ ] CI workflow green
