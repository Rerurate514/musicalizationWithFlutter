import 'package:realm/realm.dart';
import '../model/schema.dart';

class MusicListManager{
  late List<SchemaObject> schemaObject;
  late LocalConfiguration config;
  late Realm realm;

  MusicListManager(){
    schemaObject = [MusicList.schema];
    config = Configuration.local(schemaObject);
    realm = Realm(config);
  }

  void insert({required String name, required }){

  }

  void search(){

  }

  void delete(){

  }

  void edit(){

  }
}