import 'package:flutter/material.dart';

import '../../setting/picture.dart';

class UpMenuBarWidget extends StatelessWidget {
  late final Function() _onCentralBtnTapped;
  late final Function() _onRightBtnTapped;

  late final String _centralBtnImg;
  late final String _rightBtnImg;

  final _picture = PictureConstants();

  UpMenuBarWidget(
      {required onCentralBtnTappedCallbackArg,
      required onRightBtnTappedCallbackArg,
      required centralBtnImgArg,
      required rightBtnImgArg}) {
    _onCentralBtnTapped = onCentralBtnTappedCallbackArg;
    _onRightBtnTapped = onRightBtnTappedCallbackArg;
    _centralBtnImg = centralBtnImgArg;
    _rightBtnImg = rightBtnImgArg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            _picture.appTitleLettersImg,
            width: 80,
          ),
          Card(
            elevation: 4.0,
            child: InkWell(
                onTap: _onCentralBtnTapped,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _centralBtnImg,
                    width: 50,
                  ),
                )),
          ),
          Card(
            elevation: 4.0,
            child: InkWell(
                onTap: _onRightBtnTapped,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _rightBtnImg,
                    width: 50,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

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