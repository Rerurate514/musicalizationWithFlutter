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
    double volume,
    String lyrics,
    String picture,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
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
  double get volume => RealmObjectBase.get<double>(this, 'volume') as double;
  @override
  set volume(double value) => RealmObjectBase.set(this, 'volume', value);

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
      SchemaProperty('volume', RealmPropertyType.double),
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
    Iterable<MusicInfo> list = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<MusicInfo>>(
        this, 'list', RealmList<MusicInfo>(list));
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
  RealmList<MusicInfo> get list =>
      RealmObjectBase.get<MusicInfo>(this, 'list') as RealmList<MusicInfo>;
  @override
  set list(covariant RealmList<MusicInfo> value) =>
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
      SchemaProperty('list', RealmPropertyType.object,
          linkTarget: 'MusicInfo', collectionType: RealmCollectionType.list),
    ]);
  }
}
