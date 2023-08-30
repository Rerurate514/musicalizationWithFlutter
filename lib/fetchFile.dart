import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FetchFile{

  ///このメソッドは外部ストレージのオブジェクトを取得するメソッドです。
  Future<Directory> getExternalDir() async {
    Directory? directory = Directory("/storage/emulated/0/Download/");

    if(directory == null) {
      Exception("Failed to access external storage in [getExternalDir] method");
    }

    return directory;
  }

  ///このメソッドは外部ストレージのdownloadディレクトリ内のファイルを取得するメソッドです。
  Future<void> fetchFileFromDownloadDir() async {
    Directory dir = await getExternalDir();

    List<FileSystemEntity> list = dir.listSync();

    print("di = $dir\nlist = $list");

    //return list;
  }
}