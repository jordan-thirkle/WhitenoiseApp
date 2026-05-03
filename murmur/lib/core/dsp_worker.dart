import 'dart:isolate';
import 'dart:typed_data';
import 'package:fftea/fftea.dart';

/// The command sent to the DSP worker.
class DspCommand {
  final SendPort? replyPort;
  final TransferableTypedData? data;
  final bool stop;

  DspCommand({this.replyPort, this.data, this.stop = false});
}

/// The result sent back from the DSP worker.
class DspResult {
  final List<double> magnitudes;
  DspResult(this.magnitudes);
}

/// Entry point for the DSP Isolate.
void dspWorker(SendPort mainSendPort) {
  final ReceivePort workerReceivePort = ReceivePort();
  mainSendPort.send(workerReceivePort.sendPort);

  const int fftSize = 512;
  final stft = STFT(fftSize, Window.hanning(fftSize));
  final List<double> pcmBuffer = [];

  workerReceivePort.listen((message) {
    if (message is DspCommand) {
      if (message.stop) {
        Isolate.exit();
      }

      if (message.data != null) {
        final Uint8List chunk = message.data!.materialize().asUint8List();
        
        // Convert PCM16 to double
        final List<double> doubles = [];
        for (int i = 0; i < chunk.length; i += 2) {
          if (i + 1 < chunk.length) {
            int sample = (chunk[i+1] << 8) | chunk[i];
            if (sample > 32767) sample -= 65536;
            doubles.add(sample / 32768.0);
          }
        }

        // Use STFT.stream for continuous processing
        stft.stream(doubles, (Float64x2List freqChunk) {
          final magnitudes = freqChunk.magnitudes();
          // Send back the first half (real FFT)
          mainSendPort.send(DspResult(magnitudes.sublist(0, 256)));
        });
      }
    }
  });
}
