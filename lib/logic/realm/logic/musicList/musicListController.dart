import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicListController{
  final realmIOManager = RealmIOManager(MusicList.schema);

  void add(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
    list.list.addAll(infoListArg);
  
    ValidatedMusicList addData = ValidatedMusicList(list);
    realmIOManager.add<ValidatedMusicList>(dataInsToAddArg: addData);
  }

  void delete(ObjectId idArg){
    realmIOManager.delete(idArg: idArg);
  }
}