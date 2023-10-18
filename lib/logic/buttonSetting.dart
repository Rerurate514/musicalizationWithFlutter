class ButtonSetting<BUTTONARGMENT>{
  late final String _btnPicture;
  get btnPicture => _btnPicture;

  late final Function(BUTTONARGMENT) _btnFunction;
  get btnFunction => _btnFunction;

  ButtonSetting(
    String btnPictureArg,
    Function(BUTTONARGMENT) btnFunctionArg,
  ){
    _btnPicture = btnPictureArg;
    _btnFunction = btnFunctionArg;
  }
}