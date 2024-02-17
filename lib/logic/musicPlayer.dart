import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'dart:math' as math;

import 'package:realm/realm.dart';

class MusicPlayer {
  final _player = _MusicPlayerManager();

  double get current => _player.current;
  double get duration => _player.duration;

  bool get isLooping => _player.isLooping;
  bool get isShuffling => _player.isShuffling;
  bool get isPlaying => _player.isPlaying;

  String get listName => _player.listName;
  MusicInfo get currentMusic => _player.currentMusic;

  MusicPlayer(
      [List<MusicInfo> listInMusicInfoArg = const [],
      int listInMusicInfoIndexArg = 0,
      String listNameArg = ""]
    ) {
    if (listInMusicInfoArg.isNotEmpty) {
      _player.set(listInMusicInfoArg, listInMusicInfoIndexArg, listNameArg);
    }
  }

  Future start() async => _player.start();
  Future togglePlaying() async => _player.togglePlaying();
  Future seek(double newCurrentArg) async => _player.seek(newCurrentArg);
  Future moveNextMusic() async => _player.moveNextMusic();
  Future moveBackMusic() async => _player.moveBackMusic();
  Future toggleMusicPlayMode() async => _player.toggleMusicPlayMode();
  Future changeVolume(int volumeArg) async => _player.changeVolume(volumeArg);
  void setOnMusicCompleteCallback(Function() onMusicCompleteCallbackArg) => _player.setOnMusicCompleteCallback(onMusicCompleteCallbackArg);
  void destroy() => _player.destroy();
}

class _MusicPlayerManager {
  final _audioPlayer = AudioPlayer();

  final _MusicPlayController _playController = _MusicPlayController();
  final _AudioPlayerIsPlayingListenerWatcher _isPlayingWatcher = _AudioPlayerIsPlayingListenerWatcher();
  final _MusicSeekController _seekController = _MusicSeekController();
  final _MusicVolumeChanger _volumeChanger = _MusicVolumeChanger();
  final _MusicPlayModeController _musicPlayModeController = _MusicPlayModeController();

  final _CurrentListenerResistry _currentListener = _CurrentListenerResistry();
  final _DurationListenerResistry _durationListener = _DurationListenerResistry();
  final _PlayerCompletionListenerResistry _playerCompletionListener = _PlayerCompletionListenerResistry();

  late _TrackManager _trackManager = _TrackManager([MusicInfo(ObjectId(), "null", "", 0, "", "")], 0, () async {});

  final listStartIndex = 0;

  double get current => _currentListener.currentSeconds;
  double get duration => _durationListener.durationSeconds;

  bool get isLooping => _musicPlayModeController.isLooping;
  bool get isShuffling => _musicPlayModeController.isShuffling;
  bool get isPlaying => _playController.isPlaying;

  String get listName => _trackManager.listName;
  MusicInfo get currentMusic => _trackManager.currentMusic;

  Function() _onMusicCompleteCallback = () => null;

  _MusicPlayerManager._(){
    _playController.setWatcher(_isPlayingWatcher);
    _musicPlayModeController.resetMusicPlayMode();
    _playController.setPlayingChangedListener();
    _currentListener.setPlayingMusicCurrentListener(_audioPlayer);
    _durationListener.setPlayingMusicDurationListener(_audioPlayer);
  }

  static _MusicPlayerManager? _instance;

  factory _MusicPlayerManager() {
    _instance ??= _MusicPlayerManager._();
    return _instance!;
  }

  Future set(List<MusicInfo> listInMusicInfoArg, int listInMusicInfoIndexArg, [String listNameArg = ""]) async {
    _trackManager = _TrackManager(listInMusicInfoArg, listInMusicInfoIndexArg, start, listNameArg);
  }

  void checkTrackManagerInit() {
    if (_trackManager == null) {
      throw Exception("_trackManager is not initialized in _MusicPlayerManager class.");
    }
  }

  Future start() async {
    checkTrackManagerInit();
    await _playController.start(_audioPlayer, currentMusic.path);
  }

  Future togglePlaying() async {
    await _playController.togglePlaying(_audioPlayer);
  }

  Future seek(double newCurrentArg) async {
    await _seekController.seekMusic(_audioPlayer, newCurrentArg);
  }

  Future moveNextMusic() async {
    checkTrackManagerInit();
    _trackManager.moveNextMusic();
  }

  Future moveBackMusic() async {
    checkTrackManagerInit();
    _trackManager.moveBackMusic();
  }

  void setOnMusicCompleteCallback(Function() onMusicCompleteCallbackArg) {
    _onMusicCompleteCallback = onMusicCompleteCallbackArg;
    _playerCompletionListener.setPlayerCompletionListener(_audioPlayer, isLooping, _onMusicCompleteCallback, _isPlayingWatcher);
  }

  Future toggleMusicPlayMode() async {
    _musicPlayModeController.toggleMusicPlayMode(_audioPlayer);
    Function() callback = () => null;

    if (!isLooping) {
      callback = _trackManager.switchModeCallback(isShuffling);
    } else {
      callback = _onMusicCompleteCallback;
    }

    _playerCompletionListener.setPlayerCompletionListener(_audioPlayer, isLooping, callback, _isPlayingWatcher);
  }

  Future changeVolume(int volumeArg) async {
    _volumeChanger.changeVolume(_audioPlayer, volumeArg);
  }

  void destroy() {
    _audioPlayer.dispose();
  }
}

class _MusicPlayController {
  late final _AudioPlayerIsPlayingListenerWatcher _watcher;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  _MusicPlayController();

  void setWatcher(_AudioPlayerIsPlayingListenerWatcher watcherArg){
    _watcher = watcherArg;
  }

  Future start(AudioPlayer audioPlayerArg, String musicPathArg) async {
    try {
      _watcher.setPlaying(true);
      await audioPlayerArg.play(DeviceFileSource(musicPathArg));
    } catch (e, stackTrace) {
      throw Exception("Failed to $e, Invalid musicPath = $musicPathArg, stackTrace = $stackTrace");
    }
  }

  Future togglePlaying(AudioPlayer audioPlayerArg) async {
    _watcher.isPlaying ? _pause(audioPlayerArg) : _resume(audioPlayerArg);
  }

  Future _pause(AudioPlayer audioPlayerArg) async {
    _watcher.setPlaying(false);
    await audioPlayerArg.pause();
  }

  Future _resume(AudioPlayer audioPlayerArg) async {
    _watcher.setPlaying(true);
    await audioPlayerArg.resume();
  }

  void setPlayingChangedListener() {
    _watcher.stream.listen((isPlayingArg) {
      _isPlaying = isPlayingArg;
    });
  }
}

class _AudioPlayerIsPlayingListenerWatcher {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Stream<bool> get stream => _controller.stream;

  void setPlaying(bool isPlayingArg) {
    _isPlaying = isPlayingArg;
    _controller.add(_isPlaying);
  }

  void dispose() => _controller.close();
}

class _TrackManager {
  late final List<MusicInfo> _listInMusicInfo;
  int _listInMusicInfoIndex = 0;
  get currentMusic => _listInMusicInfo[_listInMusicInfoIndex];

  String _listName = "";
  String get listName => _listName;

  final listStartIndex = 0;

  late final Future Function() _changeMusic;

  _TrackManager(List<MusicInfo> listInMusicInfoArg, int listInMusicInfoIndexArg, Future Function() changeMusicArg, [String listNameArg = ""]) {
    _listInMusicInfo = listInMusicInfoArg;
    _listInMusicInfoIndex = listInMusicInfoIndexArg;
    _changeMusic = changeMusicArg;
    _listName = listNameArg;
  }

  void moveNextMusic() {
    _listInMusicInfoIndex = (_listInMusicInfoIndex + 1) % _listInMusicInfo.length;
    _changeMusic();
  }

  void moveBackMusic() {
    _listInMusicInfoIndex--;
    if (listStartIndex > _listInMusicInfoIndex) {
      _listInMusicInfoIndex = _listInMusicInfo.length - 1;
    }
    _changeMusic();
  }

  void moveRamdomMusic() {
    var random = math.Random();

    _listInMusicInfoIndex = random.nextInt(_listInMusicInfo.length);
    _changeMusic();
  }

  Function() switchModeCallback(bool isShufflingArg) {
    return (() => isShufflingArg ? moveRamdomMusic() : moveNextMusic());
  }
}

class _MusicPlayModeController {
  bool _isLooping = false;
  bool get isLooping => _isLooping;

  bool _isShuffling = false;
  bool get isShuffling => _isShuffling;

  int _musicModeIndex = 0;

  void resetMusicPlayMode() {
    _musicModeIndex = 0;
  }

  void toggleMusicPlayMode(AudioPlayer audioPlayerArg) {
    switch (_musicModeIndex) {
      case 0:
        _toggleLoop(audioPlayerArg);
        break;
      case 1:
        _toggleLoop(audioPlayerArg); 
        _isShuffling = true;
        break;
      case 2:
        _isShuffling = false;
        break;
    }
    _musicModeIndex = (_musicModeIndex + 1) % 3;
  }

  void _toggleLoop(AudioPlayer audioPlayerArg) {
    _isLooping
        ? audioPlayerArg.setReleaseMode(ReleaseMode.release)
        : audioPlayerArg.setReleaseMode(ReleaseMode.loop);

    _isLooping = !_isLooping;
  }
}

class _MusicSeekController {
  Future seekMusic(AudioPlayer audioPlayerArg, double newCurrentArg) async {
    audioPlayerArg.seek(Duration(seconds: newCurrentArg.toInt()));
  }
}

class _MusicVolumeChanger {
  void changeVolume(AudioPlayer audioPlayerArg, int volumeArg) {
    if (volumeArg < 0 && volumeArg > 100) return;
    audioPlayerArg.setVolume(volumeArg / 100);
  }
}

class _CurrentListenerResistry {
  double _currentSeconds = 0.0;
  double get currentSeconds => _currentSeconds;

  void setPlayingMusicCurrentListener(AudioPlayer audioPlayerArg) {
    audioPlayerArg.onPositionChanged.listen((Duration duration) {
      _currentSeconds = duration.inSeconds.toDouble();
    });
  }
}

class _DurationListenerResistry {
  double _durationSeconds = 0.0;
  double get durationSeconds => _durationSeconds;

  void setPlayingMusicDurationListener(AudioPlayer audioPlayerArg) {
    audioPlayerArg.onDurationChanged.listen((Duration duration) {
      _durationSeconds = duration.inSeconds.toDouble();
    });
  }
}

class _PlayerCompletionListenerResistry {
  void setPlayerCompletionListener(
    AudioPlayer audioPlayerArg,
    bool isLoopingArg,
    Function() musicCompletionCallbackArg,
    _AudioPlayerIsPlayingListenerWatcher watcherArg
  ) {
    audioPlayerArg.onPlayerComplete.listen((event) {
      if (!isLoopingArg) {
        Function() musicCompletionCallback = musicCompletionCallbackArg;
        watcherArg.setPlaying(false);
        musicCompletionCallback();
      }
    });
  }
}