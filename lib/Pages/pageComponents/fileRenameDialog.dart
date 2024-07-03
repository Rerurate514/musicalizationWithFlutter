import 'package:flutter/material.dart';
import 'package:musicalization/logic/fileRenamer.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoEditor.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/string.dart';

class FileRenameDialog extends StatefulWidget {
  const FileRenameDialog({super.key});

  @override
  _FileRenameDialogState createState() => _FileRenameDialogState();
}

class _FileRenameDialogState extends State<FileRenameDialog> {
  final _string = StringConstants();
  final _musicPlayer = MusicPlayer();
  final _editor = MusicInfoEditor();
  final _renamer = FileRenamer();

  final TextEditingController _newNameController = TextEditingController();

  String _newFilePath = "";
  String _newFileName = "";


  _FileRenameDialogState(){
    String originalFileName = _musicPlayer.currentMusic.name.replaceAll(".mp3", "");
    _newNameController.text = originalFileName;

    _removeFileNameFromPath();
  }

  void _removeFileNameFromPath(){
    _newFilePath = _musicPlayer.currentMusic.path;
    _newFilePath.replaceAll(_musicPlayer.currentMusic.name, "");
  }

  void _okBtnTapped(){
    _newFilePath += "$_newFileName.mp3";

    MusicInfo musicInfo = MusicInfo(
      _musicPlayer.currentMusic.id, 
      _newFileName,
      _newFilePath, 
      _musicPlayer.currentMusic.volume, 
      _musicPlayer.currentMusic.lyrics,
      _musicPlayer.currentMusic.picture
    );
    _editor.edit(newMusicInfoArg: musicInfo);

    _renamer.renameFile(_musicPlayer.currentMusic.path, _newFileName);
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                child: TextField(
                  controller: _newNameController,
                  maxLines: null,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '新しいファイル名を入力',
                  ),
                  onChanged: ((value){
                    _newFileName = value;
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
    );
  }
}