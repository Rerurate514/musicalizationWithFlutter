import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '';

import '../setting/string.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _string = StringConstants();

  final List<MusicInfo> _musicList = [];

  final List<ObjectId> _musicListToDB = [];

  @override
  void initState() {
    super.initState();
  }

  void _onResisterBtnTapped() {
    //todo show dialog to enter listName
    _showListNameEnteredDialog();

    //todo show dialog to decide list of music
  }

  void _showListNameEnteredDialog() {
    showDialog(
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
                _addMusicListName(textArg);
              },
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: Text(_string.listDialogCancel),
                  onPressed: () => {
                        Navigator.pop(context),
                      }),
              TextButton(
                  child: Text(_string.listDialogOK),
                  onPressed: () => {
                        _showListNameEnteredDialog(),
                        Navigator.pop(context),
                      }),
            ],
          );
        });
  }

  void _showCohiceListMusicDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_string.listDialogChoiceMusicTitle),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Column(children: [
                    ListView.builder(
                      addAutomaticKeepAlives: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4.0,
                          child: InkWell(
                              onTap: () => _addMusicToList(
                                  "#todo ここに押されたリストのMusicfoを入れる"),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/mp3_menu_picture_setting.png',
                                  width: 50,
                                ),
                                title: Text(""),
                              )),
                        );
                      },
                    )
                  ])
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: Text(_string.listDialogCancel),
                  onPressed: () => {
                        Navigator.pop(context),
                      }),
              TextButton(
                  child: Text(_string.listDialogOK),
                  onPressed: () => {
                        _addMusicListToDB(),
                        Navigator.pop(context),
                      }),
            ],
          );
        });
  }

  void _addMusicListName(String textArg){
    print("inputText = " + textArg);
  }

  void _addMusicToList(String textArg) {
    print("inputText = " + textArg);
  }

  Future _addMusicListToDB() async {

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
            'images/mp3_ui_list_mode.png',
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
                      'images/mp3_menu_picture_setting.png',
                      width: 50,
                    ),
                    title: Text(_musicList[index]),
                  ),
                );
              },
              itemCount: _musicList.length,
            ),
          )
        ],
      ),
    );
  }
}

class _UpMenuBarWidget extends StatelessWidget {
  late Function() _onResisterBtnTapped;
  late Function() _onShuffleBtnTapped;

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
            'images/mp3_ui_mp3player_letters.png',
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
                    'images/mp3_ui_music_shuffle_button.png',
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
                    'images/mp3_ui_list_make.png',
                    width: 50,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
