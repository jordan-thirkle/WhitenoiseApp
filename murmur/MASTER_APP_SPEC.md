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
  - **Kinetic Orchestration (Matter 1.5/1.6)**: Standardized control for adjustable beds; 7.5-degree head elevation trigger upon sustained snore detection.
  - **Active Recovery (Matter 1.7)**: Dynamic scheduling of smart closures to extend sleep cycles based on suboptimal biometric recovery trends.
  - **Shared-Memory Multithreading (isolateGroupBound)**: Dart 3.9+ zero-latency memory sharing for EEG artifact rejection and CLAS pulses.

## 8. Health Ecosystem Integration (2026/2027 Standard)
- **EEG Hardware Bridge (2027 Sovereign)**:
  - Integration with Muse 2/S, BrainBit, and Neurosity SDKs for real-time Fp1/Fp2 brainwave monitoring.
  - **Signal Quality Index (SQI)**: Real-time visualization of electrode contact stability.
- **Apple HealthKit (iOS 26.4)**:
  - **Sleep Analysis**: Integration with `HKCategoryTypeIdentifier.sleepAnalysis`.
  - **PHRTF Scanning**: Integration with TrueDepth/LiDAR ear-scanning APIs.
- **Google Health Connect (Android 17)**:
  - **SleepSessionRecord**: Support for granular sleep stages and **Hypnodensity Probability** data.
- **Sovereign Coach (On-Device LLM)**:
  - Multimodal LLM (PH-LLM / Edge Veda) for autonomous mixer adjustment and "Active Recovery" orchestration.

## 9. Biometric Intelligence Loop (Sovereign Update)
- **Closed-Loop Auditory Stimulation (CLAS)**: 
  - Real-time delta wave detection using EEG-sourced slow-wave oscillations.
  - **Artifact Rejection Isolate**: Zero-latency filtering of eye blinks and muscle noise via `isolateGroupBound`.
- **Neuro-Link Dashboard**: Real-time visualization of SQI and Targeting Success Rate (phase-lock accuracy).
- **SpO2 Adaptive Masking**: Automated enhancement of "Deep Brown" noise intensity upon SpO2 drops.

## 10. Implementation Roadmap
- **Phase 7 (Strategic - Sovereign Tier 2027)**:
  - **EEG Integration**: Hardware bridge for Muse/Neurosity dry-electrode brainwave telemetry.
  - **Neuro-Link UI**: Real-time signal quality and CLAS success metrics.
  - **Active Recovery**: Matter 1.7 dynamic closure scheduling for emergency sleep extension.

## 11. Core Intelligence Pillars (2027 Edition)
### 11.1 Neuro-Stimulation (CLAS) & EEG
- **Signal Source**: Forehead Fp1/Fp2 channels via integrated EEG SDKs.
- **Detection**: Phase-locking pulses to Slow-Oscillation (SO) "up-phases."
- **Artifact Rejection**: Dedicated high-performance isolate for dry-electrode noise filtering.

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
