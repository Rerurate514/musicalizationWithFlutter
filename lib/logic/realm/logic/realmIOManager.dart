import 'package:musicalization/logic/realm/logic/interface/realmValidatedSchemaValueInterface.dart';
import 'package:realm/realm.dart';
import 'realmInstanceFactory.dart';
import 'realmIOResults.dart';

import 'interface/realmReaderInterface.dart';
import 'interface/realmAdderInterface.dart';

import 'interface/realmIOManagerInterface.dart';

class RealmIOManager extends RealmIOManagerInterface{
  final realmInsFac = RealmInstanceFactory();
  final _reader = _DataReader();
  final _adder = _DataAdder();
  late Realm realm;

  RealmIOManager(SchemaObject schemaObjectArg) {
    realm = realmInsFac.createRealmIns(schemaObjectArg: schemaObjectArg);
  }

  @override
  void add<T extends RealmValidatedSchemaValueInterface>({required RealmValidatedSchemaValueInterface dataInsToAddArg}){
    _adder.add<T>(realm: realm, dataInsToAddArg: dataInsToAddArg);
  }

  @override
  SCHEMA readAll<SCHEMA extends RealmObject>() {
    RealmIOResults results = _reader.readAll(realm: realm);
    return results.payload;
  }

  @override
  SCHEMA searchById<SCHEMA extends RealmObject>({required ObjectId idArg}){
    var result = _reader.searchById<SCHEMA>(realm: realm, idArg: idArg);
    return result.payload;
  }

  @override
  SCHEMA searchByName<SCHEMA extends RealmObject>({required ObjectId idArg}){
    var result = _reader.searchById<SCHEMA>(realm: realm, idArg: idArg);
    return result.payload;
  }

  @override
  void delete({required ObjectId idArg}){
    var obj = searchById(idArg: idArg);
    realm.delete(obj);
  }

  @override
  void deleteAll({required Realm realm}){
    realm.deleteAll();
  }
}

class _DataReader extends RealmReaderInterface {
  @override
  RealmIOResults searchById<SCHEMA extends RealmObject>({required Realm realm, required ObjectId idArg}) {
    var infoResult = realm.find<SCHEMA>(idArg);

    late RealmIOResults<SCHEMA> ioResult;

    if (infoResult != null) {
      ioResult = RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
    } else {
      ioResult = RealmIOResults(
          isSuccessArg: false,
          resultStringArg: "That record is no Exists.");
    }

    return ioResult;
  }

  @override
  RealmIOResults searchByName<SCHEMA extends RealmObject>(
      {required Realm realm, required String nameArg}
  ) {
    // var infoResult = realm.query<MusicInfo>('name == $nameArg');

    // late RealmIOResults<MusicInfo> ioResult;

    // if (infoResult != null) {
    //   ioResult = RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
    // } else {
    //   ioResult = RealmIOResults(
    //       isSuccessArg: false,
    //       resultStringArg: "That record is no Exists.");
    // }
    // //todo このメソッドの作成
    return RealmIOResults(isSuccessArg: true, payloadArg: "このメソッドはまだ作成していない");  
  }

  @override
  RealmIOResults readAll<SCHEMA extends RealmObject>({required Realm realm}){
    var infoResult = realm.all().toList();

    return RealmIOResults(isSuccessArg: true, payloadArg: infoResult);  
  }
}

class _DataAdder extends RealmAdderInterface{
  @override
  RealmIOResults add<T extends RealmValidatedSchemaValueInterface>({required Realm realm, required RealmValidatedSchemaValueInterface dataInsToAddArg}){
    realm.write(() => realm.add(dataInsToAddArg.payload));
    return RealmIOResults(isSuccessArg: true);
  }
}

class _MusicInfoEditor{
  void editVolumeColumn({required ObjectId idArg}) {}

  void editLyricsColumn({required ObjectId idArg}) {}

  void editPictureColumn({required ObjectId idArg}) {}
}
