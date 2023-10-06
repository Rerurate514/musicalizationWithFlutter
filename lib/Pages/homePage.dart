import 'package:flutter/material.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoUpdater.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'dart:async';

import '../setting/string.dart';
import '../logic/audioPlayerManager.dart';

import '../logic/realm/logic/recordFetcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _string = StringConstants();

  final audioPlayerManager = AudioPlayerManager();

  final recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final MusicInfoUpdater musicInfoUpdater = MusicInfoUpdater();

  final ScrollController _scrollController = ScrollController();

  List<MusicInfo> _list = [];

  @override
  void initState() {
    super.initState();
    _initFileFetcher();
  }

  Future<void> _initFileFetcher() async {
    setState((){
      _list = recordFetcher.getAllReacordList();
    });
  }

  Future<void> _onListItemTapped(
    String musicNameArg, String musicPathArg) async {
    audioPlayerManager.startMusic(musicNameArg, musicPathArg);
  }

  void _onUpdateBtnTapped(){
    setState(() {
      _list = [];
    });
    musicInfoUpdater.updateDataBase();


    Future.delayed(const Duration(microseconds: 1000),() {
      setState(() {
        _list = recordFetcher.getAllReacordList();
      });
    });
  }

  String getStr(int index){
    // for(MusicInfo i in _list){
    //   print("irerraotr $index = " + i.name.toString());
    // }
    print("index = $index, len = ${_list.length}");
    return _list[index].name.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            'images/mp3_ui_main_mode.png',
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          const _UpMenuBarWidget(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              addAutomaticKeepAlives: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4.0,
                  child: InkWell(
                    onTap: () => _onListItemTapped(
                        _list[index].path, _list[index].path.toString()),
                    child: ListTile(
                      leading: Image.asset(
                        'images/mp3_menu_picture_setting.png',
                        width: 50,
                      ),
                      title: Text(getStr(index)),
                    ),
                  ),
                );
              },
              itemCount: _list.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        child: Image.asset(
          'images/mp3_ui_update.png',
          width: 40,
        ),
        onPressed: _onUpdateBtnTapped,
      ),
    );
  }
}

class _UpMenuBarWidget extends StatelessWidget {
  const _UpMenuBarWidget();

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
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: InkWell(
                    child: Image.asset(
                      'images/mp3_ui_music_shuffle_button.png',
                      width: 50,
                    ),
                  ))),
          Card(
              elevation: 4.0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: InkWell(
                    child: Image.asset(
                      'images/mp3_ui_google_drive_button.png',
                      width: 50,
                    ),
                  ))),
        ],
      ),
    );
  }
}