import 'package:flutter/material.dart';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.title});
  final String title;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>{
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
          Spacer(),
          Image.asset(
            'images/mp3_ui_music_mode.png',
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          const Text("paly!")
        ],
      ),
    );
}
}