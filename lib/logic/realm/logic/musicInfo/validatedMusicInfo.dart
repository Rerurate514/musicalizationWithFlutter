import 'package:musicalization/logic/realm/model/schema.dart';

import '../interface/realmValidatedSchemaValueInterface.dart';

import 'Column/musicName.dart';
import 'Column/musicPath.dart';
import 'Column/musicVolume.dart';
import 'Column/musicLyrics.dart';
import 'Column/musicPicture.dart';

class ValidatedMusicInfo extends RealmValidatedSchemaValueInterface{
  late MusicInfo _payload;
  get payload => _payload;

  late final MusicName _name;
  late final MusicPath _path;
  late final MusicVolume _volume;
  late final MusicLyrics _lyrics;
  late final MusicPicture _picture;

  ValidatedMusicInfo(
    MusicInfo infoArg
  ){
    _name = MusicName(infoArg.name);
    _path = MusicPath(infoArg.path);
    _volume = MusicVolume(infoArg.volume);
    _lyrics = MusicLyrics(infoArg.lyrics);
    _picture = MusicPicture(infoArg.picture);

    _payload = MusicInfo(infoArg.id, _name.value, _path.value, _volume.value, _lyrics.value, _picture.value);
  }
}