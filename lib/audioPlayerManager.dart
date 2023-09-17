import 'package:audioplayers/audioplayers.dart';

///audioPlayerの管理を行うクラス
class AudioPlayerManager {
  AudioPlayerManager._();

  static AudioPlayerManager? _instance;

  factory AudioPlayerManager() {
    _instance ??= AudioPlayerManager._();
    return _instance!;
  }
  
  final _audioPlayer = AudioPlayer();

  String _musicName = "";                       //曲の名前
  String get musicName => _musicName;

  double _musicDuration = 0.0;                  //曲の長さ
  double get musicDuration => _musicDuration;
  double _musicCurrent = 0.0;                   //曲の再生位置
  double get musicCurrent => _musicCurrent;

  String _musicPath = "";                       //曲のファイルパス
  String get musicPath => _musicPath;

  bool _isPlaying = false;                      //再生しているかどうか
  bool get isPlaying => _isPlaying;

  bool _isLooping = false;                      //ループしているかどうか
  bool get isLooping => _isLooping;

  int _modeIndex = 0;

  ///audioPlayerに曲をセットして、再生を開始する。
  Future<void> startMusic(String musicNameArg, String musicPathArg) async {
    _setMusicName(musicNameArg);
    _setMusicPath(musicPathArg);

    try {
      await _audioPlayer.play(DeviceFileSource(_musicPath));
    } catch (e, stackTrace) {
      print("${_musicPath} , $stackTrace");
      //throw Error.throwWithStackTrace(e, stackTrace);
    }

    _isPlaying = true;
  }

  ///曲のパスセット
  void _setMusicPath(String musicPathArg) {
    _musicPath = musicPathArg;
  }

  ///曲の名前のセット
  void _setMusicName(String musicNameArg) {
    _musicName = musicNameArg;
  }

  ///曲の一時停止、再生切り替え
  Future<void> togglePlayMusic() async {
    if(musicPath == "") return;

    if(isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
    else{
      await _audioPlayer.play(DeviceFileSource(_musicPath), position: Duration(seconds: _musicCurrent.toInt()));
      _isPlaying = true;
    }
  }

  ///audioPlayerの再生位置取得リスナーをセットする
  void setPlayingMusicCurrentListener() {
    _audioPlayer.onPositionChanged.listen((Duration duration) {
      double seconds = duration.inSeconds.toDouble();
      _musicCurrent = seconds;
    });
  }

  ///audioPlayerの曲の長さ取得リスナーをセットする
  void setPlayingMusicDurationListener() {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _musicDuration = duration.inSeconds.toDouble();
    });
  }

  ///曲の終了検知リスナーを登録する
  void setPlayerCompletionListener(){
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
    });
  }

  ///曲のループを切り替えする。
  void toggleMusicLoop() {
    if(_isLooping){
      _audioPlayer.setReleaseMode(ReleaseMode.release);
      _isLooping = false;
    }
    else{
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _isLooping = true;
    }
  }

  ///曲のループを切り替えする。
  void toggleMusicMode() {
    if(_modeIndex == 0){//何もなし
      //シャッフル再生 = false
    }
    else if(_modeIndex == 1){//ループ再生
      toggleMusicLoop();
    }
    else if(_modeIndex == 2){//シャッフル再生
      toggleMusicLoop();
      //シャッフル再生 = true
    }

    _modeIndex++;
    if(_modeIndex == 3) _modeIndex = 0;
  }

  ///再生位置の変更
  void seekMusic(double newCurrentArg){
    _musicCurrent = newCurrentArg;
    _audioPlayer.seek(
      Duration(seconds: newCurrentArg.toInt())
    );
  }

  ///audioPlayerの音量変更<br>
  ///@params volumeArg これは0 ~ 100の範囲です。
  void changeVolume(int volumeArg){
    if(volumeArg < 0 && volumeArg > 100) return;
    _audioPlayer.setVolume(volumeArg / 100);
  }

  ///audioPlayerインスタンスの解放
  void destroyAudioPlayer() {
    _audioPlayer.dispose();
  }
}
