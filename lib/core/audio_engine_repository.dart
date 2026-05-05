import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_engine_native.dart' if (dart.library.js_interop) 'audio_engine_web_impl.dart';
export 'audio_engine_native.dart' if (dart.library.js_interop) 'audio_engine_web_impl.dart';

final audioEngineProvider = Provider((ref) => AudioEngineRepository());
