import 'dart:io';

class FetchFile{
  late List _list = [];
  List get list => _list;

  late List _strList;
  List get strList => _strList;

  late _TrimFileStr _trimFileStr;


  FetchFile(){
    _doAsyncMethod();
  }

  Future<void> _doAsyncMethod() async {
    await _fetchFileFromDownloadDir().then((value) => _list = value);
    _trimFileStr = _TrimFileStr(_list);
    _strList = _trimFileStr.list;
  }

  ///このメソッドは外部ストレージのオブジェクトを取得するメソッドです。
  Future<Directory> _getExternalDir() async {
    Directory? directory = Directory("");

    if(Platform.isWindows){
      directory = Directory("C:\\Users\\rerur\\pic\\Saved Pictures\\Saved Pictures");
    }
    else if(Platform.isAndroid){
      directory = Directory("/storage/emulated/0/Download/");
    }
    else if(Platform.isIOS){

    }
    else{
      throw Error();
    }
    
    return directory;
  }

  ///このメソッドは外部ストレージのdownloadディレクトリ内のファイルを取得するメソッドです。
  Future<List> _fetchFileFromDownloadDir() async {
    Directory dir = await _getExternalDir();

    List<FileSystemEntity> result = dir.listSync();

    return result;
  }
}

class _TrimFileStr{
  late List _list = [];
  List get list => _list;

  _TrimFileStr(List listArg){
    _list = listArg;
    _list = trimFileName();
  }

  List<String> trimFileName(){
    List<String> fileNameStrList = convertFileNameToString();
    List<String> result = [];

    for(var i = 0; i < fileNameStrList.length; i++){
      result.add(
        fileNameStrList[i]
          .replaceAll("File: '/storage/emulated/0/Download/", "")
          .replaceAll("Directory: '/storage/emulated/0/Download/", "")
          .replaceAll("'", "")
      );
    }

    return result;
  }

  List<String> convertFileNameToString(){
    List<String> result = [];

    for(var i = 0; i < _list.length; i++){
      if(_list[i].toString().contains(".trashed-")) continue;
      result.add(_list[i].toString());
    }

    return result;
  }

}