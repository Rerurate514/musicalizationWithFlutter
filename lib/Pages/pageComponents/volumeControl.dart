import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:realm/realm.dart';

class MusicVolumeControlContainer extends StatefulWidget {
  final Function() closeFragment;

  MusicVolumeControlContainer({required this.closeFragment});

  @override
  State<StatefulWidget> createState() => _MusicVolumeControlContainerState();
}

class _MusicVolumeControlContainerState extends State<MusicVolumeControlContainer> {
  final _musicPlayer = MusicPlayer();
  final _recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final _picture = PictureConstants();
  final _colors = MyColors();

  int _initVolume = 40;
  int _value = 0;

  _MusicVolumeControlContainerState() {
    MusicInfo currentMusic = _musicPlayer.currentMusic;
    ObjectId musicId = currentMusic.id;

    try{
      if (currentMusic.name != "") _initVolume = _recordFetcher.getRecordFromId(musicId).volume;
    }
    catch(e){
      _initVolume = 40;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = _initVolume;
    });
  }

  void _onChangedSlider(double newVolume) {
    setState(() {
      _value = newVolume.toInt();
    });

    _musicPlayer.changeVolume(_value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      margin: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.bottomRight,
        child: buildContent(),
      )
    );
  }

  Widget buildContent(){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: 100,
        height: 410,
        child: Column(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2.0,
                  activeTrackColor: Theme.of(context).splashColor,
                  inactiveTrackColor: Theme.of(context).cardColor,
                  thumbColor: _colors.primaryBlue,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  overlayColor: Colors.blue,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, //bottom
                      right: 16 //top
                  ),
                  child: Slider(
                    value: _value.toDouble(),
                    onChanged: (newVolume) => _onChangedSlider(newVolume),
                    max: 100,
                    min: 0,
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              child: Text("$_value"),
            ),
            Image.asset(_picture.soundUnmuteOnMusicBtnImg, width: 64),
            Card(
              margin: const EdgeInsets.all(20),
              color: _colors.primaryBlue,
              child: InkWell(
                onTap: widget.closeFragment,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ),
            )
          ]
        ),
      )
    );
  }
}
