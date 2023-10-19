import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/upMenuBarWidget.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/picture.dart';

class InListPageComponent extends StatefulWidget {
  late final Function() toggleListSelectedCallback;
  late final MusicList musicList;

  InListPageComponent(
      {required Function() this.toggleListSelectedCallback,
      required MusicList this.musicList});

  @override
  InListPageComponentState createState() =>
      InListPageComponentState(toggleListSelectedCallback, musicList);
}

class InListPageComponentState extends State<InListPageComponent> {
  final _picture = PictureConstants();
  final _musicInfoRecordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);

  late final MusicList _musicList;
  final List<MusicInfo> _listInMusicInfo = [];

  late final Function() _toggleListSelectedCallback;

  InListPageComponentState(
      Function() toggleListSelectedCallbackArg, MusicList listArg) {
    _toggleListSelectedCallback = toggleListSelectedCallbackArg;
    _musicList = listArg;
  }

  @override
  void initState() {
    super.initState();
    _initListFetcher();
  }

  Future<void> _initListFetcher() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      if(!mounted) return;
      _fetchMusicInfoFromMusicList();
    });
  }

  void _fetchMusicInfoFromMusicList() {
    for (var musicIdArg in _musicList.list) {
      setState(() {
        _listInMusicInfo.add(_musicInfoRecordFetcher.getRecordFromId(musicIdArg));
      });
    }
  }

  void _onShuffleBtnTappedCallback() {}

  void _onResisterMusicBtnTappedCallback() {}

  void _onMusicBtnTappedCallback(MusicInfo infoArg) {}

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Column(
        children: [
          UpMenuBarWidget(
              centralBtnSettingArg: ButtonSetting<Function()>(
                  _picture.shuffleImg, _onShuffleBtnTappedCallback),
              rightBtnSettingArg: ButtonSetting<Function()>(
                  _picture.resisterMusicImg, _onResisterMusicBtnTappedCallback)),
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
                          _onMusicBtnTappedCallback(_listInMusicInfo[index]),
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
