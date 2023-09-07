import 'package:flutter/material.dart';
import 'dart:async';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';
import '../colors.dart';
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

  String _musicName = "";
  String _listName = "list";

  String _musicDurText = "duration";
  String _musicCurText = "current";

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

  void _setMusicDurCur(){
    setState(() {
      _musicDuration = audioPlayerManager.musicDuration;
      _musicCurrent = audioPlayerManager.musicCurrent;
    });
  }

  void _setMusicName(){
    setState(() {
      _musicName = audioPlayerManager.musicName;
    });
  }

  void _onMusicBackButtonTapped() {}

  void _onPlayModeToggleButtonTapped() {}

  void _onMusicPlayingToggleButtonTapped() {}

  void _onVolumeChangeButtonTapped() {}

  void _onMusicNextButtonTapped() {}

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
                  const Text(" / "),
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
                  'images/mp3_ui_back_music.png', 40, _onMusicBackButtonTapped),
              buildCardWithImage('images/mp3_ui_loop_button_off.png', 50,
                  _onPlayModeToggleButtonTapped),
              buildCardWithImage('images/mp3_ui_music_stop_button.png', 55,
                  _onMusicPlayingToggleButtonTapped, 16),
              buildCardWithImage('images/mp3_ui_sound_control_unmute_off.png',
                  50, _onVolumeChangeButtonTapped),
              buildCardWithImage(
                  'images/mp3_ui_next_music.png', 40, _onMusicNextButtonTapped),
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
          });
        },
        min: 0,
        max: _musicDuration,
      ),
    );
  }
}
