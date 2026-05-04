import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final thermalServiceProvider = Provider((ref) => ThermalService());

class ThermalService {
  static const MethodChannel _channel = MethodChannel('com.jordanthirkle.murmur/thermal');

  /// Returns the thermal headroom for the next [seconds] seconds.
  /// Android API 31+ only. Returns 1.0 (nominal) on unsupported platforms.
  Future<double> getThermalHeadroom(int seconds) async {
    try {
      final double? headroom = await _channel.invokeMethod('getThermalHeadroom', {'seconds': seconds});
      return headroom ?? 1.0;
    } on PlatformException catch (e) {
      // Fallback for older Android versions or iOS
      return 1.0;
    }
  }

  /// Categorizes thermal state into a ThrottlingLevel for the AI engine.
  Future<ThrottlingLevel> getThrottlingLevel() async {
    final headroom = await getThermalHeadroom(30);
    if (headroom > 0.9) return ThrottlingLevel.nominal;
    if (headroom > 0.7) return ThrottlingLevel.fair;
    if (headroom > 0.4) return ThrottlingLevel.heavy;
    return ThrottlingLevel.critical;
  }
}

enum ThrottlingLevel {
  nominal, // 100% batch size
  fair,    // 75% batch size
  heavy,   // 50% batch size; disable non-critical DSP
  critical // 25% batch size; core audio loop only
}
