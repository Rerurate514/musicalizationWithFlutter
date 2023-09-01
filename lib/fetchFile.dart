import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FetchFile{

  ///このメソッドは外部ストレージのオブジェクトを取得するメソッドです。
  Future<Directory> getExternalDir() async {
    Directory? directory = Directory("/storage/emulated/0/Download/");

    return directory;
  }

  ///このメソッドは外部ストレージのdownloadディレクトリ内のファイルを取得するメソッドです。
  Future<List> fetchFileFromDownloadDir() async {
    Directory dir = await getExternalDir();

    List<FileSystemEntity> list = dir.listSync();

    print("list = $list");

    return list;
  }
}

class TrimFileStr{
  List<String> trimFileName(List _list){
    List list = _list;
    List<String> result = convertFileNameToString(list);

    

    return result;
  }

  List<String> convertFileNameToString(List _list){
    List list = _list;
    List<String> result = [];

    list.forEach((element) {
      result.add(element);
    });

    return result;
  }
}