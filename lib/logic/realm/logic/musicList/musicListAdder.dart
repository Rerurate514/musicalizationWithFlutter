import 'package:musicalization/logic/realm/logic/musicList/validatedMusicList.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicListAdder{
  final realmIOManager = RealmIOManager(MusicList.schema);

  void add(String nameArg, List<ObjectId> infoListArg){
    MusicList list = MusicList(ObjectId(), nameArg);
  
    ValidatedMusicList addData = ValidatedMusicList(list);
    realmIOManager.add<ValidatedMusicList>(dataInsToAddArg: addData);
  }
}