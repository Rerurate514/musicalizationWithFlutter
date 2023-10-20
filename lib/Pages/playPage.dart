import 'package:flutter/material.dart';
import 'dart:async';

import '../setting/string.dart';
import '../setting/colors.dart';
import '../setting/picture.dart';
import '../logic/audioPlayerManager.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.title});
  final String title;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final _string = StringConstants();
  final _colors = MyColors();
  final _picture = PictureConstants();
  final audioPlayerManager = AudioPlayerManager();
  final musicButtonFuncs = _MusicButtonFuncs();
  final musicButtonImageController = _MusicButtonImageController();

  String _musicName = "null";
  String _listName = "listName";

  String _musicDurText = "null";
  String _musicCurText = "null";

  double _musicDuration = 100.0;
  double _musicCurrent = 0.0;

  @override
  void initState() {
    super.initState();
    _startLogic();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _setMusicDurCur();
    });
  }

  Future<void> _startLogic() async {
    _setMusicName();
    _setMusicDurCur();
  }

  void _setMusicName() {
    setState(() {
      _musicName = audioPlayerManager.musicName;
    });
  }

  void _setMusicDurCur() {
    if (mounted) {
      setState(() {
        _musicDuration = audioPlayerManager.musicDuration;
        _musicCurrent = audioPlayerManager.musicCurrent;
      });
    }

    _musicCurText = _musicCurrent.toInt().toString() + " s";
    _musicDurText = _musicDuration.toInt().toString() + " s";
  }

  void _onMusicBackButtonTapped() {
    musicButtonFuncs.onMusicBackButtonTapped(_setMusicName);
  }

  void _onPlayModeToggleButtonTapped() {
    setState(() {
      musicButtonImageController.changeModeImage();
      musicButtonFuncs.onPlayModeToggleButtonTapped();
    });
  }

  void _onMusicPlayingToggleButtonTapped() {
    setState(() {
      musicButtonImageController.changePlayImage();
      musicButtonFuncs.onMusicPlayingToggleButtonTapped();
    });
  }

  void _onVolumeChangeButtonTapped() {
    setState(() {
      musicButtonImageController.changeVolumeImage();
      musicButtonFuncs.onVolumeChangeButtonTapped();
    });
  }

  void _onMusicNextButtonTapped() {
    musicButtonFuncs.onMusicNextButtonTapped(_setMusicName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
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
                width: 10,//325
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildMusicButton(
                musicButtonImageController.backBtnImage,
                40,
                _onMusicBackButtonTapped,
              ),
              buildMusicButton(
                musicButtonImageController.modeBtnImage,
                50,
                _onPlayModeToggleButtonTapped,
              ),
              buildMusicButton(musicButtonImageController.playBtnImage, 55,
                  _onMusicPlayingToggleButtonTapped, 16),
              buildMusicButton(
                musicButtonImageController.volumeBtnImage,
                50,
                _onVolumeChangeButtonTapped,
              ),
              buildMusicButton(musicButtonImageController.nextBtnImage, 40,
                  _onMusicNextButtonTapped),
            ]),
          ),
        ]),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Theme.of(context).cardColor,
            child: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 44, 232, 245),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
            audioPlayerManager.seekMusic(_musicCurrent);
          });
        },
        min: 0,
        max: _musicDuration,
      ),
    );
  }
}

class _MusicButtonImageController {
  final audioPlayerManager = AudioPlayerManager();
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

  _MusicButtonImageController(){
    _backBtnImage = _picture.backMusicBtnImg;
    _playBtnImage = [_picture.stopMusicBtnImg, _picture.playMusicBtnImg];
    _modeBtnImage = [_picture.loopOffMusicBtnImg, _picture.loopOnMusicBtnImg, _picture.shuffleImg];
    _volumeBtnImage = [_picture.soundUnmuteOffMusicBtnImg, _picture.soundUnmuteOnMusicBtnImg];
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
  final _audioPlayerManager = AudioPlayerManager();

  void onMusicBackButtonTapped(Function() musicNameTextInitFuncArg) {
    _audioPlayerManager.moveBackMusic();

    Function() musicNameTextInitFunc = musicNameTextInitFuncArg;
    musicNameTextInitFunc();
  }

  void onPlayModeToggleButtonTapped() {
    _audioPlayerManager.toggleMusicMode();
  }

  void onMusicPlayingToggleButtonTapped() {
    _audioPlayerManager.togglePlayMusic();
  }

  void onVolumeChangeButtonTapped() {}

  void onMusicNextButtonTapped(Function() musicNameTextInitFuncArg) {
    _audioPlayerManager.moveNextMusic();
    
    Function() musicNameTextInitFunc = musicNameTextInitFuncArg;
    musicNameTextInitFunc();
  }
}
