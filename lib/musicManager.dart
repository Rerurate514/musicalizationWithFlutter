import 'dart:html';

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  AudioPlayer _audioPlayer = AudioPlayer();

  String _musicName = "";
  String get musicName => _musicName;

  double _musicDuration = 0.0;
  double get musicDuration => _musicDuration;
  double _musicCurrent = 0.0;
  double get musicCurrent => _musicCurrent;

  String _musicPath = "";
  String get musicPath => _musicPath;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isLooping = false;
  bool get isLooping => _isLooping;

  Future<void> startMusic(String musicPathArg) async {
    setMusic(musicPathArg);
    await _audioPlayer.play(DeviceFileSource(_musicPath));

    _isPlaying = true;
  }

  void setMusic(String musicPathArg){
    _musicPath = musicPathArg;
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();

    _isPlaying = false;
  }

  
}
