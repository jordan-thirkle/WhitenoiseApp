# GEMINI.md — Murmur (Workspace)

## Project Overview

**App Name**: Murmur
**Type**: Flutter multi-platform app (iOS + Android + Web)
**Bundle ID**: `com.jordanthirkle.murmur`
**Category**: Health & Fitness (Premium Wellness Utility)
**Purpose**: High-fidelity ambient sleep sound app for families. Optimized for indefinite background playback with zero engagement prompts and absolute privacy.

## Repository Structure

```
WhitenoiseApp/
├── GEMINI.md               ← this file
├── PROJECT_STATUS.md
├── research.md
├── .gitignore
├── JordanThirkle.com/      ← Personal website integration
└── murmur/                 ← Flutter project root
    ├── lib/
    ├── assets/
    ├── android/
    ├── ios/
    ├── web/                ← Web demo / Project page
    └── pubspec.yaml
```

## Tech Stack

- **Framework**: Flutter (Dart)
- **Audio engine**: `flutter_soloud` (C++/FFI) + `audio_service`
- **State management**: `flutter_riverpod`
- **Storage**: `shared_preferences` (Local-only, zero-cloud)
- **Compliance**: Xcode 26 / Android 16 (API 36) Edge-to-Edge
- **Privacy**: `PrivacyInfo.xcprivacy` (iOS) / Zero-Data Manifest

## Architecture Rules

- Feature-first folder structure under `lib/features/`
- Shared code in `lib/core/`
- Models in `lib/models/`
- No business logic in widgets
- `AudioEngineRepository` handles DSP/Soloud orchestration

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
- Privacy Policy: `https://jordanthirkle.com/murmur/privacy`

## Commit Convention

Conventional Commits. Body required — explain WHY, not WHAT.
`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

## Audio Asset Spec

- Format: `.ogg` (Vorbis High-Fidelity)
- Duration: Seamless loops
- Engine: SoLoud (Biquad Filters / Master Limiter)
- License: CC0 / royalty-free commercial
