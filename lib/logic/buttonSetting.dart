class ButtonSetting<BUTTONARGMENT>{
  late final String _btnPicture;
  late final Function(BUTTONARGMENT) _btnFunction;

  ButtonSetting(
    String btnPictureArg,
    Function(BUTTONARGMENT) btnFunctionArg,
  ){
    _btnPicture = btnPictureArg;
    _btnFunction = btnFunctionArg;
  }
}