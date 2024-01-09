class RealmIOResults<SCHEMA> {
  late final bool _isSuccess;
  get isSuccess => _isSuccess;

  late final String _resultString;
  get resultString => _resultString;

  late final SCHEMA? _payload;
  get payload => _payload;

  RealmIOResults({required bool isSuccessArg, SCHEMA? payloadArg, String resultStringArg = ""}) {
    _isSuccess = isSuccessArg;
    _payload = payloadArg;
    _resultString = resultStringArg;
  }
}
