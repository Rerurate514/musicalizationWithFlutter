import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/upMenuBarWidget.dart';
import 'package:musicalization/logic/realm/logic/musicList/musicListController.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/picture.dart';

import 'package:musicalization/logic/musicPlayer.dart';

import 'package:realm/realm.dart';

import 'package:musicalization/setting/string.dart';

class InListPageComponent extends StatefulWidget {
  final MusicList musicList;
  final Function() toggleListSelectedCallback;
  final Function() movePlayPageCallback;

  const InListPageComponent({
    required MusicList this.musicList,
    required Function() this.toggleListSelectedCallback,
    required Function() this.movePlayPageCallback,
  });

  @override
  InListPageComponentState createState() => InListPageComponentState(
      musicList, toggleListSelectedCallback, movePlayPageCallback);
}

class InListPageComponentState extends State<InListPageComponent> {
  final _picture = PictureConstants();
  final _musicInfoRecordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final _musicListRecordFetcher = RecordFetcher<MusicList>(MusicList.schema);
  final _musicListController = MusicListController();
  late final MusicPlayer _musicPlayer;

  late MusicList _musicList;
  List<MusicInfo> _listInMusicInfo = [];

  late final Function() _toggleListSelectedCallback;
  late final Function() _movePlayPageCallback;

  late List<ObjectId> _tempEditedList;
  late ObjectId _musicListId;
  late String _tempEditedName;
  bool _isDialogContinued = false;

  InListPageComponentState(
      MusicList listArg,
      Function() toggleListSelectedCallbackArg,
      Function() movePlayPageCallbackArg) {
    _musicList = listArg;
    _musicListId = _musicList.id;
    _toggleListSelectedCallback = toggleListSelectedCallbackArg;
    _movePlayPageCallback = movePlayPageCallbackArg;
    _tempEditedName = _musicList.name;
  }

  @override
  void initState() {
    super.initState();
    _initListFetcher();
  }

  Future<void> _initListFetcher() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _fetchMusicInfoFromMusicList();
    });
  }

  void _fetchMusicInfoFromMusicList() {
    _musicList = _musicListRecordFetcher.getRecordFromId(_musicListId);
    _listInMusicInfo = [];
    for (var musicIdArg in _musicList.list) {
      setState(() {
        _listInMusicInfo
            .add(_musicInfoRecordFetcher.getRecordFromId(musicIdArg));
      });
    }
  }

  void _onShuffleBtnTappedCallback() {}

  void _onEditMusicBtnTappedCallback() {
    _editMusicList();
  }

  Future _editMusicList() async {
    _isDialogContinued = false;
    await _showwEditListNameDialog();
    if (!_isDialogContinued) return;
    await _showEditListDialog();
    if (!_isDialogContinued) return;

    await _commitEditedMusicList();
    _musicList = _musicListRecordFetcher.getRecordFromId(_musicList.id);

    _initListFetcher();
  }

  Future _commitEditedMusicList() async {
    _musicListController.editList(
        _musicListId, _tempEditedName, _tempEditedList);
  }

  void checkContinueToShowDialog(bool isDialogConituneArg) {
    _isDialogContinued = isDialogConituneArg;
  }

  Future _showwEditListNameDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return _EditNameDialog(
              listName: _tempEditedName,
              getMusicListNameCallback: _getEditedListNameCallback,
              checkContinueToShowDialog: checkContinueToShowDialog);
        });
  }

  Future _showEditListDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return _EditListDialog(
              listInMusicInfo: _listInMusicInfo,
              getMusicListCallback: _getEditedMusicListCallback);
        });
  }

  void _getEditedListNameCallback(String nameArg) {
    _tempEditedName = nameArg;
  }

  void _getEditedMusicListCallback(List<ObjectId> listArg) {
    _tempEditedList = listArg;
  }

  void _onMusicBtnTapped(int listInMusicInfoIndexArg) {
    _musicPlayer =
        MusicPlayer(_listInMusicInfo, listInMusicInfoIndexArg, _musicList.name);
    _musicPlayer.start();
    Function() movePageCallback = _movePlayPageCallback;
    movePageCallback();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Column(
        children: [
          UpMenuBarWidget(
              centralBtnSettingArg: ButtonSetting<Function()>(
                  _picture.shuffleImg, _onShuffleBtnTappedCallback),
              rightBtnSettingArg: ButtonSetting<Function()>(
                  _picture.resisterMusicImg, _onEditMusicBtnTappedCallback)),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 4.0,
                    child: InkWell(
                      onTap: () => _onMusicBtnTapped(index),
                      child: ListTile(
                        leading: Image.asset(
                          _picture.playMusicBtnImg,
                          width: 50,
                        ),
                        title: Text(_listInMusicInfo[index].name),
                      ),
                    ));
              },
              itemCount: _listInMusicInfo.length,
            ),
          ),
        ],
      ),
    ));
  }
}

class _EditNameDialog extends StatefulWidget {
  final String listName;
  final Function(String) getMusicListNameCallback;
  final Function(bool) checkContinueToShowDialog;

  const _EditNameDialog(
      {required this.listName,
      required this.getMusicListNameCallback,
      required this.checkContinueToShowDialog});

  @override
  _EditNameDialogState createState() => _EditNameDialogState(
      listName, getMusicListNameCallback, checkContinueToShowDialog);
}

class _EditNameDialogState extends State<_EditNameDialog> {
  final _string = StringConstants();

  String _tempListName;
  final Function(String) _getMusicListNameCallback;
  final Function(bool) _checkContinueToShowDialog;

  _EditNameDialogState(this._tempListName, this._getMusicListNameCallback,
      this._checkContinueToShowDialog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_string.listDialogTitle),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: _string.listDialogEditListTitle,
        ),
        onChanged: (textArg) {
          _tempListName = textArg;
        },
      ),
      actions: <Widget>[
        TextButton(
            child: Text(_string.listDialogCancel),
            onPressed: () => {
                  _checkContinueToShowDialog(false),
                  Navigator.pop(context),
                }),
        TextButton(
            child: Text(_string.listDialogOK),
            onPressed: () => {
                  _getMusicListNameCallback(_tempListName),
                  _checkContinueToShowDialog(true),
                  Navigator.pop(context),
                }),
      ],
    );
  }
}

class _EditListDialog extends StatefulWidget {
  final List<MusicInfo> listInMusicInfo;
  final Function(List<ObjectId>) getMusicListCallback;
  const _EditListDialog(
      {required this.listInMusicInfo, required this.getMusicListCallback});

  @override
  _EditListDialogState createState() =>
      _EditListDialogState(listInMusicInfo, getMusicListCallback);
}

class _EditListDialogState extends State<_EditListDialog> {
  final _string = StringConstants();
  List<MusicInfo> _listInMusicInfo = [];

  final String unselectedListTileImage = PictureConstants().resisterMusicImg;
  final String selectedListTileImage = PictureConstants().musicAddToListImg;

  List<bool> _selected = [];

  List<ObjectId> _tempListInMusicList = [];

  late final Function(List<ObjectId>) _getMusicListCallback;
  late final List<MusicInfo> _listInAllMusicInfo;

  _EditListDialogState(List<MusicInfo> listArg,
      Function(List<ObjectId>) getMusicListCallbackArg) {
    _listInMusicInfo = listArg;
    _getMusicListCallback = getMusicListCallbackArg;
    _listInAllMusicInfo = _fetchAllMusicInfo();

    _listInMusicInfo.forEach((element) {
      _tempListInMusicList.add(element.id);
    });
  }

  @override
  void initState() {
    _findSelectedMusic();
    super.initState();
  }

  void _findSelectedMusic() {
    _selected = List.generate(_listInAllMusicInfo.length, (index) => false);

    for(var i = 0; i <= _listInAllMusicInfo.length - 1; i++){
      for(var element in _listInMusicInfo){
        if(_listInAllMusicInfo[i].id == element.id) _selected[i] = true;
      }
    }
  }

  List<MusicInfo> _fetchAllMusicInfo() {
    final musicInfoRecordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
    List<MusicInfo> result = musicInfoRecordFetcher.getAllReacordList();

    return result;
  }

  void addList(ObjectId idArg) {
    setState(() {
      _tempListInMusicList.contains(idArg)
          ? _tempListInMusicList.remove(idArg)
          : _tempListInMusicList.add(idArg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (AlertDialog(
      title: Text(_string.listDialogEditListAndDeleteMusic),
      content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 4.0,
                child: InkWell(
                    onTap: () => {
                          setState(() {
                            _selected[index] = !_selected[index];
                          }), 
                          addList(_listInAllMusicInfo[index].id),
                        },
                    child: ListTile(
                      leading: Image.asset(
                        _selected[index]
                            ? selectedListTileImage
                            : unselectedListTileImage,
                        width: 45,
                      ),
                      title: Text(_listInAllMusicInfo[index].name),
                    )),
              );
            },
            itemCount: _listInAllMusicInfo.length,
          )),
      actions: <Widget>[
        TextButton(
            child: Text(_string.listDialogCancel),
            onPressed: () => {
                  Navigator.pop(context),
                }),
        TextButton(
            child: Text(_string.listDialogOK),
            onPressed: () => {
                  _getMusicListCallback(_tempListInMusicList),
                  Navigator.pop(context),
                }),
      ],
    ));
  }
}
