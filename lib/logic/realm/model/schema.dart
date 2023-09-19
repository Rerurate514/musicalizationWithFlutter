import 'package:realm/realm.dart';

part 'schema.g.dart';

@RealmModel()
class _MusicInfo{
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late double volume;
  late String lyrics;
  late String picture;
}

@RealmModel()
class _MusicList{
  @PrimaryKey()
  late ObjectId id;
  late String name;
  late List<String> list;
}