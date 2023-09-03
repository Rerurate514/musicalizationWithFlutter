import 'package:flutter/material.dart';
import 'package:musicalization/fetchFile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

import 'permission.dart';
import 'widgetStyle.dart';
import 'string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: const TextStyle(
                fontFamily: 'NotoSansJP',
                color: Colors.white,
              ),
            ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _permissionRequest = MediaAudioPermissionRequest();
  final _widgetStyle = WidgetStyle();
  final _fetchFile = FetchFile();
  final _string = SetedString();

  List _list = [];

  final listStream = StreamController<List>();

  @override
  void initState() {
    super.initState();
    startLogic();
  }

  @override
  void dispose() {
    super.dispose();
    listStream.close();
  }

  Future<void> startLogic() async {
    await _permissionRequest.requestPermission();

    setState(() {
      _list = _fetchFile.strList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(_string.appNameStr),
              Spacer(),
              const Text("ハンバーガー"),
            ]
          ),
        ),
        body: Column(
          children: [
            Container(
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
                        child: Image.asset(
                          'images/mp3_ui_music_shuffle_button.png',
                          width: 50,
                        ),
                      )),
                  Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: Image.asset(
                          'images/mp3_ui_google_drive_button.png',
                          width: 50,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
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
        ));
  }
}

class ListStreamObserver {
  ListStreamObserver(StreamController<List> _stream) {
    _stream.stream.listen((data) async {});
  }
}
