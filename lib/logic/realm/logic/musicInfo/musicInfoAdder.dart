import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicInfoAdder {
  final realmIOManager = RealmIOManager(MusicInfo.schema);

  void add(String pathArg, String nameArg) {
    MusicInfo info = MusicInfo(ObjectId(), nameArg, pathArg, 40, "", "");
    realmIOManager.add<MusicInfo>(dataInsToAddArg: info);
  }
}