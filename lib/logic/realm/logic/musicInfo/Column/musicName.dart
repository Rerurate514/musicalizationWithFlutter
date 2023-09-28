import '../../interface/realmColumnInterface.dart';

class MusicName extends RealmColumnInterface{
  late final String _value;
  get value => _value;

  MusicName(String valueArg){
    _value = validateProperty<String>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}