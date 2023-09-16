import 'package:flutter/material.dart';
import 'dart:async';

import '../setting/string.dart';
import '../setting/colors.dart';
import '../audioPlayerManager.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.title});
  final String title;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final _string = SetedString();
  final _colors = MyColors();
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

  void _setMusicName(){
    setState(() {
      _musicName = audioPlayerManager.musicName;
    });
  }

  void _setMusicDurCur(){
    if(mounted){
      setState(() {
        _musicDuration = audioPlayerManager.musicDuration;
        _musicCurrent = audioPlayerManager.musicCurrent;
      });
    }

    _musicCurText = _musicCurrent.toInt().toString() + " s";
    _musicDurText = _musicDuration.toInt().toString() + " s";
  }

  void _onMusicBackButtonTapped() {
    musicButtonFuncs.onMusicBackButtonTapped();
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
    musicButtonFuncs.onMusicNextButtonTapped();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            'images/mp3_ui_music_mode.png',
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
                'images/mp3_menu_picture_setting.png',
                width: 325,
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
              buildSlider(),
            ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCardWithImage(
                musicButtonImageController.backBtnImage, 
                40, 
                _onMusicBackButtonTapped,
              ),
              buildCardWithImage(
                musicButtonImageController.modeBtnImage, 
                50,
                _onPlayModeToggleButtonTapped,
              ),
              buildCardWithImage(
                musicButtonImageController.playBtnImage, 
                55,
                _onMusicPlayingToggleButtonTapped,
                16
              ),
              buildCardWithImage(
                musicButtonImageController.volumeBtnImage,
                50, 
                _onVolumeChangeButtonTapped,
              ),
              buildCardWithImage(
                musicButtonImageController.nextBtnImage,
                40,
                _onMusicNextButtonTapped
              ),
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

  Widget buildCardWithImage(
      String imagePathArg, double imageWidthArg, void Function() onTapped,
      [double paddingArg = 8.0]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(paddingArg),
            child: InkWell(
              onTap: onTapped,
              child: Image.asset(
                imagePathArg,
                width: imageWidthArg,
              ),
            ),
          )),
    );
  }

  Widget buildSlider() {
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



class _MusicButtonImageController{
  final audioPlayerManager = AudioPlayerManager();

  String _backBtnImage = 'images/mp3_ui_back_music.png';
  String get backBtnImage => _backBtnImage;

  List _playBtnImage = ['images/mp3_ui_music_stop_button.png','images/mp3_ui_play_button.png'];
  int _playBtnIndex = 0;
  String get playBtnImage => _playBtnImage[_playBtnIndex];

  List _modeBtnImage = [
    'images/mp3_ui_loop_button_off.png',
    'images/mp3_ui_loop_button_on.png'
    ,'images/mp3_ui_music_shuffle_button.png'
  ];
  int _modeBtnIndex = 0;
  String get modeBtnImage => _modeBtnImage[_modeBtnIndex];

  List _volumeBtnImage = [
    'images/mp3_ui_sound_control_unmute_off.png',
    'images/mp3_ui_sound_control_unmute_on.png',
  ];
  int _volumeBtnIndex = 0;
  String get volumeBtnImage => _volumeBtnImage[_volumeBtnIndex];

  String _nextBtnImage = 'images/mp3_ui_next_music.png';
  String get nextBtnImage => _nextBtnImage;

  void changeModeImage(){
    _modeBtnIndex++;
    if(_modeBtnIndex == 3) _modeBtnIndex = 0;
  }


  void changePlayImage(){
    _playBtnIndex = (_playBtnIndex + 1) % _playBtnImage.length;
  }


  void changeVolumeImage(){
    _volumeBtnIndex = (_volumeBtnIndex + 1) % _volumeBtnImage.length;
  }
}

class _MusicButtonFuncs{
  final audioPlayerManager = AudioPlayerManager();
  

  void onMusicBackButtonTapped() {

  }

  void onPlayModeToggleButtonTapped() {

  }

  void onMusicPlayingToggleButtonTapped() {

    audioPlayerManager.togglePlayMusic();
  }


  void onVolumeChangeButtonTapped() {

  }

  void onMusicNextButtonTapped() {

  }
}