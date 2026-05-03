import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/audio_engine_repository.dart';

class TimerState {
  final Duration? remaining;
  final bool isRunning;
  final int? selectedMinutes;

  TimerState({this.remaining, this.isRunning = false, this.selectedMinutes});

  TimerState copyWith({Duration? remaining, bool? isRunning, int? selectedMinutes}) {
    return TimerState(
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      selectedMinutes: selectedMinutes ?? this.selectedMinutes,
    );
  }
}

class TimerController extends StateNotifier<TimerState> {
  final AudioEngineRepository _repository;
  Timer? _ticker;

  TimerController(this._repository) : super(TimerState());

  void setTimer(int minutes) {
    _ticker?.cancel();
    state = TimerState(
      remaining: Duration(minutes: minutes),
      isRunning: true,
      selectedMinutes: minutes,
    );
    
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remaining == null || state.remaining!.inSeconds <= 0) {
        _onFinished();
      } else {
        state = state.copyWith(remaining: state.remaining! - const Duration(seconds: 1));
        
        // Start fading when 60 seconds are left
        if (state.remaining!.inSeconds == 60) {
          _startFadeOut();
        }
      }
    });
  }

  void cancelTimer() {
    _ticker?.cancel();
    state = TimerState();
  }

  void _startFadeOut() {
    // In a premium app, we use the engine's native fading
    _repository.stopAllWithFade(const Duration(seconds: 60));
  }

  void _onFinished() {
    _ticker?.cancel();
    _repository.stopAll();
    state = TimerState();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final timerControllerProvider = StateNotifierProvider<TimerController, TimerState>((ref) {
  final repository = ref.watch(audioEngineProvider);
  return TimerController(repository);
});
