import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import 'realmIOManager.dart';
import '../../../fileFetcher.dart';

class MusicInfoUpdater {
  final fileFetcher = FileFetcher();
  final musicInfoManager = RealmIOManager(MusicInfo.schema);

  void updateDataBase() {
    List pathList = _getPathFileFromFetcher();
    List nameList = _getNameFileFromFetcher();

    musicInfoManager.deleteAll;

    _addMusicInfo(pathList, nameList);
  }

  List _getPathFileFromFetcher() {
    return fileFetcher.pathList;
  }

  List _getNameFileFromFetcher() {
    return fileFetcher.nameList;
  }

  void _addMusicInfo(List pathListArg, List nameListArg) {
    for (var i = 0; i > pathListArg.length; i++) {
      MusicInfo addData = MusicInfo(
        ObjectId(), 
        nameListArg[i], 
        pathListArg[i], 
        0, 
        "", 
        ""
      );
      musicInfoManager.add<MusicInfo>(dataInsToAddArg: addData);
    }
  }
}
