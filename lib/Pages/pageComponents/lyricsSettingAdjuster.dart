
import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoEditor.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';
import 'package:realm/realm.dart';

class LyricsSettingAdjuster extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LyricsSettingAdjusterState();
}

class LyricsSettingAdjusterState extends State<LyricsSettingAdjuster>{
  final _string = StringConstants();
  final _musicPlayer = MusicPlayer();
  final _editor = MusicInfoEditor();
  final _lyricsTextController = TextEditingController();

  String _lyrics = "";

  LyricsSettingAdjusterState(){
    _lyrics = _musicPlayer.currentMusic.lyrics;
    _lyricsTextController.text = _lyrics;
  }

  void _okBtnTapped(){
    MusicInfo musicInfo = MusicInfo(
      _musicPlayer.currentMusic.id, 
      _musicPlayer.currentMusic.name, 
      _musicPlayer.currentMusic.path, 
      _musicPlayer.currentMusic.volume,
      _lyrics,
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
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.03),
                  child: Text(
                    _string.musicSettingDrawerItemLyricsSettingDialogTitle,
                    style: TextStyle(fontSize: size.height * 0.02),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.015)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                  child: TextField(
                    controller: _lyricsTextController,
                    maxLines: null,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '歌詞を入力',
                    ),
                    onChanged: ((value){
                      _lyrics = value;
                    }),
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
      )
    );
  }
}