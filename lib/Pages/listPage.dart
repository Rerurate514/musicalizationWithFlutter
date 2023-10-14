import 'package:flutter/material.dart';
import 'package:musicalization/logic/realm/logic/musicList/musicListAdder.dart';
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

  final _adder = MusicListAdder();
  final _string = StringConstants();
  final _picture = PictureConstants();

  List<MusicList> _listInMusicList = [];

  String _tempListName = "";
  List<ObjectId> _tempListInMusicList = [];

  @override
  void initState() {
    super.initState();
    _initListFetcher();
  }

  Future<void> _initListFetcher() async {
    setState(() {
      _listInMusicList = _musicListRecordFetcher.getAllReacordList();
    });
  }

  void _onResisterBtnTapped() {
    _addMusicList();
  }

  void _addMusicList() async {
    await _showListNameEnteredDialog();
    await _showChoiceListMusicDialog();

    await _commitMusicList(_tempListName, _tempListInMusicList);
    Future.delayed(const Duration(milliseconds: 100), (){
      _initListFetcher();
    });
  }

  Future _showListNameEnteredDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String textFieldValue = "";

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
              // ボタン領域
              TextButton(
                  child: Text(_string.listDialogCancel),
                  onPressed: () => {
                        Navigator.of(context).pop(textFieldValue),
                      }),
              TextButton(
                  child: Text(_string.listDialogOK),
                  onPressed: () => {
                        Navigator.pop(context),
                      }),
            ],
          );
        });
  }

  void _getMusicListCallback(List<ObjectId> listArg) {
    _tempListInMusicList = listArg;
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
          );
        });
  }

  Future _commitMusicList(String nameArg, List<ObjectId> musicListArg) async {
    _adder.add(nameArg, musicListArg);
  }

  void _onShuffleBtnTapped() {}

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
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    leading: Image.asset(
                      _picture.musicRecordImg,
                      width: 50,
                    ),
                    title: Text(_listInMusicList[index].name),
                  ),
                );
              },
              itemCount: _listInMusicList.length,
            ),
          )
        ],
      ),
    );
  }
}

class _ResisterListDialog extends StatefulWidget {
  late final List<MusicInfo> listInMusicInfo;
  late final Function(List<ObjectId>) getMusicListCallback;
  _ResisterListDialog(
      {required this.listInMusicInfo, required this.getMusicListCallback});

  @override
  _ResisterListDialogState createState() =>
      _ResisterListDialogState(this.listInMusicInfo, this.getMusicListCallback);
}

class _ResisterListDialogState extends State<_ResisterListDialog> {
  final _string = StringConstants();
  List<MusicInfo> listInMusicInfo = [];

  final String unselectedListTileImage = PictureConstants().resisterMusicImg;
  final String selectedListTileImage = PictureConstants().musicAddToListImg;

  late List<bool> selected;

  List<ObjectId> tempListInMusicList = [];

  late final Function(List<ObjectId>) getMusicListCallback;

  _ResisterListDialogState(List<MusicInfo> listArg,
      Function(List<ObjectId>) getMusicListCallbackArg) {
    listInMusicInfo = listArg;
    getMusicListCallback = getMusicListCallbackArg;

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
                  Navigator.pop(context),
                }),
        TextButton(
            child: Text(_string.listDialogOK),
            onPressed: () => {
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
