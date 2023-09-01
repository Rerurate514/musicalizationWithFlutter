import 'package:flutter/material.dart';
import 'package:musicalization/fetchFile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

import 'permission.dart';
import 'widgetStyle.dart';

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
  MediaAudioPermissionRequest permissionRequest = MediaAudioPermissionRequest();
  WidgetStyle widgetStyle = WidgetStyle();
  FetchFile fetchFile = FetchFile();

  List list = [];

  final listStream = StreamController<List>();

  @override
  void initState(){
    super.initState();    
    startLogic();
  }

  @override
  void dispose(){
    super.dispose();
    listStream.close();
  }

  Future<void> startLogic() async {
    await permissionRequest.requestPermission();

    setState(() {
      fetchFile.fetchFileFromDownloadDir().then((value) => list = value);
      print("n = $list");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/mp3_ui_mp3player_letters.png'
            ),
            Spacer(),
            Text("ハンバーガー"),
            TextButton(onPressed: (){setState(() {
              print("b = $list");
              //list.removeAt(0);
              print("a = $list");
            });}, child: Text("fwww"))
          ],
        ),
      ),   
      body: 
          ListView.builder(
            itemBuilder: (BuildContext context, int index){ 
              return Text(list[index].toString()); 
            },
            itemCount: list.length,
          ),
    );
  }
}

class ListStreamObserver{


  ListStreamObserver(StreamController<List> _stream){
    _stream.stream.listen((data) async {
      
    });
  }
}