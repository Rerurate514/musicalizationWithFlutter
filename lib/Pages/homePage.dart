import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/upMenuBarWidget.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/musicSettingSyncer.dart';
import 'package:musicalization/logic/pictureBinaryConverter.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoUpdater.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'dart:async';
import 'dart:math' as math;

import '../setting/string.dart';
import '../setting/picture.dart';

import '../logic/realm/logic/recordFetcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.movePageFuncsMap});

  final Map<String, Function()> movePageFuncsMap;

  @override
  State<HomePage> createState() =>
      _HomePageState(movePageFuncsMapArg: movePageFuncsMap);
}

class _HomePageState extends State<HomePage> {
  final _string = StringConstants();
  final _picture = PictureConstants();

  final recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final MusicInfoUpdater _musicInfoUpdater = MusicInfoUpdater();

  final ScrollController _scrollController = ScrollController();
  final PictureBinaryConverter _converter = PictureBinaryConverter();

  List<MusicInfo> _listInMusicInfo = [];

  late final MusicPlayer _musicPlayer;
  late final Map<String, Function()> _movePageFuncsMap;

  _HomePageState({required Map<String, Function()> movePageFuncsMapArg}) {
    _movePageFuncsMap = movePageFuncsMapArg;
  }

  @override
  void initState() {
    super.initState();
    _initFileFetcher();
  }

  Future<void> _initFileFetcher() async {
    setState(() {
      _listInMusicInfo = recordFetcher.getAllReacordList();
    });
  }

  void _playMusic(int listInMusicInfoIndexArg, {required bool isShufflingArg}) {
    _musicPlayer = MusicPlayer(_listInMusicInfo, listInMusicInfoIndexArg);
    if (isShufflingArg) {
      _musicPlayer.toggleMusicPlayMode();
      _musicPlayer.toggleMusicPlayMode();
    }

    _musicPlayer.start();

    final settingSyncer = MusicSettingSyncer();
    settingSyncer.syncAllSetting();

    Function() movePageCallback = _movePageFuncsMap['Play']!;
    movePageCallback();
  }

  Future<void> _onListItemTapped(int listInMusicInfoIndexArg) async {
    _musicPlayer = MusicPlayer(_listInMusicInfo, listInMusicInfoIndexArg);

    _musicPlayer.start();

    Function() movePageCallback = _movePageFuncsMap['Play']!;
    movePageCallback();
  }

  void _onUpdateBtnTapped() {
    setState(() {
      _listInMusicInfo = [];
    });

    _musicInfoUpdater.updateDataBase();

    Future.delayed(const Duration(microseconds: 1000), () {
      setState(() {
        _listInMusicInfo = recordFetcher.getAllReacordList();
      });
    });
  }

  void _onShuffleBtnTappedCallback() {
    var random = math.Random();

    int listInMusicInfoIndex = random.nextInt(_listInMusicInfo.length);
    _playMusic(listInMusicInfoIndex, isShufflingArg: true);
  }

  void _onFetchFileFromGoogleDriveBtnTappedCallback() {}

  Widget _buildMusicPicture(MusicInfo info) {
    ImageProvider image = _converter.convertBase64ToImage(info.picture);
    return CircleAvatar(
      foregroundImage: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_string.appNameStr),
            const Spacer(),
            Image.asset(
              _picture.homeModeImg,
              width: 70,
            )
          ]
        ),
      ),
      body: Column(
        children: [
          UpMenuBarWidget(
              centralBtnSettingArg: ButtonSetting<Function()>(_picture.shuffleImg, _onShuffleBtnTappedCallback),
              rightBtnSettingArg: ButtonSetting<Function()>(_picture.fetchingFromGoogleDriveImg, _onFetchFileFromGoogleDriveBtnTappedCallback)),
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
                      leading: _listInMusicInfo[index].picture != ""
                        ? _buildMusicPicture(_listInMusicInfo[index])
                        : Image.asset(
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
