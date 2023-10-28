

import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../interface/realmValidatedSchemaValueInterface.dart';

import 'Column/listName.dart';
import 'Column/listMusicList.dart';

class ValidatedMusicList extends RealmValidatedSchemaValueInterface{
  late MusicList _payload;
  get payload => _payload;

  late final ObjectId _id;
  late final ListName _name;
  late final ListMusicList _list;

  ValidatedMusicList(
    MusicList listArg
  ){
    _id = listArg.id;
    _name = ListName(listArg.name);
    _list = ListMusicList(listArg.list);

    _payload = MusicList(_id, _name.value);
    _payload.list.addAll(_list.value);
  }
}