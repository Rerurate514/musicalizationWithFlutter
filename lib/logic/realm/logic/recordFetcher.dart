import 'package:realm/realm.dart';
import 'interface/realmReaderInterface.dart';
import 'realmIOResults.dart';

class RecordFetcher<READERINS extends RealmReaderInterface>{
  late final READERINS _readerIns;

  RecordFetcher(READERINS readerInsArg){
    _readerIns = readerInsArg;
  }

  List getAllReacordList(Realm realm){
    RealmIOResults result = _readerIns.readAll(realm: realm);
    return result.payload;
  }
}