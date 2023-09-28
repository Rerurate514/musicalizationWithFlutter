import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../interface/realmValidatedSchemaValueInterface.dart';

class ValidatedMusicInfo extends RealmValidatedSchemaValueInterface{
  late MusicInfo _payload;
  get payload => _payload;

  ValidatedMusicInfo(
    ObjectId idArg,
    String nameArg,
    String pathArg,
    int volumeArg,
    String lyricsArg,
    String pictureArg
  ){
    _payload = MusicInfo(idArg, nameArg, pathArg, volumeArg, lyricsArg, pictureArg);
  }
}