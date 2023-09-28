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
  late final String _unValidatedName;
  late final String _unValidatedPath;
  late final int _unValidatedVolume;
  late final String _unValidatedLyrics;
  late final String _unValidatedPicture;

  late final MusicName _name;
  late final MusicPath _path;
  late final MusicVolume _volume;
  late final MusicLyrics _lyrics;
  late final MusicPicture _picture;

  MusicInfoRecordFactory(
    ObjectId idArg,
    String nameArg,
    String pathArg,
    int volumeArg,
    String lyricsArg,
    String pictureArg
  ){
    _id = idArg;
    _unValidatedName = nameArg;
    _unValidatedPath = pathArg;
    _unValidatedVolume = volumeArg;
    _unValidatedLyrics = lyricsArg;
    _unValidatedPicture = pictureArg;

    _name = MusicName(_unValidatedName);
    _path = MusicPath(_unValidatedPath);
    _volume = MusicVolume(_unValidatedVolume);
    _lyrics = MusicLyrics(_unValidatedLyrics);
    _picture = MusicPicture(_unValidatedPicture);
  }

  ValidatedMusicInfo createIns(){
    return ValidatedMusicInfo(_id, _name.value, _path.value, _volume.value, _lyrics.value, _picture.value);
  }
}