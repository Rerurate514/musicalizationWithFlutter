import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/logic/realmIOManager.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

enum MusicListColumn{
  ID,
  NAME,
  LIST
}

extension MusicListColumnExtension on MusicListColumn {
  Set set(MusicList list){
    switch(this){
      case MusicListColumn.ID: return { list.id };
      case MusicListColumn.NAME: return { list.name };
      case MusicListColumn.LIST: return { list.list };
    }
  }

  Type get type{
    switch(this){
      case MusicListColumn.ID: return int;
      case MusicListColumn.NAME: return String;
      case MusicListColumn.LIST: return List<ObjectId>;
    }
  }
}

class ListEditor{
  final _realmIOManager = RealmIOManager(MusicList.schema);
  
    void editList({required ObjectId idArg, required MusicListColumn columnArg, required List<ObjectId> newListArg}){
    MusicList list = _realmIOManager.searchById(idArg: idArg);
  
    _realmIOManager.edit(editArg: columnArg.set(list), editValueArg: newListArg);
  }
}