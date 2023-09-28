import 'package:realm/realm.dart';

import '../../interface/realmColumnInterface.dart';

class ListMusicList extends RealmColumnInterface{
  late final List<ObjectId> _value;
  get value => _value;

  ListMusicList(List<ObjectId> valueArg){
    _value = validateProperty<List<ObjectId>>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}