import 'package:realm/realm.dart';
import '../realmIOResults.dart';
 
abstract class RealmAdderInterface<SCHEMA>{
  RealmIOResults add({required SCHEMA dataArg});
}