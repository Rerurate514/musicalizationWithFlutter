// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MusicInfo extends _MusicInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  MusicInfo(
    ObjectId id,
    String name,
    String path,
    int volume,
    String lyrics,
    String picture,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'volume', volume);
    RealmObjectBase.set(this, 'lyrics', lyrics);
    RealmObjectBase.set(this, 'picture', picture);
  }

  MusicInfo._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get path => RealmObjectBase.get<String>(this, 'path') as String;
  @override
  set path(String value) => RealmObjectBase.set(this, 'path', value);

  @override
  int get volume => RealmObjectBase.get<int>(this, 'volume') as int;
  @override
  set volume(int value) => RealmObjectBase.set(this, 'volume', value);

  @override
  String get lyrics => RealmObjectBase.get<String>(this, 'lyrics') as String;
  @override
  set lyrics(String value) => RealmObjectBase.set(this, 'lyrics', value);

  @override
  String get picture => RealmObjectBase.get<String>(this, 'picture') as String;
  @override
  set picture(String value) => RealmObjectBase.set(this, 'picture', value);

  @override
  Stream<RealmObjectChanges<MusicInfo>> get changes =>
      RealmObjectBase.getChanges<MusicInfo>(this);

  @override
  MusicInfo freeze() => RealmObjectBase.freezeObject<MusicInfo>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MusicInfo._);
    return const SchemaObject(ObjectType.realmObject, MusicInfo, 'MusicInfo', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string),
      SchemaProperty('volume', RealmPropertyType.int),
      SchemaProperty('lyrics', RealmPropertyType.string),
      SchemaProperty('picture', RealmPropertyType.string),
    ]);
  }
}

class MusicList extends _MusicList
    with RealmEntity, RealmObjectBase, RealmObject {
  MusicList(
    ObjectId id,
    String name, {
    Iterable<ObjectId> list = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'list', RealmList<ObjectId>(list));
  }

  MusicList._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<ObjectId> get list =>
      RealmObjectBase.get<ObjectId>(this, 'list') as RealmList<ObjectId>;
  @override
  set list(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MusicList>> get changes =>
      RealmObjectBase.getChanges<MusicList>(this);

  @override
  MusicList freeze() => RealmObjectBase.freezeObject<MusicList>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MusicList._);
    return const SchemaObject(ObjectType.realmObject, MusicList, 'MusicList', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('list', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
