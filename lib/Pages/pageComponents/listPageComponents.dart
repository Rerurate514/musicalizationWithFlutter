import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/upMenuBarWidget.dart';
import 'package:musicalization/logic/realm/logic/musicList/musicListController.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../../setting/string.dart';
import '../../setting/picture.dart';

class _ResisterListDialog extends StatefulWidget {
  late final List<MusicInfo> listInMusicInfo;
  late final Function(List<ObjectId>) getMusicListCallback;
  late final Function(bool) isContinuedDialogCallback;
  _ResisterListDialog(
      {required this.listInMusicInfo,
      required this.getMusicListCallback,
      required this.isContinuedDialogCallback});

  @override
  _ResisterListDialogState createState() => _ResisterListDialogState(
      this.listInMusicInfo,
      this.getMusicListCallback,
      this.isContinuedDialogCallback);
}

class _ResisterListDialogState extends State<_ResisterListDialog> {
  final _string = StringConstants();
  List<MusicInfo> listInMusicInfo = [];

  final String unselectedListTileImage = PictureConstants().resisterMusicImg;
  final String selectedListTileImage = PictureConstants().musicAddToListImg;

  late List<bool> selected;

  List<ObjectId> tempListInMusicList = [];

  late final Function(List<ObjectId>) getMusicListCallback;
  late final Function(bool) isContinuedDialogCallback;

  _ResisterListDialogState(
      List<MusicInfo> listArg,
      Function(List<ObjectId>) getMusicListCallbackArg,
      Function(bool) isContinuedDialogCallbackArg) {
    listInMusicInfo = listArg;
    getMusicListCallback = getMusicListCallbackArg;
    isContinuedDialogCallback = isContinuedDialogCallbackArg;

    selected = List.generate(listInMusicInfo.length, (index) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  void addList(ObjectId idArg) {
    setState(() {
      tempListInMusicList.contains(idArg)
          ? tempListInMusicList.remove(idArg)
          : tempListInMusicList.add(idArg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (AlertDialog(
      title: Text(_string.listDialogChoiceMusicTitle),
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
                            selected[index] = !selected[index];
                          }),
                          addList(listInMusicInfo[index].id),
                        },
                    child: ListTile(
                      leading: Image.asset(
                        selected[index]
                            ? selectedListTileImage
                            : unselectedListTileImage,
                        width: 45,
                      ),
                      title: Text(listInMusicInfo[index].name),
                    )),
              );
            },
            itemCount: listInMusicInfo.length,
          )),
      actions: <Widget>[
        TextButton(
            child: Text(_string.listDialogCancel),
            onPressed: () => {
                  isContinuedDialogCallback(false),
                  Navigator.pop(context),
                }),
        TextButton(
            child: Text(_string.listDialogOK),
            onPressed: () => {
                  isContinuedDialogCallback(true),
                  getMusicListCallback(tempListInMusicList),
                  Navigator.pop(context),
                }),
      ],
    ));
  }
}



class ListPageComponent extends StatefulWidget {
  late final Function() toggleListSelectedCallback;
  late final Function(MusicList) setSelectedListCallback;

  ListPageComponent({
    required Function() this.toggleListSelectedCallback,
    required Function(MusicList) this.setSelectedListCallback
  });

  @override
  ListPageComponentState createState() => ListPageComponentState(
    toggleListSelectedCallback,
    setSelectedListCallback
  );
}

class ListPageComponentState extends State<ListPageComponent> {
  final _picture = PictureConstants();
  final _string = StringConstants();

  final _musicInfoRecordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final _musicListRecordFetcher = RecordFetcher<MusicList>(MusicList.schema);

  final _musicListController = MusicListController();

  List<MusicList> _listInMusicList = [];

  String _tempListName = "";
  List<ObjectId> _tempListInMusicList = [];
  bool _isDialogContinued = false;

  late final Function() _toggleListSelectedCallback;
  late final Function(MusicList) _setSelectedListCallback;

  ListPageComponentState(
    Function() toggleListSelectedCallbackArg,
    Function(MusicList) setSelectedListCallbackArg
  ){
    _toggleListSelectedCallback = toggleListSelectedCallbackArg;
    _setSelectedListCallback = setSelectedListCallbackArg;
  }

  @override
  void initState() {
    super.initState();
    _initListFetcher();
  }

  Future<void> _initListFetcher() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      if(!mounted) return;
      setState(() {
        _listInMusicList = _musicListRecordFetcher.getAllReacordList();
      });
    });
  }
  
  void _onMakeListBtnTappedCallback() {
    _addMusicList();
  }

  void _addMusicList() async {
    _isDialogContinued = false;
    await _showListNameEnteredDialog();
    if (!_isDialogContinued) return;
    await _showChoiceListMusicDialog();
    if (!_isDialogContinued) return;

    await _commitMusicList(_tempListName, _tempListInMusicList);
    _initListFetcher();
  }

  Future _showListNameEnteredDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_string.listDialogTitle),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: _string.listDialogTExtFieldHintText,
              ),
              onChanged: (textArg) {
                _tempListName = textArg;
              },
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(_string.listDialogCancel),
                  onPressed: () => {
                        _isDialogContinued = false,
                        Navigator.pop(context),
                      }),
              TextButton(
                  child: Text(_string.listDialogOK),
                  onPressed: () => {
                        _isDialogContinued = true,
                        Navigator.pop(context),
                      }),
            ],
          );
        });
  }

  void _getMusicListCallback(List<ObjectId> listArg) {
    _tempListInMusicList = listArg;
  }

  void _isContinuedDialogCallback(bool isContinuedArg) {
    _isDialogContinued = isContinuedArg;
  }

  Future _showChoiceListMusicDialog() async {
    final List<MusicInfo> listInMusicInfo =
        _musicInfoRecordFetcher.getAllReacordList();

    _tempListInMusicList = [];

    await showDialog<List<ObjectId>>(
        context: context,
        builder: (BuildContext context) {
          return _ResisterListDialog(
            listInMusicInfo: listInMusicInfo,
            getMusicListCallback: _getMusicListCallback,
            isContinuedDialogCallback: _isContinuedDialogCallback,
          );
        });
  }

  Future _commitMusicList(String nameArg, List<ObjectId> musicListArg) async {
    _musicListController.add(nameArg, musicListArg);
  }

  void _onShuffleBtnTappedCallback() {
    //todo シャッフルボタンが押されたときの処理
  }

  void _onListBtnTappedCallback(MusicList listArg) {
    _toggleListSelectedCallback();
    _setSelectedListCallback(listArg);
    _initListFetcher();
  }


  Future _onDeleteListBtnTappedCallback(ObjectId idArg) async {
    bool isDeleteAgree = await _showCheckListDeleteDialog();
    if (isDeleteAgree) _musicListController.delete(idArg);
    _initListFetcher();
  }

  Future<bool> _showCheckListDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_string.listDialogCheckDeleteListTitle),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                _picture.listImg,
                width: 50,
              ),
              Image.asset(
                _picture.rightArrowImg,
                width: 50,
              ),
              Image.asset(
                _picture.deleteListImg,
                width: 50,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(_string.listDialogCancel),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(_string.listDialogOK),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == null) throw ErrorSummary("deleteListDialogResult => null");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Column(
        children: [
          UpMenuBarWidget(
            centralBtnSettingArg: ButtonSetting<Function()>(_picture.shuffleImg, _onShuffleBtnTappedCallback), 
            rightBtnSettingArg: ButtonSetting<Function()>(_picture.makeListImg, _onMakeListBtnTappedCallback)
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 4.0,
                    child: InkWell(
                      onTap: () =>
                          _onListBtnTappedCallback(_listInMusicList[index]),
                      child: ListTile(
                          leading: Image.asset(
                            _picture.listImg,
                            width: 50,
                          ),
                          title: Text(_listInMusicList[index].name),
                          trailing: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 4.0,
                            child: InkWell(
                              onTap: () => _onDeleteListBtnTappedCallback(
                                  _listInMusicList[index].id),
                              child: Image.asset(
                                _picture.deleteListImg,
                                width: 40,
                              ),
                            ),
                          )),
                    ));
              },
              itemCount: _listInMusicList.length,
            ),
          )
        ],
      ),
    ));
  }
}
