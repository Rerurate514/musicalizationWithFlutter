import 'package:flutter/material.dart';

import '../permission.dart';
import '../string.dart';
import '../fetchFile.dart';
import '../colors.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.title});
  final String title;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final _string = SetedString();
  final _colors = MyColors();

  String _musicName = "msuicName（仮）";
  String _listName = "listName（仮）";

  String _musicDurText = "3m 45s仮）";
  String _musicCurText = "1m 23s（仮）";

  double _musicDuration = 100.0;
  double _musicCurrent = 0.0;

  @override
  void initState() {
    super.initState();
    _startLogic();
  }

  Future<void> _startLogic() async {
    setState(() {});
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
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              _listName,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(
              _musicName,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000)),
              elevation: 16,
              child: Image.asset(
                'images/mp3_menu_picture_setting.png',
                width: 350,
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
              buildCardWithImage('images/mp3_ui_back_music.png', 40),
              buildCardWithImage('images/mp3_ui_loop_button_off.png', 50),
              buildCardWithImage('images/mp3_ui_music_stop_button.png', 60),
              buildCardWithImage(
                  'images/mp3_ui_sound_control_unmute_off.png', 50),
              buildCardWithImage('images/mp3_ui_next_music.png', 40),
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

  Widget buildCardWithImage(String imagePath, double imageWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              child: Image.asset(
                imagePath,
                width: imageWidth,
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

