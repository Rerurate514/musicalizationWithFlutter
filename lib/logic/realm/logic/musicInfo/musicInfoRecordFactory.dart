import 'package:realm/realm.dart';

import '../musicInfo/Column/musicName.dart';
import '../musicInfo/Column/musicPath.dart';
import '../musicInfo/Column/musicVolume.dart';
import '../musicInfo/Column/musicLyrics.dart';
import '../musicInfo/Column/musicPicture.dart';

import 'validatedMusicInfo.dart';

class MusicInfoRecordFactory{
  late final ValidatedMusicInfo validatedMusicInfo;
  late final ObjectId _id;
  late final MusicName _name;
  late final MusicPath _path;
  late final MusicVolume _volume;
  late final MusicLyrics _lyrics;
  late final MusicPicture _picture;

  MusicInfoRecordFactory(
    ObjectId idArg,
    MusicName nameArg,
    MusicPath pathArg,
    MusicVolume volumeArg,
    MusicLyrics lyricsArg,
    MusicPicture pictureArg
  ){
    _id = idArg;
    _name = nameArg;
    _path = pathArg;
    _volume = volumeArg;
    _lyrics = lyricsArg;
    _picture = pictureArg;
  }

  ValidatedMusicInfo createIns(){
    return ValidatedMusicInfo(_id, _name.value, _path.value, _volume.value, _lyrics.value, _picture.value);
  }
}