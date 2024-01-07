
import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';

class AutoVolumeSettingAdjuster extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AutoVolumeSettingAdjusterState();
}

class AutoVolumeSettingAdjusterState extends State<AutoVolumeSettingAdjuster>{
  final _string = StringConstants();
  final _colors = MyColors();
  final _picture = PictureConstants();
  final _musicPlayer = MusicPlayer();

  double _decideVolume = 0;

  AutoVolumeSettingAdjusterState(){
    _decideVolume = _musicPlayer.currentMusic.volume.toDouble();
  }
  
  @override
  Widget build(BuildContext context){
    return AlertDialog(
          title: Text(_string.musicSettingDrawerItemAutoVolumeSettingDialogTitle),
          content: Center(
            child:  Column(
              children: [
                Text("${_decideVolume.toInt()}"),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    activeTrackColor: Theme.of(context).splashColor,
                    inactiveTrackColor: Theme.of(context).cardColor,
                    thumbColor: _colors.primaryBlue,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayColor: Colors.blue,
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                  ),
                  child: Slider(
                    value: _decideVolume,
                    onChanged: (currentValue) {
                      // setState(() {
                      //   _decideVolume = currentValue;
                      // });
                      Navigator.of(context).pop(_decideVolume);
                    },
                    min: 0,
                    max: 100,
                  ),
                ),
              ]
            ),
          ),
          actions: <Widget>[ // ボタン領域 
            TextButton( 
              child: Text(_string.listDialogCancel),
              onPressed: () => Navigator.pop(context), 
            ), 
            TextButton( 
              child: Text(_string.listDialogOK), 
              onPressed: () => {

                Navigator.pop(context), 
              }
            ), 
          ],
        );
  }
}