import 'package:musicalization/logic/musicPlayer.dart';

class MusicSettingSyncer{
  final MusicPlayer _musicPlayer = MusicPlayer();

  void syncAllSetting(){
    _syncAutoVolumeSetting();
  }

  void _syncAutoVolumeSetting(){
    int autoVolumeValue = _musicPlayer.currentMusic.volume;

    _musicPlayer.changeVolume(autoVolumeValue);
  }
}