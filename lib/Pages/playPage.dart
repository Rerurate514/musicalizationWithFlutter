import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/volumeControl.dart';
import 'dart:async';

import '../setting/string.dart';
import '../setting/colors.dart';
import '../setting/picture.dart';
import '../logic/musicPlayer.dart';

import 'pageComponents/musicSettingDrawer.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final _string = StringConstants();
  final _colors = MyColors();
  final _picture = PictureConstants();
  final _musicPlayer = MusicPlayer();
  final _musicButtonFuncs = _MusicButtonFuncs();
  final _musicButtonImageController = _MusicButtonImageController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _musicName = "null";
  String _listName = "";

  String _musicDurText = "null";
  String _musicCurText = "null";

  double _musicDuration = 100.0;
  double _musicCurrent = 0.0;

  bool _isShowVolumeSlider = false;

  @override
  void initState() {
    super.initState();
    _startLogic();

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _setMusicDurCur();
    });
  }

  Future<void> _startLogic() async {
    _setMusicNameAndListName();
    _setMusicDurCur();
    _musicPlayer.setOnMusicCompleteCallback(
        _musicButtonImageController.changePlayImage);

    if (_musicPlayer.isLooping) _setLoopingMode();
    if (_musicPlayer.isShuffling) _setShufflingMode();
  }

  void _setLoopingMode() {
    setState(() {
      _musicButtonImageController.changeModeImage();
    });
  }

  void _setShufflingMode() {
    setState(() {
      _musicButtonImageController.changeModeImage();
      _musicButtonImageController.changeModeImage();
    });
  }

  void _setMusicNameAndListName() {
    setState(() {
      _musicName = _musicPlayer.currentMusic.name;
      _listName = _musicPlayer.listName;
    });
  }

  void _setMusicDurCur() {
    if (mounted) {
      setState(() {
        _musicDuration = _musicPlayer.duration;
        _musicCurrent = _musicPlayer.current;
      });
    }

    _musicCurText = _musicCurrent.toInt().toString() + " s";
    _musicDurText = _musicDuration.toInt().toString() + " s";
  }

  void _onMusicBackButtonTapped() {
    _musicButtonFuncs.onMusicBackButtonTapped(
        _musicPlayer, _setMusicNameAndListName);
  }

  void _onPlayModeToggleButtonTapped() {
    setState(() {
      _musicButtonImageController.changeModeImage();
      _musicButtonFuncs.onPlayModeToggleButtonTapped(_musicPlayer);
    });
  }

  void _onMusicPlayingToggleButtonTapped() {
    setState(() {
      _musicButtonImageController.changePlayImage();
      _musicButtonFuncs.onMusicPlayingToggleButtonTapped(_musicPlayer);
    });
  }

  void _onVolumeChangeButtonTapped() {
    setState(() {
      _isShowVolumeSlider = !_isShowVolumeSlider;
      _musicButtonImageController.changeVolumeImage();
      _musicButtonFuncs.onVolumeChangeButtonTapped(_musicPlayer);
    });
  }

  void _onMusicNextButtonTapped() {
    _musicButtonFuncs.onMusicNextButtonTapped(
        _musicPlayer, _setMusicNameAndListName);
  }

  void _onFloatingBunttonTapped() {
    _openDrawer();
  }

  void _openDrawer() => _scaffoldKey.currentState!.openDrawer();
  void _closeDrawer() => _scaffoldKey.currentState!.closeDrawer();

  void _autoVolumeSettingItemTapped() {
    print("auto");
  }

  void _lyricsSettingItemTapped() {
    print("歌詞");
  }

  void _nameSettingItemTapped() {
    print("name");
  }

  void _pictureSettingItemTapped() {
    print("picture");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            _picture.playModeImg,
            width: 70,
          )
        ]),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Center(
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 25, bottom: 25),
                child: Text(
                  _listName,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                child: Text(
                  _musicName,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000)),
                  elevation: 16,
                  child: Image.asset(
                    _picture.musicRecordImg,
                    width: 325, //325 = 10
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_musicCurText),
                      const Text("   /   "),
                      Text(_musicDurText),
                    ],
                  ),
                  buildMusicCurrentSlider(),
                ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildMusicButton(
                    _musicButtonImageController.backBtnImage,
                    40,
                    _onMusicBackButtonTapped,
                  ),
                  buildMusicButton(
                    _musicButtonImageController.modeBtnImage,
                    50,
                    _onPlayModeToggleButtonTapped,
                  ),
                  buildMusicButton(
                    _musicButtonImageController.playBtnImage,
                     55,
                    _onMusicPlayingToggleButtonTapped,
                    16
                  ),
                  buildMusicButton(
                    _musicButtonImageController.volumeBtnImage,
                    50,
                    _onVolumeChangeButtonTapped,
                  ),
                  buildMusicButton(_musicButtonImageController.nextBtnImage, 40,
                      _onMusicNextButtonTapped),
                ]),
              ),
            ]),
          ),
          if(_isShowVolumeSlider) MusicVolumeContorlContainer(),
        ],
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: FloatingActionButton(
            onPressed: () => _onFloatingBunttonTapped(),
            backgroundColor: Theme.of(context).cardColor,
            child: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 44, 232, 245),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      drawer: MusisSettingDrawer({
        DrawerItemTappped.AUTOVOLUMESETTING: _autoVolumeSettingItemTapped,
        DrawerItemTappped.LYRICSSETTING: _lyricsSettingItemTapped,
        DrawerItemTappped.NAMESETTING: _nameSettingItemTapped,
        DrawerItemTappped.PICTURESETTING: _pictureSettingItemTapped,
      }),
    );
  }

  Widget buildMusicButton(
      String imagePathArg, double imageWidthArg, void Function() onTapped,
      [double paddingArg = 8.0]) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(1000),
            onTap: onTapped,
            child: Padding(
              padding: EdgeInsets.all(paddingArg),
              child: Image.asset(
                imagePathArg,
                width: imageWidthArg,
              ),
            ),
          ),
        ));
  }

  Widget buildMusicCurrentSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.0,
        activeTrackColor: Theme.of(context).splashColor,
        inactiveTrackColor: Theme.of(context).cardColor,
        thumbColor: _colors.primaryBlue,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayColor: Colors.blue,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
      ),
      child: Slider(
        value: _musicCurrent,
        onChanged: (currentValue) {
          setState(() {
            _musicCurrent = currentValue;
            _musicPlayer.seek(_musicCurrent);
          });
        },
        min: 0,
        max: _musicDuration,
      ),
    );
  }
}

class _MusicButtonImageController {
  final _picture = PictureConstants();

  late final String _backBtnImage;
  String get backBtnImage => _backBtnImage;

  late final List _playBtnImage;
  int _playBtnIndex = 0;
  String get playBtnImage => _playBtnImage[_playBtnIndex];

  late final List _modeBtnImage;
  int _modeBtnIndex = 0;
  String get modeBtnImage => _modeBtnImage[_modeBtnIndex];

  late final List _volumeBtnImage;
  int _volumeBtnIndex = 0;
  String get volumeBtnImage => _volumeBtnImage[_volumeBtnIndex];

  late final String _nextBtnImage;
  String get nextBtnImage => _nextBtnImage;

  _MusicButtonImageController() {
    _backBtnImage = _picture.backMusicBtnImg;
    _playBtnImage = [_picture.stopMusicBtnImg, _picture.playMusicBtnImg];
    _modeBtnImage = [
      _picture.loopOffMusicBtnImg,
      _picture.loopOnMusicBtnImg,
      _picture.shuffleImg
    ];
    _volumeBtnImage = [
      _picture.soundUnmuteOffMusicBtnImg,
      _picture.soundUnmuteOnMusicBtnImg
    ];
    _nextBtnImage = _picture.nextBtnMusicImg;
  }

  void changeModeImage() {
    _modeBtnIndex++;
    if (_modeBtnIndex == 3) _modeBtnIndex = 0;
  }

  void changePlayImage() {
    _playBtnIndex = (_playBtnIndex + 1) % _playBtnImage.length;
  }

  void changeVolumeImage() {
    _volumeBtnIndex = (_volumeBtnIndex + 1) % _volumeBtnImage.length;
  }
}

class _MusicButtonFuncs {
  void onMusicBackButtonTapped(
      MusicPlayer musicPlayerArg, Function() musicNameTextInitFuncArg) {
    musicPlayerArg.moveBackMusic();

    Function() musicNameTextInitFunc = musicNameTextInitFuncArg;
    musicNameTextInitFunc();
  }

  void onPlayModeToggleButtonTapped(MusicPlayer musicPlayerArg) {
    musicPlayerArg.toggleMusicPlayMode();
  }

  void onMusicPlayingToggleButtonTapped(MusicPlayer musicPlayerArg) {
    musicPlayerArg.togglePlaying();
  }

  void onVolumeChangeButtonTapped(MusicPlayer musicPlayerArg) {}

  void onMusicNextButtonTapped(
      MusicPlayer musicPlayerArg, Function() musicNameTextInitFuncArg) {
    musicPlayerArg.moveNextMusic();

    Function() musicNameTextInitFunc = musicNameTextInitFuncArg;
    musicNameTextInitFunc();
  }
}
