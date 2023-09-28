import '../../interface/realmColumnInterface.dart';

class ListName extends RealmColumnInterface{
  late final String _value;
  get value => _value;

  ListName(String valueArg){
    _value = validateProperty<String>(valueArg);
  }

  @override
  T validateProperty<T>(T arg) {
    T result = arg;
    return result;
  }
}