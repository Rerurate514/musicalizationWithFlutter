import 'musicInfoManager.dart';
import '../../../fileFetcher.dart';

class MusicInfoUpdater {
  final fileFetcher = FileFetcher();
  final musicInfoManager = MusicInfoManager();

  void updateDataBase() {
    List pathList = _getPathFileFromFetcher();
    List nameList = _getNameFileFromFetcher();

    musicInfoManager.deleteAllRealmRecord();

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
      musicInfoManager.add(
        nameArg: nameListArg[i],
        pathArg: pathListArg[i]
      );
    }
  }
}
