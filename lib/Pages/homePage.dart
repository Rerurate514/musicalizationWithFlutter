import 'package:flutter/material.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoUpdater.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'dart:async';

import '../setting/string.dart';
import '../setting/picture.dart';

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
  final _picture = PictureConstants();

  final _audioPlayerManager = AudioPlayerManager();

  final recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final MusicInfoUpdater _musicInfoUpdater = MusicInfoUpdater();

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
    _audioPlayerManager.startMusic(musicNameArg, musicPathArg);
  }

  void _onUpdateBtnTapped(){
    setState(() {
      _list = [];
    });
    
    _musicInfoUpdater.updateDataBase();

    Future.delayed(const Duration(microseconds: 1000),() {
      setState(() {
        _list = recordFetcher.getAllReacordList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            _picture.mainModeImg,
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          _UpMenuBarWidget(),
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
                        _picture.musicRecordImg,
                        width: 50,
                      ),
                      title: Text(_list[index].name),
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
          _picture.updateImg,
          width: 40,
        ),
        onPressed: _onUpdateBtnTapped,
      ),
    );
  }
}

class _UpMenuBarWidget extends StatelessWidget {
  _UpMenuBarWidget();
  final _picture = PictureConstants();

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
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: InkWell(
                    child: Image.asset(
                      _picture.shuffleImg,
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
                      _picture.fetchingFromGoogleDriveImg,
                      width: 50,
                    ),
                  ))),
        ],
      ),
    );
  }
}