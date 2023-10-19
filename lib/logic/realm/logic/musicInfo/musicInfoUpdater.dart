import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoAdder.dart';
import 'package:musicalization/logic/realm/model/schema.dart';

import '../realmIOManager.dart';
import '../../../fileFetcher.dart';

class MusicInfoUpdater {
  final fileFetcher = FileFetcher();
  final realmIOManager = RealmIOManager(MusicInfo.schema);
  final musicInfoAdder = MusicInfoAdder();

  void updateDataBase() {
    List pathList = _getPathFileFromFetcher();
    List nameList = _getNameFileFromFetcher();
    
    realmIOManager.deleteAll<MusicInfo>();

    _addMusicInfo(pathList, nameList);
  }

  List _getPathFileFromFetcher() {
    return fileFetcher.pathList;
  }

  List _getNameFileFromFetcher() {
    return fileFetcher.nameList;
  }

  void _addMusicInfo(List pathListArg, List nameListArg){
    for (var i = 0; i < pathListArg.length; i++) {
      musicInfoAdder.add(pathListArg[i], nameListArg[i]);
    }   
  }
}

