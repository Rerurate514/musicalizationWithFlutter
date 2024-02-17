
import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoEditor.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';
import 'package:realm/realm.dart';

class AutoVolumeSettingAdjuster extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AutoVolumeSettingAdjusterState();
}

class AutoVolumeSettingAdjusterState extends State<AutoVolumeSettingAdjuster>{
  final _string = StringConstants();
  final _colors = MyColors();
  final _musicPlayer = MusicPlayer();
  final _editor = MusicInfoEditor();

  double _decideVolume = 0;

  AutoVolumeSettingAdjusterState(){
    _decideVolume = _musicPlayer.currentMusic.volume.toDouble();
  }

  void _okBtnTapped(){
    MusicInfo musicInfo = MusicInfo(
      _musicPlayer.currentMusic.id, 
      _musicPlayer.currentMusic.name, 
      _musicPlayer.currentMusic.path, 
      _decideVolume.toInt(),
      _musicPlayer.currentMusic.lyrics,
      _musicPlayer.currentMusic.picture
    );
    _editor.edit(newMusicInfoArg: musicInfo);
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
                      setState(() {
                        _decideVolume = currentValue;
                      });
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
                _okBtnTapped(),
                Navigator.pop(context), 
              }
            ), 
          ],
        );
  }
}