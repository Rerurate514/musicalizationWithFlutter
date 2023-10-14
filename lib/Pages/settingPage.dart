import 'package:flutter/material.dart';

import '../setting/string.dart';
import '../setting/picture.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _string = StringConstants();
  final _picture = PictureConstants();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(_string.appNameStr),
            const Spacer(),
            Image.asset(
              _picture.settingModeImg,
              width: 40,
            )
          ]),
        ),
        body: Center(
          child: Column(children: []),
        ));
  }
}
