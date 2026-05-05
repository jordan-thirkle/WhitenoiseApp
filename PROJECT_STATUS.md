# Murmur — Project Status

**Current Version**: v1.1.0+13 (Built-Right MVP)
**Status**: SUBMISSION READY (May 2026)
**Platform**: iOS 26 (Xcode 26) / Android 16 (API 36)

## 🚀 Recent Progress (Hardening Phase)
- **Thermal Intelligence**: Implemented `ThermalService` for dynamic device temperature monitoring with real-time UI feedback.
- **HealthKit Sync**: Integrated functional HealthKit/Google Fit synchronization for wellness-focused sleep tracking.
- **Web Demo Engine**: Refactored `AudioEngineRepository` with conditional fallback (Audioplayers) to support browser-based demonstrations.
- **Repo Unification**: Unified `JordanThirkle.com` into the main repository and configured `murmur.vercel.app` for the live app demo.
- **Cleanup**: Sanitized repository structure while preserving critical website integration and the web platform for demo purposes.

## ✅ Completed Milestones
- [x] SoLoud Engine Integration (FFI)
- [x] OGG Vorbis Asset Standardization
- [x] Multi-track Mixing (Volume + Tone)
- [x] Master Stop & Master Limiter
- [x] Mix Saving & Recalling (Favorites)
- [x] Precision Sleep Timer with 'Zero-Startle' Fade
- [x] **2026 Submission Hardening (May 2026 Baseline)**
  - Manual Matter-over-IP Local Control (Scene Broadcast)
  - SPAKE2+ Zero-Knowledge Secure P2P Sync
  - Lifetime "Murmur Pro" IAP Monetization
  - iOS Privacy Manifest & Android 16 System UI
  - High-Resolution Branded Splash & Adaptive Icons

## 📋 Immediate Roadmap
- [ ] Upload v1.1.0+13 to App Store Connect / Play Console.
- [ ] Submit for review as a "Premium Wellness Utility" (Non-Medical).
- [ ] Monitor v1.0 launch metrics for potential v2.0 feature roadmap.

## 🛠 Tech Stack
- **Framework**: Flutter
- **Engine**: SoLoud (C++/FFI)
- **State**: Riverpod
- **Storage**: SharedPreferences
- **Compliance**: Xcode 26 / Android 16 (API 36)
- **Networking**: Matter 1.3 / mDNS / SPAKE2+
