import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FetchFile{
  
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
}