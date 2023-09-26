import 'package:realm/realm.dart';
import '../../model/schema.dart';
import '../realmInstanceFactory.dart';
import '../realmIOResults.dart';

import '../interface/realmReaderInterface.dart';
import '../interface/realmAdderInterface.dart';

class MusicInfoIO {
  final realmInsFac = RealmInstanceFactory();
  final _musicInfoReader = _MusicInfoReader();
  late Realm realm;

  MusicInfoIO() {
    realm = realmInsFac.createRealmIns(schemaObjectArg: MusicInfo.schema);
  }

  Future<void> add({required String nameArg, required String pathArg}) async {
    MusicInfo info = MusicInfo(ObjectId(), nameArg, pathArg, 40, "", "");

    realm.write(() => realm.add(info));
  }

  MusicInfo search({required ObjectId idArg}) {
    var result = _musicInfoReader.searchById(realm: realm, idArg: idArg);
    return result.payload;
  }

  void delete({required ObjectId idArg}) {
    var obj = search(idArg: idArg);
    realm.delete(obj);
  }

  void editVolumeColumn({required ObjectId idArg}) {}
  void editLyricsColumn({required ObjectId idArg}) {}
  void editPictureColumn({required ObjectId idArg}) {}

  void deleteAllRealmRecord() {
    realm.deleteAll();
  }
}

class _MusicInfoReader extends RealmReaderInterface {
  @override
  RealmIOResults searchById({required Realm realm, required ObjectId idArg}) {
    MusicInfo? infoResult = realm.find<MusicInfo>(idArg);

    //var infoResult = realm.query<MusicInfo>('name != \$0, ['']');

    late RealmIOResults<MusicInfo> ioResult;

    if (infoResult != null) {
      ioResult = RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
    } else {
      //todo ここには、指定されたファイルがDBに存在しない場合の処理
      ioResult = RealmIOResults(
          isSuccessArg: false,
          resultStringArg: "That record is no Exists.");
    }

    return ioResult;
  }

  @override
  RealmIOResults searchByName(
      {required Realm realm, required String nameArg}
  ) {
    //todo このメソッドの作成
    return RealmIOResults(isSuccessArg: true, payloadArg: "このメソッドはまだ作成していない");  
  }
}

class _MusicInfoAdder extends RealmAdderInterface{
  @override
  RealmIOResults add({required dynamic dataInsToAddArg}){
    //todo このメソッドの作成
    return RealmIOResults(isSuccessArg: true, payloadArg: "このメソッドはまだ作成していない");
  }
}

class _MusicInfoEditor{
  void editVolumeColumn({required ObjectId idArg}) {}

  void editLyricsColumn({required ObjectId idArg}) {}

  void editPictureColumn({required ObjectId idArg}) {}
}
