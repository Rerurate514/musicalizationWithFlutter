import 'package:realm/realm.dart';
import '../realmIOResults.dart';
 
import 'realmValidatedSchemaValueInterface.dart';

abstract class RealmAdderInterface{
  Future<RealmIOResults> add<T extends RealmValidatedSchemaValueInterface>({required Realm realm,required T dataInsToAddArg});
}