import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SoundtrackManager {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription? _completeSubscription;

  bool _isLoopingPhase = false;
  bool _loopPreloaded = false;

  Future<void> initAndStart() async {
    await _player.setPlayerMode(PlayerMode.mediaPlayer);
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      _onTrackFinished();
    });
    _isLoopingPhase = false;
    _player.setSource(AssetSource('sounds/loop.ogg')).then((_) {
      _loopPreloaded = true;
    });
    await _player.setReleaseMode(ReleaseMode.release);
    await _player.play(AssetSource('sounds/countdown.ogg'));
  }

  void _onTrackFinished() async {
    if (_isLoopingPhase) return;
    _isLoopingPhase = true;
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/loop.ogg'));
  }

  void dispose() {
    _completeSubscription?.cancel();
    _player.stop();
    _player.dispose();
  }
}
