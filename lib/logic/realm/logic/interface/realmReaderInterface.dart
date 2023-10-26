import 'package:realm/realm.dart';
import '../realmIOResults.dart';
 
abstract class RealmReaderInterface{
  RealmIOResults searchById<SCHEMA extends RealmObject>({required Realm realm, required ObjectId idArg});
  RealmIOResults readAll<SCHEMA extends RealmObject>({required Realm realm});
}