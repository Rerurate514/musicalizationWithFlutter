import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';

class MusicSettingSyncer{
  final MusicPlayer _musicPlayer = MusicPlayer();

  void syncAllSetting(){
    _syncAutoVolumeSetting();
  }

  void _syncAutoVolumeSetting(){

  }


}

class _MusicDataFetcher{
  final RecordFetcher _fetcher = RecordFetcher(MusicInfo.schema);

  
}