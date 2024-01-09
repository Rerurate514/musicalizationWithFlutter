import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/logic/realmIOManager.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

class ListInfoAdder{
  final _realmIOManager = RealmIOManager(MusicList.schema);

  void add(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
    list.list.addAll(infoListArg);
  
    ValidatedMusicList addData = ValidatedMusicList(list);
    _realmIOManager.add<ValidatedMusicList>(dataInsToAddArg: addData);
  }
}