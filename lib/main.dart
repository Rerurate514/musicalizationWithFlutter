import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'permission.dart';

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
      theme: new ThemeData.dark(),
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
  PermissionRequest req = new PermissionRequest();
  
  ///このメソッドは、外部ストレージのパスを取得するメソッドです。
  Future<String> getExternalStoragePath() async {
    Directory? directory = await getExternalStorageDirectory();
    
    if(directory == null) {
      print("Failed to access external storage in [getExternalStoragePath] method");
      return "";
    }

    String path = directory.path;
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/mp3_ui_mp3player_letters.png'
        ),
      ),
      body: Column(
        children: [
          
        ],
      )
    );
  }
}
