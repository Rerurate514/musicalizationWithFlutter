import 'package:musicalization/logic/realm/logic/musicInfo/validatedMusicInfo.dart';
import 'package:musicalization/logic/realm/logic/realmIOManager.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

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

  void edit<COLUMN_TYPE>({required MusicInfo newMusicInfoArg}) {
    ValidatedMusicInfo editData = ValidatedMusicInfo(newMusicInfoArg);
    _realmIOManager.edit<ValidatedMusicInfo>(dataInsToAddArg: editData);
  }
}