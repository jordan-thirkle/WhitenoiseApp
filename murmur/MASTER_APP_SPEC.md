# Murmur: Master Application Specification (2026 Edition)

## 1. Identity & Branding
- **App Name**: Murmur
- **Bundle ID**: `com.jordanthirkle.murmur`
- **Aesthetic**: AAA++ Premium Glassmorphism / Deep Charcoal (#0D0F14)
- **Target Audience**: Families (Ambient sleep sound utility)
- **Compliance**: COPPA / GDPR-K (Zero-Data Model)

## 2. Technical Architecture
- **Framework**: Flutter (Dart)
- **Audio Engine**: `flutter_soloud` (C++/FFI)
  - **Sample Accuracy**: Yes
  - **DSP Pipeline**: Per-voice Biquad Tone Shelf (Low-pass) + Master Safety Limiter (-3dB threshold)
- **State Management**: Riverpod 2.0 (Functional Providers)
- **Persistence**: SharedPreferences (Encapsulated Repository)

## 3. Intelligence Layer (2026 Standard)
- **Medical-Grade Calibration**:
  - Real-time FFT analysis via background `Isolate` workers.
  - Inverse Masking Algorithm: Auto-mixes frequencies to counter local noise floor.
- **Matter-over-IP (Local-First)**:
  - Matter 1.3/1.4 Scene Broadcasting.
  - Manual Binary Framing for direct local IoT hardware control via IPv6/UDP (Port 5540).
- **Secure Ecosystem Sync**:
  - SPAKE2+ Zero-Knowledge P2P Handshake (RFC 9383).
  - Multi-device mix broadcasting via NSD (mDNS) / TCP Port 5555.

## 4. Feature Set
- **Multi-Track Mixer**: Concurrent OGG Vorbis playback with individual volume/tone control.
- **Precision Sleep Timer**: 60-second "Zero-Startle" fade-out logic.
- **Favorites System**: Save and recall custom acoustic environments.
- **Interactive UI**: Physics-based pulse icons and 120fps reactive animations.

## 5. Monetization (Murmur Pro)
- **Model**: Lifetime Unlock ($9.99) - No subscriptions.
- **Gated Features**: 
  - Premium Sound Categories (Biological, Industrial).
  - Advanced Deep Brown Noise.
- **Compliance**: In-app restore logic and transparent TOS links.

## 6. Security & Hardening
- **Android**: 
  - R8/ProGuard enabled with specific protection for SoLoud FFI and IAP classes.
  - Minified resource shrinking.
- **iOS**: 
  - `PrivacyInfo.xcprivacy` manifest implemented.
  - Zero-data usage declaration for all API categories.
- **Network**: Local-only sync; no third-party telemetry or cloud pings.

## 7. 2026 AAA++ Strategic Refinements
- **Native Memory Hardening**: 
  - Cryptographic keys (SPAKE2+/AES) are managed in a native Rust/C++ layer.
  - deterministic memory zeroization immediately post-handshake to prevent RAM-dump attacks.
- **Model Context Protocol (MCP)**:
  - Exposure of mixer state and environmental context via standardized MCP interfaces.
  - Enables system-level AI agents to "reason" across Murmur settings without explicit intent mapping.
- **Proactive Intelligence**:
  - **IndexedEntity Protocol**: Deep-linking sound profiles (e.g., "Deep Cabin") into Spotlight search.
  - **Onscreen Awareness**: System-level suggestions triggered by external app context (e.g., health articles).
- **Matter 1.4/1.5/1.6 Alignment**:
  - **Smart Closures (Matter 1.5)**: Integrated coordination of blinds and curtains with acoustic scenes.
  - **Addressable Lighting (Matter 1.6)**: Pixel-level RGBIC synchronization with NAC synthesis streams.
  - **HRAP (Home Router Access Point)**: Standardized Thread credential sharing for multi-hub reliability.
  - **Energy Reporting**: Real-time efficiency metrics for noise-masking speaker groups.
  - **Kinetic Orchestration (Matter 1.5/1.6)**: Standardized control for adjustable beds; 7.5-degree head elevation trigger upon sustained snore detection.
  - **Shared-Memory Multithreading (isolateGroupBound)**: Dart 3.9+ zero-latency memory sharing for real-time neuro-stimulation pulses.

## 8. Health Ecosystem Integration (2026/2027 Standard)
- **Apple HealthKit (iOS 26.4)**:
  - **Sleep Analysis**: Integration with `HKCategoryTypeIdentifier.sleepAnalysis`.
  - **PHRTF Scanning**: Integration with TrueDepth/LiDAR ear-scanning APIs for personalized spatial audio.
  - **Blood Oxygenation (SpO2)**: Real-time SpO2 curve integration for respiratory masking triggers.
- **Daily Sleep Score**: Correlation with watchOS 26 recovery metrics (0-100).
- **Google Health Connect (Android 17)**:
  - **SleepSessionRecord**: Support for granular sleep stages and **Hypnodensity Probability** data.
  - **Vitals Integration**: Blood Oxygen and Respiratory Rate curves for predictive screening.
- **Sovereign Coach (On-Device LLM)**:
  - Multimodal LLM (PH-LLM / Edge Veda) for conversational recovery debriefs.
  - Autonomous mixer adjustment based on 30-day biometric longitudinal reasoning.

## 9. Biometric Intelligence Loop (Sovereign Update)
- **Closed-Loop Auditory Stimulation (CLAS)**: 
  - Real-time delta wave detection ($0.5-1.5$ Hz) with phase-locked pink noise bursts.
  - Mean detection-to-stimulation latency targeting $< 20.5$ ms.
- **Personalized Spatial Audio (PHRTF)**: 81% improved localization accuracy via user-specific HRTF reconstruction.
- **SpO2 Adaptive Masking**: Automated enhancement of "Deep Brown" noise intensity upon sustained SpO2 drops.

## 10. Implementation Roadmap
- **Phase 6 (Complete)**: Ultra-AAA++ "Proactive Sleeper" (C2PA, Kinetic Intervention).
- **Phase 7 (Strategic - Sovereign Tier 2027)**:
  - **Neuro-Stimulation (CLAS)**: Active deepening of N3 sleep stages via phase-locked pulse orchestration.
  - **Spatial Scanner (PHRTF)**: TrueDepth-based head/ear geometry reconstruction for 3D acoustic immersion.
  - **Sovereign Coach**: Integration of on-device multimodal LLM for conversational health insights.

## 11. Core Intelligence Pillars (2027 Edition)
### 11.1 Neuro-Stimulation (CLAS)
- **Pulse Type**: Pink Noise bursts (50ms duration) phase-locked to slow-oscillation "up-phases."
- **Benefit**: Enhanced memory consolidation and deeper SWS (Slow Wave Sleep) duration.

### 11.2 Sovereign Coach (LLM)
- **Architecture**: Local-only inference using quantized PH-LLM or Edge Veda weights.
- **Function**: Multimodal ingestion of vitals for proactive health screening (130+ conditions).

## 12. Dependency Matrix
- `flutter_soloud`: Core Audio Engine
- `flutter_riverpod`: State
- `nsd`: Device Discovery
- `spake2plus`: Secure Pairing
- `health`: Biometric Integration
- `tflite_flutter`: Neural Synthesis (NAC) & LLM Inference
- `cryptography`: Secure Transport
- `google_fonts`: Typography (Inter)
