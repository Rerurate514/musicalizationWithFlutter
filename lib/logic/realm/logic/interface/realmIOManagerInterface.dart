import 'package:musicalization/logic/realm/logic/interface/realmValidatedSchemaValueInterface.dart';
import 'package:realm/realm.dart';

abstract class RealmIOManagerInterface{
  Future<void> add<T extends RealmValidatedSchemaValueInterface>({required T dataInsToAddArg});
  List readAll<SCHEMA extends RealmObject>();
  SCHEMA searchById<SCHEMA extends RealmObject>({required ObjectId idArg});
  SCHEMA searchByName<SCHEMA extends RealmObject>({required ObjectId idArg});
  void delete<SCHEMA extends RealmObject>({required ObjectId idArg});
  void deleteAll<SCHEMA extends RealmObject>();
}