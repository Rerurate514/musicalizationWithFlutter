# RealmDBの構造

テーブルは以下にて定義する。
- MusicInfo
- MusicList

## MusicInfoのカラム
|カラム名|型|
|-|-|
|ID|ObjectId|
|曲名|String|
|パス|String|
|音量|double|
|歌詞|String|
|絵|ByteArray|

## MusicListのカラム
|カラム名|型|
|-|-|
|ID|ObjectId|
|リスト名|String|
|曲リスト|List<musicInfoのID>|