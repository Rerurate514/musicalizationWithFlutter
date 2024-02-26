import 'package:flutter/material.dart';

import '../../setting/picture.dart';

class UpMenuBarWidget extends StatelessWidget {
  late final ButtonSetting _centralBtnSetting;
  late final ButtonSetting _rightBtnSetting;

  final _picture = PictureConstants();

  UpMenuBarWidget(
      {required centralBtnSettingArg,
      required rightBtnSettingArg}) {
   _centralBtnSetting = centralBtnSettingArg;
   _rightBtnSetting = rightBtnSettingArg;
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            elevation: 4.0,
            child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _centralBtnSetting.btnFunction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _centralBtnSetting.btnPicture,
                    width: 50,
                  ),
                )),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)
            ),
            elevation: 4.0,
            child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _rightBtnSetting.btnFunction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _rightBtnSetting.btnPicture,
                    width: 50,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class ButtonSetting<BUTTONARGMENT extends Function>{
  late final String _btnPicture;
  get btnPicture => _btnPicture;

  late final BUTTONARGMENT _btnFunction;
  get btnFunction => _btnFunction;

  ButtonSetting(
    String btnPictureArg,
    BUTTONARGMENT btnFunctionArg,
  ){
    _btnPicture = btnPictureArg;
    _btnFunction = btnFunctionArg;
  }
}