# Daily Russian

iOS app for learning Russian with a personalized onboarding flow.

## Requirements

- Mac with **Xcode 26** (or Xcode 15+ with iOS 17 deployment target if you lower it in project settings)
- iPhone or iPad **Simulator**, or a physical device with your Apple ID for signing

## Open and run

1. Open `DailyRussian/DailyRussian.xcodeproj` in Xcode.
2. Select an **iPhone** simulator (or your device).
3. Press **⌘R** to build and run.

## What’s implemented

- **Landing** — dark hero, feature chips, Continue, “Already have an account?”
- **Onboarding** — referral → persona → (work + social proof for professionals) → goals → testimonial → feature pick → (class/exam for students/teachers) → daily goal
- **Local profile** — saved via `UserProfileRepository` (UserDefaults); swappable for cloud later
- **Placeholder** — sign-in stub and main screen after onboarding

## Reset onboarding (testing)

On the main placeholder screen, tap **Reset onboarding (debug)**. Or delete the app from the Simulator and run again.

UserDefaults keys: `onboardingProfile`, `hasCompletedOnboarding`.

## Project layout

```
DailyRussian/
  DailyRussian.xcodeproj
  DailyRussian/
    AppRootView.swift
    DesignSystem/
    Features/Onboarding/
    Features/Auth/
    Features/Main/
    Services/
```

## Repo

Remote: `git@github.com:pironc/daily_russian.git`
