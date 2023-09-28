import '../../interface/realmColumnInterface.dart';

class MusicPicture extends RealmColumnInterface{
  late final String _value;
  get value => _value;

  MusicPicture(String valueArg){
    _value = validateProperty<String>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}