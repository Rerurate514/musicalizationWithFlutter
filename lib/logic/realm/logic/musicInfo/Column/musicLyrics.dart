import '../../interface/realmColumnInterface.dart';

class MusicLyrics extends RealmColumnInterface{
  late final String _value;
  get value => _value;

  MusicLyrics(String valueArg){
    _value = validateProperty<String>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}