

import 'package:musicalization/logic/realm/model/schema.dart';

import '../interface/realmValidatedSchemaValueInterface.dart';

import 'Column/listName.dart';
import 'Column/listMusicList.dart';

class ValidatedMusicList extends RealmValidatedSchemaValueInterface{
  late MusicList _payload;
  get payload => _payload;

  late final ListName _name;
  late final ListMusicList _list;

  ValidatedMusicList(
    MusicList listArg
  ){
    _name = ListName(listArg.name);
    _list = ListMusicList(listArg.list);

    _payload = MusicList(listArg.id, listArg.name);
  }
}