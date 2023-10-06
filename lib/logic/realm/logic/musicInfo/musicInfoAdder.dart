import 'package:musicalization/logic/realm/model/schema.dart';

import 'validatedMusicInfo.dart';

import 'package:realm/realm.dart';
import '../realmIOManager.dart';

class MusicInfoAdder {
  final realmIOManager = RealmIOManager(MusicInfo.schema);

  void add(String pathArg, String nameArg) {
    ValidatedMusicInfo addData = ValidatedMusicInfo(
        ObjectId(), nameArg, pathArg, 0, "", "");
    realmIOManager.add<ValidatedMusicInfo>(dataInsToAddArg: addData);
  }
}
