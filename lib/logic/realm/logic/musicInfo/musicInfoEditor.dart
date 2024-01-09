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
  Set<COLUMN_TYPE> set<COLUMN_TYPE>(MusicInfo info){
    switch(this){
      case MusicInfoColumn.ID: return { info.id } as Set<COLUMN_TYPE>;
      case MusicInfoColumn.NAME: return { info.name } as Set<COLUMN_TYPE>;
      case MusicInfoColumn.PATH: return { info.path } as Set<COLUMN_TYPE>;
      case MusicInfoColumn.AUTO_VOLUME_SETTING: return { info.volume } as Set<COLUMN_TYPE>;
      case MusicInfoColumn.LYRICS_SETTING: return { info.lyrics } as Set<COLUMN_TYPE>;
      case MusicInfoColumn.PICTURE_SETTING: return { info.picture } as Set<COLUMN_TYPE>;
    }
  }
}

class MusicInfoEditor{
  final _realmIOManager = RealmIOManager(MusicInfo.schema);

  void edit<COLUMN_TYPE>({required ObjectId idArg, required MusicInfoColumn columnArg, required COLUMN_TYPE newValueArg}) {
    final info = _realmIOManager.searchById<MusicInfo>(idArg: idArg);
    
    _realmIOManager.edit<COLUMN_TYPE>(editArg: columnArg.set<COLUMN_TYPE>(info), editValueArg: newValueArg);
  }
}