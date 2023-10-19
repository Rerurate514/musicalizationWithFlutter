import 'package:permission_handler/permission_handler.dart';

abstract class PermissionRequester {
  Future<PermissionStatus> requestPermission();
}

///このクラスは、権限要求を行うメソッドを集めたクラスです。
class MediaAudioPermissionRequester extends PermissionRequester {
  /// このメソッドは、音楽ファイルへのアクセス権限要求を行うメソッドです。
  @override
  Future<PermissionStatus> requestPermission() async {
    PermissionStatus status = await Permission.audio.request();

    status.isGranted
        ? print('READ_MEDIA_AUDIO permission granted.')
        : print('READ_MEDIA_AUDIO permission denied.');

    return status;
  }
}
