import '../../interface/realmColumnInterface.dart';

class MusicPath extends RealmColumnInterface{
  late final String _value;
  get value => _value;

  MusicPath(String valueArg){
    _value = validateProperty<String>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}