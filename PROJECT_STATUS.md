# PROJECT_STATUS.md — Murmur

Last updated: 2026-04-30

## Current State

**Phase**: Foundation — repo setup and Flutter scaffold
**Status**: In progress

## Completed

- [x] Research document reviewed and ingested
- [x] Implementation plan written and approved
- [x] Git repo initialized
- [x] GEMINI.md written (workspace context)

## In Progress

- [ ] Flutter SDK installation (not yet installed on machine)
- [ ] Flutter project scaffold (`flutter create`)

## Blocked

- **Flutter not installed**: `flutter` command not found on PATH. Need to install Flutter SDK before `flutter create` can run.
  - Download: https://docs.flutter.dev/get-started/install/windows/mobile
  - After install, run `flutter doctor` and resolve any issues
  - Xcode required on Mac for iOS builds (this is Windows — iOS builds need a Mac or CI)

## Next Up (after Flutter installed)

1. `flutter create --org com.jordanthirkle --project-name murmur murmur/`
2. Clean default scaffold — remove counter app boilerplate
3. Add dependencies to `pubspec.yaml`
4. Implement `murmur_theme.dart`
5. Implement `audio_handler.dart`

## Open Questions (need resolution before advancing)

1. **Name confirmed?** Check App Store and Play Store for "Murmur" name availability
2. **Apple Developer account**: Active? ($99/yr required for submission)
3. **Google Play Console account**: Active? ($25 one-time)
4. **Audio sources**: CC0 from Freesound.org (I can identify tracks) or self-sourced?
5. **jordanthirkle.com stack**: What framework? (Determines how to add /murmur landing page)
6. **iOS builds**: This machine is Windows. iOS builds require a Mac or a CI service (Codemagic, GitHub Actions with macOS runner). Decision needed before Phase 5.

## Key Decisions Made

- Category: Health & Fitness (not Kids) — avoids Kids category review restrictions
- Monetization v1: Free, no IAP — simplest submission path
- Data model: Zero-data — no analytics, no accounts, no tracking
- Brand: Murmur (`com.jordanthirkle.murmur`)
- Audio engine: just_audio + audio_service (proven stack for background audio)
