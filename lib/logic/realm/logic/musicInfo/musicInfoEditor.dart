import 'package:musicalization/logic/realm/logic/realmIOManager.dart';
import 'package:musicalization/logic/realm/model/schema.dart';

enum MusicInfoColumn{
  ID,
  NAME,
  PATH,
  AUTO_VOLUME_SETTING,
  LYRICS_SETTING,
  PICTURE_SETTING
}

class MusicInfoEditor{
  final _realmIOManager = RealmIOManager(MusicInfo.schema);

  Future<void> edit({required MusicInfo newMusicInfoArg}) async {
    await _realmIOManager.edit<MusicInfo>(dataInsToAddArg: newMusicInfoArg);
  }
}