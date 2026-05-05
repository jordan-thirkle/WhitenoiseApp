// Conditional export: on web, use the stub (no FFI deps).
// On native, use the real implementation with nsd + spake2plus.
export 'sync_service_native.dart' if (dart.library.html) 'sync_service_stub.dart';
