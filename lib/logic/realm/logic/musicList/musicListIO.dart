import 'package:realm/realm.dart';
import '../../model/schema.dart';
import '../realmInstanceFactory.dart';

class MusicListIO{
  final realmInsFac = RealmInstanceFactory();
  late Realm realm;

  MusicListIO(){
    realm = realmInsFac.createRealmIns(schemaObjectArg: MusicList.schema);
  }

  void add({required String nameArg, required List<ObjectId> listArg}){

  }

  void search(){

  }

  void delete(){

  }

  void edit(){

  }
  
  void update(){

  }

  bool isDuplicateRecord(){


    return true;
  }
}