import 'package:realm/realm.dart';

import '../logic/musicInfo/Column/musicName.dart';
import '../logic/musicInfo/Column/musicPath.dart';
import '../logic/musicInfo/Column/musicVolume.dart';
import '../logic/musicInfo/Column/musicLyrics.dart';
import '../logic/musicInfo/Column/musicPicture.dart';

import '../logic/musicList/Column/listName.dart';
import '../logic/musicList/Column/listMusicList.dart';

part 'schema.g.dart';




@RealmModel()
class _MusicInfo{
  @PrimaryKey()
  late ObjectId id;     //テーブルId
  late MusicName name;     //曲名
  late MusicPath path;     //曲のパス
  late MusicVolume volume;   //音量
  late MusicLyrics lyrics;   //歌詞
  late MusicPicture picture;  //絵
}

@RealmModel()
class _MusicList{
  @PrimaryKey()
  late ObjectId id;           //テーブルId
  late ListName name;           //リスト名
  late ListMusicList list;   //MusicInfoのIDからなる曲リスト
}