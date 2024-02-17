// import 'package:flutter_test/flutter_test.dart';
// import 'package:musicalization/logic/realm/logic/realmInstanceFactory.dart';
// import 'package:musicalization/logic/realm/model/schema.dart';
// import 'package:realm/realm.dart';

// void main(){
//   test("データCRUD", () {
//     final realmInsFac = RealmInstanceFactory();
//     final Realm realm = realmInsFac.createRealmIns(schemaObjectArg: MusicInfo.schema);
//     final id = ObjectId();

//     final info = MusicInfo(id, "baaaala", "", 53, "", "picture");

//     realm.write(() => 
//       realm.add(info),
//     );

//     final info2 = realm.find(id);
//     expect(info2., matcher)
//   });
// }