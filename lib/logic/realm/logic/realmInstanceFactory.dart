import 'package:realm/realm.dart';

class RealmInstanceFactory{
  Realm createRealmIns({required SchemaObject schemaObjectArg}){
    List<SchemaObject> schemaObject = [schemaObjectArg];
    LocalConfiguration config = Configuration.local(schemaObject);
    Realm realm = Realm(config);
    return realm;
  }
}