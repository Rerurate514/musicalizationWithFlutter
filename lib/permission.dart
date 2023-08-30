import 'package:permission_handler/permission_handler.dart';

///このクラスは、権限要求を行うメソッドを集めたクラスです。
class PermissionRequest{

  /// このメソッドは、ストレージへのアクセス権限要求を行うメソッドです。
  Future<void> requestDownloadStoragePermission() async {
    PermissionStatus status = await Permission.audio.request();

    if(status.isGranted){
      print('Download permission granted.');
    }
    else{
      print('Download permission denied.');
    }
  }
}