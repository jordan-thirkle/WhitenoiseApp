# PROJECT_STATUS.md — Murmur

Last updated: 2026-04-30

## Current State

**Phase**: Phase 5 — iOS Build & Polish
**Status**: Environment restored on Mac; Codebase reconstructed.

## Completed

- [x] Research document reviewed and ingested
- [x] Implementation plan written and approved
- [x] Git repo initialized
- [x] GEMINI.md written (workspace context)
- [x] Flutter SDK installation (via Puro)
- [x] Flutter project scaffold (`flutter create`)
- [x] Marketing landing pages (Privacy, Terms) added to JordanThirkle.com
- [x] Clean default scaffold — remove counter app boilerplate
- [x] Add dependencies to `pubspec.yaml`
- [x] Implement `murmur_theme.dart`
- [x] Implement `audio_handler.dart` and base UI (`home_screen.dart`)
- [x] Android Studio and SDK installation
- [x] Android licenses accepted

- [x] Download/process audio files (Synthetically generated for foundation)
- [x] Verified Android build health (APK built successfully)

## Blocked

- None

## Next Up

1. Finalise gapless audio loops (Synthetically generated foundation in place)
2. Verify background audio persistence on iOS Simulator/Device
3. Implement Favorites system and multi-track mixing (Phase 6)

## Open Questions (need resolution before advancing)

1. **Name confirmed?** Check App Store and Play Store for "Murmur" name availability
2. **Apple Developer account**: Active? ($99/yr required for submission)
3. **Google Play Console account**: Active? ($25 one-time)
4. **Audio sources**: CC0 from Freesound.org (I can identify tracks) or self-sourced?
5. **https://jordan-thirkle-com.vercel.app/murmur stack**: What framework? (Determines how to add /murmur landing page)
6. **iOS builds**: Current machine is Mac. Xcode and Flutter are configured.

## Key Decisions Made

- Category: Health & Fitness (not Kids) — avoids Kids category review restrictions
- Monetization v1: Free, no IAP — simplest submission path
- Data model: Zero-data — no analytics, no accounts, no tracking
- Brand: Murmur (`com.jordanthirkle.murmur`)
- Audio engine: just_audio + audio_service (proven stack for background audio)
