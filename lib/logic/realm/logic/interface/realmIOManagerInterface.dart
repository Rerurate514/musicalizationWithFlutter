import 'package:musicalization/logic/realm/logic/interface/realmValidatedSchemaValueInterface.dart';
import 'package:realm/realm.dart';

abstract class RealmIOManagerInterface{
  void add<T extends RealmValidatedSchemaValueInterface>({required T dataInsToAddArg});
  SCHEMA searchById<SCHEMA extends RealmObject>({required ObjectId idArg});
  SCHEMA searchByName<SCHEMA extends RealmObject>({required ObjectId idArg});
  void delete({required ObjectId idArg});
  void deleteAll({required Realm realm});
}