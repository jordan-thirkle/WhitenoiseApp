# Murmur Play Store Hardening & Compliance

This document tracks how Murmur complies with Google Play Store requirements as of May 2026.

## Build, Release & Update

### Target API Level
- **Requirement**: Meet target API level requirements (API 35/36).
- **Status**: [x] Compliant.
- **Implementation**: `android/app/build.gradle.kts` specifies `targetSdk = 35`.

### Play Asset Delivery
- **Requirement**: Optimize delivery of assets for games/apps.
- **Status**: [ ] Planned for future expansion.
- **Note**: Currently, assets are bundled in the OBB/Main APK as they are < 50MB. If audio library grows, we will migrate to Play Asset Delivery (PAD).

### In-App Updates
- **Requirement**: Prompt users to update.
- **Status**: [ ] Future implementation.
- **Note**: Murmur is designed for offline use. In-app updates will be added once the base features are stabilized.

## Acquire & Engage

### Play Engage SDK
- **Requirement**: Re-engage users.
- **Status**: [ ] N/A.
- **Note**: Murmur is a "Zero Engagement" utility. We deliberately avoid push notifications and engagement prompts to preserve user privacy and mental space.

### Play In-App Reviews
- **Requirement**: Prompt for ratings.
- **Status**: [ ] Planned.
- **Note**: Will be implemented with a strict "once per major version" limit to avoid annoyance.

## Privacy & Safety (Murmur Specialization)

### COPPA / GDPR-K
- **Compliance**: Murmur collects **zero** personal data, uses **no** tracking SDKs, and performs **no** cloud synchronization. 
- **Privacy Policy**: [jordanthirkle.com/murmur/privacy](https://jordanthirkle.com/murmur/privacy)

### Background Playback
- **Compliance**: Uses `audio_service` to maintain a foreground notification while playing audio, ensuring the OS does not kill the process during sleep.

## Audio Engine Stability

### Resource Isolation
- **Fix**: Refactored `AudioEngineRepository` to use `soundId` as the unique key. This prevents assets sharing the same file (e.g., `brown_noise.ogg`) from conflicting in the engine.
- **Memory Management**: Implemented lazy-loading of audio assets. Sources are only loaded into memory when first played.
