# Murmur Production ProGuard Rules
# Specifically protects the SoLoud C++/FFI bridge and audio logic

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# SoLoud FFI protection
-keep class com.maru.flutter_soloud.** { *; }
-keepnames class com.maru.flutter_soloud.** { *; }

# Just Audio & Audio Service
-keep class com.ryanheise.audio_service.** { *; }
-keep class com.ryanheise.just_audio.** { *; }

# Google Fonts
-keep class com.google.fonts.** { *; }

# In-App Purchase
-keep class com.android.billingclient.** { *; }

# JNI / Native symbols preservation for SoLoud
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve synthetic sounds logic
-keep class murmur.core.** { *; }
