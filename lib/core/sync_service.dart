// Conditional export: on web, use the web implementation.
// On native, use the real implementation with nsd + spake2plus.
export 'sync_service_native.dart' if (dart.library.js_interop) 'sync_service_web.dart';

