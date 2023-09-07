import 'package:flutter/material.dart';
import 'dart:async';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';
import '../audioPlayerManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _permissionRequest = MediaAudioPermissionRequest();
  final _fetchFile = FetchFile();
  final _string = SetedString();

  final audioPlayerManager = AudioPlayerManager();

  List _pathList = [];
  List _nameList = [];

  @override
  void initState() {
    super.initState();
    _initFetchFile();
  }

  Future<void> _initFetchFile() async {
    await _permissionRequest.requestPermission();

    setState(() {
      _pathList = _fetchFile.list;
      _nameList = _fetchFile.strList;
    });
  }

  Future<void> _onListItemTapped(
      String musicNameArg, String musicPathArg) async {
    audioPlayerManager.startMusic(musicNameArg, musicPathArg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            'images/mp3_ui_main_mode.png',
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          const _UpMenuBarWidget(),
          Expanded(
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4.0,
                  child: InkWell(
                    onTap: () => _onListItemTapped(
                        _nameList[index], _pathList[index].toString()),
                    child: ListTile(
                      leading: Image.asset(
                        'images/mp3_menu_picture_setting.png',
                        width: 50,
                      ),
                      title: Text(_nameList[index]),
                    ),
                  ),
                );
              },
              itemCount: _nameList.length,
            ),
          )
        ],
      ),
    );
  }
}

class _UpMenuBarWidget extends StatelessWidget {
  const _UpMenuBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'images/mp3_ui_mp3player_letters.png',
            width: 80,
          ),
          Card(
              elevation: 4.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: InkWell(
                    child: Image.asset(
                      'images/mp3_ui_music_shuffle_button.png',
                      width: 50,
                    ),
                  ))),
          Card(
              elevation: 4.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: InkWell(
                    child: Image.asset(
                      'images/mp3_ui_google_drive_button.png',
                      width: 50,
                    ),
                  ))),
        ],
      ),
    );
  }
}
