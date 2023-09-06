import 'package:flutter/material.dart';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';

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

  List _list = [];

  @override
  void initState() {
    super.initState();
    _startLogic();
  }

  Future<void> _startLogic() async {
    await _permissionRequest.requestPermission();

    setState(() {
      _list = _fetchFile.strList;
    });
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
                  child: ListTile(
                    leading: Image.asset(
                      'images/mp3_menu_picture_setting.png',
                      width: 50,
                    ),
                    title: Text(_list[index]),
                  ),
                );
              },
              itemCount: _list.length,
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
