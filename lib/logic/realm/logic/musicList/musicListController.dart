import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicListController{
  final _realmIOManager = RealmIOManager(MusicList.schema);

  void add(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
    list.list.addAll(infoListArg);
  
    _realmIOManager.add<MusicList>(dataInsToAddArg: list);
  }

  void editList(ObjectId idArg, String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(idArg, nameArg);
    list.list.addAll(infoListArg);
  
    //_realmIOManager.edit<MusicList, MusicList>(idArg: idArg ,dataInsToAddArg: addData);
  }

  void delete(ObjectId idArg){
    _realmIOManager.delete<MusicList>(idArg: idArg);
  }
}