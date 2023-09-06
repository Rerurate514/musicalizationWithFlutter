import 'package:flutter/material.dart';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{
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
            'images/mp3_ui_setting_button.png',
            width: 40,
          )
        ]),
      ),
      body: Column(
        children: [
          const Text("rerurate")
        ],
      ),
    );
  }
}