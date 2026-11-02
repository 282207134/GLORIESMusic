import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/catalog.dart';
import '../models/media.dart';

/// App-wide mutable state: what is playing, and the handful of switches the
/// settings screens expose.
///
/// Playback is simulated with a [Timer] rather than a real audio engine — the
/// Pixso reference is a visual spec with no audio assets behind it, and a tick
/// keeps the progress bar, mini player and lyric highlight all in sync without
/// pulling in a platform plugin.
class AppStore extends ChangeNotifier {
  AppStore() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _advance());
  }

  late final Timer _ticker;

  List<Track> _queue = Catalog.mix;
  int _index = 0;
  bool _playing = false;
  Duration _position = Duration.zero;
  double _volume = 0.5;
  bool _shuffle = false;
  bool _repeat = false;

  bool autoPlayRelated = true;
  Set<String> selectedGenres = <String>{'Alternative', 'New wave', 'Soul'};

  Track get currentTrack => _queue[_index];
  List<Track> get queue => List<Track>.unmodifiable(_queue);
  bool get isPlaying => _playing;
  bool get isShuffle => _shuffle;
  bool get isRepeat => _repeat;
  Duration get position => _position;
  double get volume => _volume;

  /// 0..1 across the whole track, for the scrubber.
  double get progress {
    final int total = currentTrack.duration.inSeconds;
    return total == 0 ? 0 : (_position.inSeconds / total).clamp(0.0, 1.0);
  }

  String get remainingLabel {
    final Duration left = currentTrack.duration - _position;
    final int m = left.inMinutes;
    final int s = left.inSeconds.remainder(60);
    return '-$m:${s.toString().padLeft(2, '0')}';
  }

  String get positionLabel {
    final int m = _position.inMinutes;
    final int s = _position.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void play(List<Track> tracks, {int startAt = 0}) {
    if (tracks.isNotEmpty) {
      _queue = tracks;
    }
    _index = startAt.clamp(0, _queue.length - 1);
    _position = Duration.zero;
    _playing = true;
    notifyListeners();
  }

  void togglePlay() {
    _playing = !_playing;
    notifyListeners();
  }

  void skip(int delta) {
    if (_queue.isEmpty) return;
    _index = (_index + delta) % _queue.length;
    _position = Duration.zero;
    notifyListeners();
  }

  void seek(double fraction) {
    _position = currentTrack.duration * fraction;
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value;
    notifyListeners();
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _repeat = !_repeat;
    notifyListeners();
  }

  void toggleAutoPlay() {
    autoPlayRelated = !autoPlayRelated;
    notifyListeners();
  }

  void toggleGenre(String genre) {
    if (!selectedGenres.remove(genre)) {
      selectedGenres.add(genre);
    }
    notifyListeners();
  }

  void _advance() {
    if (!_playing || _queue.isEmpty) return;
    if (_position >= currentTrack.duration) {
      skip(1);
      return;
    }
    _position += const Duration(seconds: 1);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }
}
