import 'package:permission_handler/permission_handler.dart';

abstract class PermissionRequest{
  Future<PermissionStatus> requestPermission();
}

///このクラスは、権限要求を行うメソッドを集めたクラスです。
class MediaAudioPermissionRequest extends PermissionRequest{
  /// このメソッドは、音楽ファイルへのアクセス権限要求を行うメソッドです。
  @override
  Future<PermissionStatus> requestPermission() async {
    PermissionStatus status = await Permission.audio.request();

    if(status.isGranted){
      print('READ_MEDIA_AUDIO permission granted.');
    }
    else{
      print('READ_MEDIA_AUDIO permission denied.');
    }

    return status;
  }
}