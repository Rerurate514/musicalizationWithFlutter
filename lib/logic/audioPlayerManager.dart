import 'package:audioplayers/audioplayers.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

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
  get musicName => _data.musicInfo.name;

  int _musicModeIndex = 0;

  List<MusicInfo> _listInMusicInfo = [MusicInfo(ObjectId(), "", "", 40, "", "")];
  int _listInMusicInfoIndex = 0;

  ///dataクラスにList<MusicInfo>のトラックをセットする
  Future setMusicList(List<MusicInfo> infoListArg, int musicListIndexArg) async {
    _listInMusicInfo = infoListArg;
    _listInMusicInfoIndex = musicListIndexArg;
  }

  ///現在の音楽トラックを次のトラックに移動するためのメソッド。
  void moveNextMusic(){
    _listInMusicInfoIndex++;
    if(_listInMusicInfo.length < _listInMusicInfoIndex) _listInMusicInfoIndex = 0;
    startMusic();
  }

  ///現在の音楽トラックを前のトラックに移動するためのメソッド。
  void moveBackMusic(){
    _listInMusicInfoIndex--;
    if(0 > _listInMusicInfoIndex) _listInMusicInfoIndex = _listInMusicInfo.length;
    startMusic();
  }

  ///audioPlayerに曲をセットして、再生を開始する。
  Future<void> startMusic() async {
    _data = await _player.startMusic(_audioPlayer, _data, _listInMusicInfo[_listInMusicInfoIndex]);
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
        _audioPlayer, _data, moveNextMusic);
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
      MusicInfo infoArg) async {
    dataArg.musicInfo = infoArg;
    dataArg.isPlaying = true;

    try {
      await audioPlayerArg.play(DeviceFileSource(dataArg.musicInfo.path));
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
      AudioPlayer audioPlayerArg, _AudioPlayerMusicData dataArg, Function() musicCompletionCallbackArg
  ) {
    audioPlayerArg.onPlayerComplete.listen((event) {
      if(!dataArg.isLooping){
        print("fn = $musicCompletionCallbackArg");
        Function() musicCompletionCallback = musicCompletionCallbackArg;
        musicCompletionCallback();
      }
    });

    return dataArg;
  }
}

class _AudioPlayerMusicData {
  MusicInfo musicInfo = MusicInfo(ObjectId(), "", "", 40, "", ""); //曲の情報

  double musicDuration = 0.0; //曲の長さ
  double musicCurrent = 0.0; //曲の再生位置
  
  bool isPlaying = false; //再生しているかどうか
  bool isLooping = false; //ループしているかどうか
}