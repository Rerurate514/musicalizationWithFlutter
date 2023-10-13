import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';
import '../logic/realmIOManager.dart';

class RecordFetcher<SCHEMA extends RealmObject>{
  late final RealmIOManager _realmIOManager;

  RecordFetcher(SchemaObject schemaObjectArg){
    _realmIOManager = RealmIOManager(schemaObjectArg);
  }

  List<SCHEMA> getAllReacordList(){
    List<SCHEMA> result = _realmIOManager.readAll<SCHEMA>();
    return result;
  }
}