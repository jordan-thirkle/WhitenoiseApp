# Murmur — Google Play Compliance & Quality Standards (GEMINI.md)

<!--
  SCOPE: This file enforces compliance with Google Play Core App Quality and Technical standards.
  It acts as a living audit log and a set of enforcement rules for future development.
-->

## 🎯 High-Level Objectives
- **Core Quality**: Premium UI/UX, Material 3, Edge-to-Edge compliance.
- **Technical Excellence**: Modern API targeting (Android 15+), App Bundles, optimized performance.
- **Data Sovereignty**: Zero-cloud, local-only storage, privacy-first architecture.

---

## 🏗️ Technical Standards

### 1. Modern API Targeting (Android 15/16)
- **Rule**: Every build must target the latest stable API level (Target SDK 35/36).
- **Status**: [PASS] 	argetSdk = 35 (Current baseline for 2026).
- **Enforcement**: Build will fail if 	argetSdk is lowered.

### 2. Adaptive & Edge-to-Edge Design
- **Rule**: App must support transparent system bars and utilize full screen real estate.
- **Implementation**: SystemUiMode.edgeToEdge initialized in main.dart.
- **Status**: [PASS]

### 3. Audio & Background Stability
- **Rule**: Use AudioService with FOREGROUND_SERVICE_MEDIA_PLAYBACK to prevent system killing.
- **Status**: [PASS] Integrated with udio_service plugin.

---

## 🔒 Privacy & Safety

### 1. Data Safety Declaration
- **Rule**: Zero personal data collected. No tracking SDKs.
- **Status**: [PASS] Audit confirms no Firebase, no Analytics, no Facebook SDK.
- **Disclosure**:
    - **Health Data**: Written to OS Health Dashboard only; never transmitted.
    - **P2P Sync**: Local-only via SPAKE2+; no cloud relay.

### 2. COPPA / GDPR-K Compliance
- **Rule**: App must not request age or personal identifiers from minors.
- **Status**: [PASS] Anonymous-by-design.

---

## 📋 Audit Checklist

- [x] **Material 3**: useMaterial3: true enabled.
- [x] **Minify & Shrink**: isMinifyEnabled and isShrinkResources enabled for release.
- [x] **In-app Reviews**: Integrated via `in_app_review` (Triggered after 5 sessions).
- [x] **In-app Updates**: Integrated via `in_app_update` (Immediate/Flexible check on launch).
- [x] **Play Integrity**: Integrated via `PlayServicesHelper` (Guards P2P Sync).

---

## 🛠️ Enforcement Protocol
- No PR shall be merged that adds a tracking dependency.
- All new UI must be tested against multiple screen sizes (Adaptive Layouts).
- Build must be verified with dart analyze and lutter build appbundle before any release commit.
