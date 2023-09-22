import 'dart:io';
import 'filrStrTrimer.dart';

class FileFetcher{
  late List _list = [];
  List get list => _list;

  late List _nameList;
  List get nameList => _nameList;
  late List _pathList;
  List get pathList => _pathList;

  final _trimFileStr = FileStrTrimer();


  FileFetcher(){
    _doAsyncMethod();
  }

  Future<void> _doAsyncMethod() async {
    await _fetchFileFromDownloadDir().then((value) => _list = value);
    _nameList = _trimFileStr.convertFileNameToNameString(_list);
    _pathList = _trimFileStr.convertFileNameToPathString(_list);
  }

  ///このメソッドは外部ストレージのオブジェクトを取得するメソッドです。
  Future<Directory> _fetchExternalDir() async {
    Directory? directory = Directory("");

    if(Platform.isWindows){
      //todo
      directory = Directory("C:\\Users\\InUserName\\pic\\Saved Pictures\\Saved Pictures");
    }
    else if(Platform.isAndroid){
      directory = Directory("/storage/emulated/0/Download/");
    }
    else if(Platform.isIOS){
      //todo
    }
    else{
      print("unknown platform, undefined logic");
    }
    
    return directory;
  }

  ///このメソッドは外部ストレージのdownloadディレクトリ内のファイルを取得するメソッドです。
  Future<List> _fetchFileFromDownloadDir() async {
    Directory dir = await _fetchExternalDir();

    List<FileSystemEntity> result = dir.listSync();

    return result;
  }
}