import 'package:flutter/material.dart';

import '../setting/string.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _string = StringConstants();

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
              'images/mp3_ui_setting_button.png',
              width: 40,
            )
          ]),
        ),
        body: Center(
          child: Column(children: []),
        ));
  }
}
