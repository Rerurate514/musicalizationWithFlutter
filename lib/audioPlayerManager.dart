import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  AudioPlayerManager._();

  static AudioPlayerManager? _instance;

  factory AudioPlayerManager() {
    _instance ??= AudioPlayerManager._();
    return _instance!;
  }

  final _audioPlayer = AudioPlayer();

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

  Future<void> startMusic(String musicNameArg, String musicPathArg) async {
    _setMusicName(musicNameArg);
    _setMusicPath(musicPathArg);

    try {
      await _audioPlayer.play(DeviceFileSource(_musicPath));
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }

    _isPlaying = true;
  }

  void _setMusicPath(String musicPathArg) {
    _musicPath = musicPathArg;
  }

  void _setMusicName(String musicNameArg) {
    _musicName = musicNameArg;
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();

    _isPlaying = false;
  }

  void setPlayingMusicCurrentListener() {
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      double seconds = duration.inSeconds.toDouble();
      _musicCurrent = seconds;
    });
  }

  void setPlayingMusicDurationListener() {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _musicDuration = duration.inSeconds.toDouble();
    });
  }

  void toggleMusicLoop() {
    isLooping
        ? _audioPlayer.setReleaseMode(ReleaseMode.release)
        : _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void destroyAudioPlayer() {
    _audioPlayer.dispose();
  }
}
