import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/interface/realmValidatedSchemaValueInterface.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import 'realmInstanceFactory.dart';
import 'realmIOResults.dart';

class RealmIOManager {
  final realmInsFac = RealmInstanceFactory();
  final _reader = _DataReader();
  final _adder = _DataAdder();
  final _editor = _DataEditor();
  late final Realm realm;

  RealmIOManager(SchemaObject schemaObjectArg) {
    realm = realmInsFac.createRealmIns(schemaObjectArg: schemaObjectArg);
  }

  Future<void> add<T extends RealmValidatedSchemaValueInterface>({required T dataInsToAddArg}) async {
    _adder.add<T>(realm: realm, dataInsToAddArg: dataInsToAddArg);
  }

  List<SCHEMA> readAll<SCHEMA extends RealmObject>() {
    RealmIOResults results = _reader.readAll<SCHEMA>(realm: realm);
    return results.payload;
  }

  SCHEMA searchById<SCHEMA extends RealmObject>({required ObjectId idArg}) {
    var result = _reader.searchById<SCHEMA>(realm: realm, idArg: idArg);
    return result.payload;
  }

  Future<void> edit<T extends RealmValidatedSchemaValueInterface>({required T dataInsToAddArg}) async {
    _editor.edit<T>(realm: realm, dataInsToAddArg: dataInsToAddArg);
  }

  void delete<SCHEMA extends RealmObject>({required ObjectId idArg}) {
    var obj = searchById<SCHEMA>(idArg: idArg);
    realm.write(() => realm.delete<SCHEMA>(obj));
  }

  void deleteAll<SCHEMA extends RealmObject>() {
    realm.write(() => realm.deleteAll<SCHEMA>());
  }
}

class _DataReader {
  RealmIOResults searchById<SCHEMA extends RealmObject>({required Realm realm, required ObjectId idArg}) {
    var infoResult = realm.find<SCHEMA>(idArg);

    late RealmIOResults<SCHEMA> ioResult;

    if (infoResult != null) {
      ioResult = RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
    } else {
      ioResult = RealmIOResults(
        isSuccessArg: false, 
        resultStringArg: "That record is no Exists."
      );
    }

    return ioResult;
  }

  RealmIOResults readAll<SCHEMA extends RealmObject>({required Realm realm}) {
    var infoResult = realm.all<SCHEMA>().toList();

    return RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
  }
}

class _DataAdder {
  Future<RealmIOResults> add<T extends RealmValidatedSchemaValueInterface>({required Realm realm, required T dataInsToAddArg}) async {
    realm.write(() => realm.add(dataInsToAddArg.payload));
    return RealmIOResults(isSuccessArg: true);
  }
}

class _DataEditor {
  Future<RealmIOResults> edit<T extends RealmValidatedSchemaValueInterface>({required Realm realm, required T dataInsToAddArg}) async {
    realm.write(() => realm.add(dataInsToAddArg.payload, update: true));
    return RealmIOResults(isSuccessArg: true);
  }
} 