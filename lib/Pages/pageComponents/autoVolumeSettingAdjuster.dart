
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
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.3, horizontal: size.width * 0.1),
        child: Card(
        elevation: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Text(
                  _string.musicSettingDrawerItemAutoVolumeSettingDialogTitle,
                  style: TextStyle(fontSize: size.height * 0.02),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.015)),
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
              Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.015)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              )
            ],
          ),
        )
      )
    );
  }
}