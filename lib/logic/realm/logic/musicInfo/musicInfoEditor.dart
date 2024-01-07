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

extension MusicInfoColumnExtension on MusicInfoColumn {
  Set set(MusicInfo info){
    switch(this){
      case MusicInfoColumn.ID: return { info.id };
      case MusicInfoColumn.NAME: return { info.name };
      case MusicInfoColumn.PATH: return { info.path };
      case MusicInfoColumn.AUTO_VOLUME_SETTING: return { info.volume };
      case MusicInfoColumn.LYRICS_SETTING: return { info.lyrics };
      case MusicInfoColumn.PICTURE_SETTING: return { info.picture };
    }
  }

  Type get type{
    switch(this){
      case MusicInfoColumn.ID: return int;
      case MusicInfoColumn.NAME: return String;
      case MusicInfoColumn.PATH: return String;
      case MusicInfoColumn.AUTO_VOLUME_SETTING: return int;
      case MusicInfoColumn.LYRICS_SETTING: return String;
      case MusicInfoColumn.PICTURE_SETTING: return String;
    }
  }
}

class MusicInfoEditor{
  final realmIOManager = RealmIOManager(MusicInfo.schema);

  void edit({required ObjectId idArg, required MusicInfoColumn columnArg, required dynamic newValueArg}) {
    final info = realmIOManager.searchById<MusicInfo>(idArg: idArg);
    final columnType = columnArg.type;

    realmIOManager.edit<columnType>(editArg: columnArg.set(info), editValueArg: newValueArg);
  }
}