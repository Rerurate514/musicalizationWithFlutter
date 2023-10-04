import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../realmIOManager.dart';
import '../../../fileFetcher.dart';

import '../musicInfo/validatedMusicInfo.dart';

class MusicInfoUpdater {
  final fileFetcher = FileFetcher();
  final realmIOManager = RealmIOManager(MusicInfo.schema);

  Future updateDataBase() async {
    List pathList = _getPathFileFromFetcher();
    List nameList = _getNameFileFromFetcher();
    
    realmIOManager.deleteAll<MusicInfo>();

    await _addMusicInfo(pathList, nameList);
  }

  List _getPathFileFromFetcher() {
    return fileFetcher.pathList;
  }

  List _getNameFileFromFetcher() {
    return fileFetcher.nameList;
  }

  Future _addMusicInfo(List pathListArg, List nameListArg) async {
    for (var i = 0; i < pathListArg.length; i++) {
      ValidatedMusicInfo addData = ValidatedMusicInfo(
        ObjectId(), 
        nameListArg[i],
        pathListArg[i],
        0, 
        "", 
        ""
      );
      realmIOManager.add<ValidatedMusicInfo>(
        dataInsToAddArg: addData
      );
    }
  }
}
