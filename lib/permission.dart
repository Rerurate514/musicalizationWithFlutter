import 'package:permission_handler/permission_handler.dart';

///このクラスは、権限要求を行うメソッドを集めたクラスです。
class PermissionRequest{

  /// このメソッドは、音楽ファイルへのアクセス権限要求を行うメソッドです。
  Future<void> requestMediaAudioPermission() async {
    PermissionStatus status = await Permission.audio.request();

    if(status.isGranted){
      print('READ_MEDIA_AUDIO permission granted.');
    }
    else{
      print('READ_MEDIA_AUDIO permission denied.');
    }
  }
}