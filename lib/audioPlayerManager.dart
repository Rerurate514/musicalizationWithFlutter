import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  AudioPlayerManager._();

  static AudioPlayerManager? _instance;

  factory AudioPlayerManager(){
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

  Future<void> startMusic() async {
    try{
      await _audioPlayer.play(DeviceFileSource(_musicPath));
    }
    catch(e, stackTrace){
      throw Error.throwWithStackTrace(e, stackTrace);
    }

    _isPlaying = true;
  }

  void setMusicPath(String musicPathArg){
    _musicPath = musicPathArg;
  }

  void setMusicName(String musicNameArg){
    _musicName = musicNameArg;
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();

    _isPlaying = false;
  }

  
}
