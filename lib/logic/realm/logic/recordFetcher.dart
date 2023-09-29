import 'package:realm/realm.dart';
import 'realmIOResults.dart';
import '../logic/realmIOManager.dart';

class RecordFetcher<SCHEMAOBJECT extends SchemaObject>{
  late final RealmIOManager _realmIOManager;

  RecordFetcher(SCHEMAOBJECT schemaObjectArg){
    _realmIOManager = RealmIOManager(schemaObjectArg);
  }

  List getAllReacordList(){
    List result = _realmIOManager.readAll();
    return result;
  }
}