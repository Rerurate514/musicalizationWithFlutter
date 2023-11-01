import 'package:musicalization/logic/realm/logic/interface/realmValidatedSchemaValueInterface.dart';
import 'package:realm/realm.dart';
import 'realmInstanceFactory.dart';
import 'realmIOResults.dart';

import 'interface/realmReaderInterface.dart';
import 'interface/realmAdderInterface.dart';

import 'interface/realmIOManagerInterface.dart';

class RealmIOManager extends RealmIOManagerInterface {
  final realmInsFac = RealmInstanceFactory();
  final _reader = _DataReader();
  final _adder = _DataAdder();
  late final Realm realm;

  RealmIOManager(SchemaObject schemaObjectArg) {
    realm = realmInsFac.createRealmIns(schemaObjectArg: schemaObjectArg);
  }

  @override
  Future<void> add<T extends RealmValidatedSchemaValueInterface>(
      {required RealmValidatedSchemaValueInterface dataInsToAddArg}) async {
    _adder.add<T>(realm: realm, dataInsToAddArg: dataInsToAddArg);
  }

  @override
  List<SCHEMA> readAll<SCHEMA extends RealmObject>() {
    RealmIOResults results = _reader.readAll<SCHEMA>(realm: realm);
    return results.payload;
  }

  @override
  SCHEMA searchById<SCHEMA extends RealmObject>({required ObjectId idArg}) {
    var result = _reader.searchById<SCHEMA>(realm: realm, idArg: idArg);
    return result.payload;
  }

  @override
  Future<void> edit<T extends RealmValidatedSchemaValueInterface,
          SCHEMA extends RealmObject>(
      {required ObjectId idArg, required T dataInsToAddArg}) async {
    delete<SCHEMA>(idArg: idArg);
    _adder.add<T>(realm: realm, dataInsToAddArg: dataInsToAddArg);
  }

  @override
  void delete<SCHEMA extends RealmObject>({required ObjectId idArg}) {
    var obj = searchById<SCHEMA>(idArg: idArg);
    realm.write(() => realm.delete<SCHEMA>(obj));
  }

  @override
  void deleteAll<SCHEMA extends RealmObject>() {
    realm.write(() => realm.deleteAll<SCHEMA>());
  }
}

class _DataReader extends RealmReaderInterface {
  @override
  RealmIOResults searchById<SCHEMA extends RealmObject>(
      {required Realm realm, required ObjectId idArg}) {
    var infoResult = realm.find<SCHEMA>(idArg);

    late RealmIOResults<SCHEMA> ioResult;

    if (infoResult != null) {
      ioResult = RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
    } else {
      ioResult = RealmIOResults(
          isSuccessArg: false, resultStringArg: "That record is no Exists.");
    }

    return ioResult;
  }

  @override
  RealmIOResults readAll<SCHEMA extends RealmObject>({required Realm realm}) {
    var infoResult = realm.all<SCHEMA>().toList();

    return RealmIOResults(isSuccessArg: true, payloadArg: infoResult);
  }
}

class _DataAdder extends RealmAdderInterface {
  @override
  Future<RealmIOResults> add<T extends RealmValidatedSchemaValueInterface>(
      {required Realm realm,
      required RealmValidatedSchemaValueInterface dataInsToAddArg}) async {
    realm.write(() => realm.add(dataInsToAddArg.payload));
    return RealmIOResults(isSuccessArg: true);
  }
}
