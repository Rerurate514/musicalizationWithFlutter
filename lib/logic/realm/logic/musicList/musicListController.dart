import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicListController{
  final _realmIOManager = RealmIOManager(MusicList.schema);

  void add(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
    list.list.addAll(infoListArg);
  
    ValidatedMusicList addData = ValidatedMusicList(list);
    _realmIOManager.add<ValidatedMusicList>(dataInsToAddArg: addData);
  }

  void editList(ObjectId idArg, String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(idArg, nameArg);
    list.list.addAll(infoListArg);
  
    ValidatedMusicList addData = ValidatedMusicList(list);
    _realmIOManager.edit<ValidatedMusicList, MusicList>(idArg: idArg ,dataInsToAddArg: addData);
  }

  void delete(ObjectId idArg){
    _realmIOManager.delete<MusicList>(idArg: idArg);
  }
}