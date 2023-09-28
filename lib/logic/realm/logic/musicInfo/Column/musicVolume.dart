import '../../interface/realmColumnInterface.dart';

class MusicVolume extends RealmColumnInterface{
  late final int _value;
  get value => _value;

  MusicVolume(int valueArg){
    _value = validateProperty<int>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    int result = arg as int;
    if(result > 100 || result < 0) throw Error();
    return result as T;
  }
}