import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/upMenuBarWidget.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoUpdater.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'dart:async';

import '../setting/string.dart';
import '../setting/picture.dart';

import '../logic/audioPlayerManager.dart';

import '../logic/realm/logic/recordFetcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.movePageFuncsMap});

  final Map<String, Function()> movePageFuncsMap;

  @override
  State<HomePage> createState() => _HomePageState(movePageFuncsMapArg: movePageFuncsMap);
}

class _HomePageState extends State<HomePage> {
  final _string = StringConstants();
  final _picture = PictureConstants();

  final _audioPlayerManager = AudioPlayerManager();

  final recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final MusicInfoUpdater _musicInfoUpdater = MusicInfoUpdater();

  final ScrollController _scrollController = ScrollController();

  List<MusicInfo> _listInMusicInfo = [];

  late final Map<String, Function()> _movePageFuncsMap;

  _HomePageState({required Map<String, Function()> movePageFuncsMapArg}){
    _movePageFuncsMap = movePageFuncsMapArg;
  } 

  @override
  void initState() {
    super.initState();
    _initFileFetcher();
  }

  Future<void> _initFileFetcher() async {
    setState((){
      _listInMusicInfo = recordFetcher.getAllReacordList();
    });
  }

  Future<void> _onListItemTapped(int musicListIndexArg) async {
    await _audioPlayerManager.setMusicList(_listInMusicInfo, musicListIndexArg);
    await _audioPlayerManager.startMusic();

    Function() movePageCallback = _movePageFuncsMap['Play']!;
    movePageCallback();
  }

  void _onUpdateBtnTapped(){
    setState(() {
      _listInMusicInfo = [];
    });
    
    _musicInfoUpdater.updateDataBase();

    Future.delayed(const Duration(microseconds: 1000),() {
      setState(() {
        _listInMusicInfo = recordFetcher.getAllReacordList();
      });
    });
  }

  void _onShuffleBtnTappedCallback(){

  }

  void _onFetchFileFromGoogleDriveBtnTappedCallback(){}

  

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
          UpMenuBarWidget(
            centralBtnSettingArg: ButtonSetting<Function()>(_picture.shuffleImg, _onShuffleBtnTappedCallback), 
            rightBtnSettingArg: ButtonSetting<Function()>(_picture.fetchingFromGoogleDriveImg, _onFetchFileFromGoogleDriveBtnTappedCallback)
          ),
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
                    onTap: () => _onListItemTapped(index),
                    child: ListTile(
                      leading: Image.asset(
                        _picture.musicRecordImg,
                        width: 50,
                      ),
                      title: Text(_listInMusicInfo[index].name),
                    ),
                  ),
                );
              },
              itemCount: _listInMusicInfo.length,
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