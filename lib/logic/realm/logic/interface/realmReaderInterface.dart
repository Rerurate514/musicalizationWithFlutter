import 'package:realm/realm.dart';
import '../realmIOResults.dart';
 
abstract class RealmReaderInterface{
  RealmIOResults searchById({required Realm realm, required ObjectId idArg});
  RealmIOResults searchByName({required Realm realm, required String nameArg});
}