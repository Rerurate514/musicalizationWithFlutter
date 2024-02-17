import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/logic/realmIOManager.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

enum MusicListColumn{
  ID,
  NAME,
  LIST
}
class ListEditor{
  final _realmIOManager = RealmIOManager(MusicList.schema);

  void edit(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
    list.list.addAll(infoListArg);
  
    ValidatedMusicList editData = ValidatedMusicList(list);
    _realmIOManager.edit<ValidatedMusicList>(dataInsToAddArg: editData);
  }
}