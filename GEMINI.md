# GEMINI.md — Murmur (Workspace)

## Project Overview

**App Name**: Murmur
**Type**: Flutter mobile app (iOS + Android)
**Bundle ID**: `com.jordanthirkle.murmur`
**Category**: Health & Fitness (NOT Kids category — see implementation plan for rationale)
**Purpose**: Ambient sleep sound app for families. Replaces YouTube Kids for overnight audio. Core feature is indefinite background playback with no engagement prompts.

## Repository Structure

```
WhitenoiseApp/
├── GEMINI.md               ← this file
├── PROJECT_STATUS.md
├── research.md
├── .gitignore
└── murmur/                 ← Flutter project root
    ├── lib/
    ├── assets/
    ├── android/
    ├── ios/
    └── pubspec.yaml
```

## Tech Stack

- **Framework**: Flutter (Dart)
- **Audio engine**: `just_audio` + `audio_service` + `just_audio_background`
- **State management**: `provider`
- **Storage**: `shared_preferences` (timer prefs only — no user data)
- **External links**: `url_launcher`
- **No analytics SDK** — zero-data compliance model

## Architecture Rules

- Feature-first folder structure under `lib/features/`
- Shared code in `lib/core/`
- Models in `lib/models/`
- No business logic in widgets
- `AudioHandler` is the single source of truth for playback state

## Design System

- Background: `#0D0F14`
- Surface: `#161A23`
- Accent: `#7BA7F5`
- Text primary: `rgba(255,255,255,0.87)`
- Text secondary: `rgba(255,255,255,0.60)`
- Font: Inter (Google Fonts)
- Min touch target: 48x48dp
- Dark theme only — no light mode

## Compliance

- COPPA / GDPR-K compliant via zero-data model
- No personal data collected
- No tracking SDKs
- Privacy Policy hosted at: `jordanthirkle.com/murmur/privacy`
- Terms of Service at: `jordanthirkle.com/murmur/terms`

## Commit Convention

Conventional Commits. Body required — explain WHY, not WHAT.
`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

## Audio Asset Spec

- Format: `.m4a` (AAC 128kbps)
- Duration: ≥ 3 minutes
- Loop type: seamless equal-power crossfade
- License: CC0 / royalty-free commercial
- Max size: 4MB per file
