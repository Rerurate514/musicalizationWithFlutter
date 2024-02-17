import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

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