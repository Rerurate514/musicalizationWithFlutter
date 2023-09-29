import 'package:realm/realm.dart';
import '../logic/realmIOManager.dart';

class RecordFetcher<SCHEMA extends RealmObject>{
  late final RealmIOManager _realmIOManager;

  RecordFetcher(SchemaObject schemaObjectArg){
    _realmIOManager = RealmIOManager(schemaObjectArg);
  }

  List getAllReacordList(){
    List result = _realmIOManager.readAll<SCHEMA>();
    return result;
  }
}