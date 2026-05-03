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

## 8. Health Ecosystem Integration (2026 Standard)
- **Apple HealthKit (iOS 26.4)**:
  - **Sleep Analysis**: Integration with `HKCategoryTypeIdentifier.sleepAnalysis`.
  - **Bedtime Consistency**: Visualization of variance against 2-week averages.
  - **Blood Oxygenation (SpO2)**: Real-time SpO2 curve integration for respiratory masking triggers.
  - **Daily Sleep Score**: Correlation with watchOS 26 recovery metrics (0-100).
- **Google Health Connect (Android 17)**:
  - **SleepSessionRecord**: Support for granular sleep stages and **Hypnodensity Probability** data.
  - **Vitals Integration**: Blood Oxygen and Respiratory Rate curves for predictive screening.
- **Predictive Health Screening**: 
  - AI-driven analysis of vitals to flag early signs of 130+ cardiac/respiratory conditions.
  - "Proactive Health Report" generation for clinical bridge support.

## 9. Biometric Intelligence Loop (2026 Update)
- **Probabilistic Hypnodensity**: Transition from rigid sleep stages to probability-based visualization (addressing the ~28% uncertainty epoch range).
- **SpO2 Adaptive Masking**: Automated enhancement of "Deep Brown" noise intensity upon sustained SpO2 drops during the night.

## 10. Implementation Roadmap
- **Phase 5 (Complete)**: AAA++ Final Gap (NAC, Snore Neutralization, MCP).
- **Phase 6 (Strategic - Ultra-AAA++ "Proactive Sleeper")**:
  - **Ethical AI (C2PA)**: Embedding digital provenance signatures in all on-device NAC synthesis.
  - **Kinetic Mitigation**: Direct Matter control of bed headboards for airway obstruction relief.
  - **Hypnodensity Visualization**: AI-driven probabilistic charts for medically-accurate sleep reporting.

## 11. Core Intelligence Pillars (2026 Edition)
### 11.1 Neural Synthesis (NAC) & C2PA
- **Engine**: On-device micro-model for real-time NAC decoding.
- **Provenance**: C2PA metadata embedding to prove on-device synthesis and ethical AI compliance.

### 11.2 Active Snore Neutralization & Kinetic Intervention
- **Detection**: Frequency/Amplitude analysis of snore patterns via background isolates.
- **Acoustic**: Real-time generation of phase-inverted waves ($\phi$) to diminish perception.
- **Kinetic**: Triggering 7.5-degree head elevation on Matter-compatible bed clusters (Phase 6).

### 11.3 Agentic Control (MCP)
- **Interface**: Structured MCP server exposing calibration data and mixer state.
- **Multi-hop Reasoning**: Enabling AI agents to adjust environments based on cross-app biometric signals (e.g., SpO2 drops).

## 12. Dependency Matrix
- `flutter_soloud`: Core Audio Engine
- `flutter_riverpod`: State
- `nsd`: Device Discovery
- `spake2plus`: Secure Pairing
- `health`: Biometric Integration
- `tflite_flutter`: Neural Synthesis (NAC) Inference
- `cryptography`: Secure Transport
- `google_fonts`: Typography (Inter)
