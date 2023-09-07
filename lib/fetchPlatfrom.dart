import 'dart:io';

class Platforms{
  static String get windows => "windows";
  static String get web => "web";
  static String get ios => "ios";
  static String get android => "android";
}

class FetchPlatform{
  String getPlatForm(){
    Platform platform = Platform();
    String platformType = platform.toString();
    
    return platformType;
  }

}