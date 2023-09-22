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
  final _player = _MusicPlayer();
  final _audioPlayerListenerResistry = _AudioPlayerListenerResistry();

  _AudioPlayerMusicData _data = _AudioPlayerMusicData();

  get musicDuration => _data.musicDuration;
  get musicCurrent => _data.musicCurrent;
  get musicName => _data.musicName;

  int _musicModeIndex = 0;

  ///audioPlayerに曲をセットして、再生を開始する。
  Future<void> startMusic(String musicNameArg, String musicPathArg) async {
    _data = await _player.startMusic(_audioPlayer, _data, musicNameArg, musicPathArg);
  }

  ///曲の一時停止、再生切り替え
  Future<void> togglePlayMusic() async {
    _data.isPlaying
        ? _data = await _player.pauseMusic(_audioPlayer, _data)
        : _data = await _player.resumeMusic(_audioPlayer, _data);
  }

  ///曲のmodeを切り替えする。<br>
  ///none => loopPlay => shufflePlay
  void toggleMusicMode() {
    switch (_musicModeIndex) {
      case 0:
        // シャッフル再生 = false の設定を追加する
        // 何もなし
        break;
      case 1:
        toggleMusicLoop();
        break;
      case 2:
        toggleMusicLoop();
        // シャッフル再生 = true の設定を追加する
        break;
    }

    _musicModeIndex = (_musicModeIndex + 1) % 3;
  }

  ///曲のループを切り替えする。
  void toggleMusicLoop() {
    _player.toggleMusicLoop(_audioPlayer, _data);
  }

  ///再生位置の変更
  void seekMusic(double newCurrentArg) {
    _player.seekMusic(_audioPlayer, _data, newCurrentArg);
  }

  ///audioPlayerの音量変更<br>
  ///@params volumeArg これは0 ~ 100の範囲です。
  void changeVolume(int volumeArg) {
    _player.changeVolume(_audioPlayer, volumeArg);
  }

  ///audioPlayerの再生位置取得リスナーをセットする
  void setPlayingMusicCurrentListener() {
    _audioPlayerListenerResistry.setPlayingMusicCurrentListener(
        _audioPlayer, _data);
  }

  ///audioPlayerの曲の長さ取得リスナーをセットする
  void setPlayingMusicDurationListener() {
    _audioPlayerListenerResistry.setPlayingMusicDurationListener(
        _audioPlayer, _data);
  }

  ///曲の終了検知リスナーを登録する
  void setPlayerCompletionListener() {
    _audioPlayerListenerResistry.setPlayerCompletionListener(
        _audioPlayer, _data);
  }

  ///audioPlayerインスタンスの解放
  void destroyAudioPlayer() {
    _audioPlayer.dispose();
  }
}

class _MusicPlayer {
  ///audioPlayerに曲をセットして、再生を開始する。
  Future<_AudioPlayerMusicData> startMusic(
      AudioPlayer audioPlayerArg,
      _AudioPlayerMusicData dataArg,
      String musicNameArg,
      String musicPathArg) async {
    dataArg.musicName = musicNameArg; //曲の名前のセット
    dataArg.musicPath = musicPathArg; //曲のパスセット
    dataArg.isPlaying = true;

    try {
      await audioPlayerArg.play(DeviceFileSource(dataArg.musicPath));
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }

    return dataArg;
  }

  ///曲の一時停止
  Future<_AudioPlayerMusicData> pauseMusic(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg) async {
    await audioPlayerArg.pause();
    dataArg.isPlaying = false;

    return dataArg;
  }

  ///曲の再開
  Future<_AudioPlayerMusicData> resumeMusic(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg
  ) async {
    await audioPlayerArg.resume();
    dataArg.isPlaying = true;

    return dataArg;
  }

  ///曲のループを切り替えする。
  _AudioPlayerMusicData toggleMusicLoop(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg
  ) {
    if (dataArg.isLooping) {
      audioPlayerArg.setReleaseMode(ReleaseMode.release);
      dataArg.isLooping = false;
    } else {
      audioPlayerArg.setReleaseMode(ReleaseMode.loop);
      dataArg.isLooping = true;
    }

    return dataArg;
  }

  ///再生位置の変更
  _AudioPlayerMusicData seekMusic(AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg,
      double newCurrentArg) {
    dataArg.musicCurrent = newCurrentArg;
    audioPlayerArg.seek(Duration(seconds: newCurrentArg.toInt()));

    return dataArg;
  }

  ///audioPlayerの音量変更<br>
  ///@params volumeArg これは0 ~ 100の範囲です。
  void changeVolume(AudioPlayer audioPlayerArg, int volumeArg) {
    if (volumeArg < 0 && volumeArg > 100) return;
    audioPlayerArg.setVolume(volumeArg / 100);
  }
}

class _AudioPlayerListenerResistry {
  ///audioPlayerの再生位置取得リスナーをセットする
  _AudioPlayerMusicData setPlayingMusicCurrentListener(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg
  ) {
    audioPlayerArg.onPositionChanged.listen((Duration duration) {
      double seconds = duration.inSeconds.toDouble();
      dataArg.musicCurrent = seconds;
    });

    return dataArg;
  }

  ///audioPlayerの曲の長さ取得リスナーをセットする
  _AudioPlayerMusicData setPlayingMusicDurationListener(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg
  ) {
    audioPlayerArg.onDurationChanged.listen((Duration duration) {
      dataArg.musicDuration = duration.inSeconds.toDouble();
    });

    return dataArg;
  }

  ///曲の終了検知リスナーを登録する
  _AudioPlayerMusicData setPlayerCompletionListener(
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg
  ) {
    audioPlayerArg.onPlayerComplete.listen((event) {
      dataArg.isPlaying = false;
    });

    return dataArg;
  }
}

class _AudioPlayerMusicData {
  String _musicName = ""; //曲の名前
  String get musicName => _musicName;
  set musicName(String musicNameArg) {
    _musicName = musicNameArg;
  }

  double _musicDuration = 0.0; //曲の長さ
  double get musicDuration => _musicDuration;
  set musicDuration(double musicDurationArg) {
    _musicDuration = musicDurationArg;
  }

  double _musicCurrent = 0.0; //曲の再生位置
  double get musicCurrent => _musicCurrent;
  set musicCurrent(double musicCurrentArg) {
    _musicCurrent = musicCurrentArg;
  }

  String _musicPath = ""; //曲のファイルパス
  String get musicPath => _musicPath;
  set musicPath(String musicPathArg) {
    _musicPath = musicPathArg;
  }

  bool _isPlaying = false; //再生しているかどうか
  bool get isPlaying => _isPlaying;
  set isPlaying(bool isPlayingArg) {
    _isPlaying = isPlayingArg;
  }

  bool _isLooping = false; //ループしているかどうか
  bool get isLooping => _isLooping;
  set isLooping(bool isLoopingArg) {
    _isLooping = isLoopingArg;
  }
}
