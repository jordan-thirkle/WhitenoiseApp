import 'dart:isolate';
import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';
import 'dsp_worker.dart';

class AcousticCalibrationService {
  final AudioRecorder _recorder = AudioRecorder();
  Isolate? _dspIsolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;
  
  /// Performs a 3-second real-time FFT analysis of the room's noise floor.
  Future<List<double>> analyzeRoom() async {
    if (!await _recorder.hasPermission()) {
      debugPrint('Microphone permission denied');
      return [];
    }

    // Initialize Worker Isolate
    _mainReceivePort = ReceivePort();
    _dspIsolate = await Isolate.spawn(dspWorker, _mainReceivePort!.sendPort);
    
    final Completer<SendPort> portCompleter = Completer();
    final List<double> combinedFft = List.filled(256, 0.0);
    int fftCount = 0;

    final Stream<Uint8List> audioStream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      ),
    );

    debugPrint('Starting high-performance acoustic calibration...');
    
    final Completer<List<double>> calibrationCompleter = Completer();
    
    StreamSubscription? audioSubscription;
    StreamSubscription? isolateSubscription;

    isolateSubscription = _mainReceivePort!.listen((message) {
      if (message is SendPort) {
        portCompleter.complete(message);
        _workerSendPort = message;
      } else if (message is DspResult) {
        for (int i = 0; i < 256; i++) {
          combinedFft[i] += message.magnitudes[i];
        }
        fftCount++;
      }
    });

    await portCompleter.future;

    Timer(const Duration(seconds: 3), () async {
      await audioSubscription?.cancel();
      await isolateSubscription?.cancel();
      await _recorder.stop();
      _workerSendPort?.send(DspCommand(stop: true));
      _mainReceivePort?.close();
      
      if (fftCount > 0) {
        final result = combinedFft.map((v) => v / fftCount).toList();
        calibrationCompleter.complete(result);
      } else {
        calibrationCompleter.complete([]);
      }
    });

    audioSubscription = audioStream.listen((Uint8List chunk) {
      // Wrap in TransferableTypedData for zero-copy transfer
      final transferable = TransferableTypedData.fromList([chunk]);
      _workerSendPort?.send(DspCommand(data: transferable));
    });

    return calibrationCompleter.future;
  }

  void dispose() {
    _recorder.dispose();
    _workerSendPort?.send(DspCommand(stop: true));
    _dspIsolate?.kill();
    _mainReceivePort?.close();
  }
}
