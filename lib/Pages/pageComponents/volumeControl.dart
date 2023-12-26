import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:realm/realm.dart';

class MusicVolumeContorlContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MusicVolumeContorlContainerState();
}

class _MusicVolumeContorlContainerState
    extends State<MusicVolumeContorlContainer> {
  final _musicPlayer = MusicPlayer();
  final _recordFetcher = RecordFetcher<MusicInfo>(MusicInfo.schema);
  final _picture = PictureConstants();
  final _colors = MyColors();

  int _initVolume = 40;
  int _value = 0;

  _MusicVolumeContorlContainerState() {
    MusicInfo currentMusic = _musicPlayer.currentMusic;
    ObjectId musicId = currentMusic.id;

    if (currentMusic.name != "")
      _initVolume = _recordFetcher.getRecordFromId(musicId).volume;
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
    return Container(
        margin: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(alignment: Alignment.bottomRight, children: [
            Container(
              width: 100,
              height: 350,
              child: Column(children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      activeTrackColor: Theme.of(context).splashColor,
                      inactiveTrackColor: Theme.of(context).cardColor,
                      thumbColor: _colors.primaryBlue,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayColor: Colors.blue,
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,//bottom
                        right: 16//top
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
                  padding: const  EdgeInsets.only(
                    top: 8,
                    bottom: 32 
                  ),
                  child: Text("$_value"),
                ),
                Image.asset(
                  _picture.soundUnmuteOnMusicBtnImg,
                  width: 64
                ),
              ]),
            )
          ]),
        ));
  }
}
