import 'package:flutter/material.dart';
import 'package:musicalization/logic/realm/logic/musicList/musicListController.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../setting/string.dart';
import '../setting/picture.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _musicInfoRecordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final _musicListRecordFetcher = RecordFetcher<MusicList>(MusicList.schema);

  final _musicListController = MusicListController();
  final _string = StringConstants();
  final _picture = PictureConstants();

  List<MusicList> _listInMusicList = [];

  String _tempListName = "";
  List<ObjectId> _tempListInMusicList = [];
  bool _isDialogContinued = false;

  bool _listSelected = false;

  @override
  void initState() {
    super.initState();
    _initListFetcher();
  }

  Future<void> _initListFetcher() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _listInMusicList = _musicListRecordFetcher.getAllReacordList();
      });
    });
  }

  void _onResisterBtnTapped() {
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

  void _onShuffleBtnTapped() {
    //todo シャッフルボタンが押されたときの処理
  }

  void _onListTapped(MusicList listArg) {
    _toggleListSelected(_listSelected);

  }

  void _toggleListSelected(bool selectedArg){
    !_listSelected;
  }

  Future _onDeleteListBtnTapped(ObjectId idArg) async {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            _picture.listModeImg,
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          _UpMenuBarWidget(_onResisterBtnTapped, _onShuffleBtnTapped),
          Expanded(
            child: 
          )
        ],
      ),
    );
  }
}



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

class _UpMenuBarWidget extends StatelessWidget {
  late Function() _onResisterBtnTapped;
  late Function() _onShuffleBtnTapped;

  final _picture = PictureConstants();

  _UpMenuBarWidget(Function() onResisterBtnTappedArg, onShuffleBtnTappedArg) {
    _onResisterBtnTapped = onResisterBtnTappedArg;
    _onShuffleBtnTapped = onShuffleBtnTappedArg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            _picture.appTitleLettersImg,
            width: 80,
          ),
          Card(
            elevation: 4.0,
            child: InkWell(
                onTap: _onShuffleBtnTapped,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _picture.shuffleImg,
                    width: 50,
                  ),
                )),
          ),
          Card(
            elevation: 4.0,
            child: InkWell(
                onTap: _onResisterBtnTapped,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Image.asset(
                    _picture.makeListImg,
                    width: 50,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
