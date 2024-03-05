import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/setting/colors.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';

class LyricsFragment extends StatelessWidget{
  final StringConstants _string = StringConstants();
  final PictureConstants _picture = PictureConstants();
  final MyColors _colors = MyColors();

  final MusicPlayer _musicPlayer = MusicPlayer();
  late final String _lyrics;

  late final Function() _closeFragment;

  LyricsFragment({
    required Function() closeFragmentCallback
  }){
    _lyrics = _musicPlayer.currentMusic.lyrics;
    _closeFragment = closeFragmentCallback;
  }

  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: size.height * 0.1),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(64),
            topRight: Radius.circular(64),
          ),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Card(
              elevation: 256,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.008)),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              _picture.lyricsIconImg,
                              scale: 2,
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: size.width * 0.02)),
                            Text(
                              _string.lyrics,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                            child: IconButton(
                              onPressed: _closeFragment, 
                              icon: Icon(
                                Icons.close,
                                color: _colors.primaryBlue,
                                size: size.width * 0.13,
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.02)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: Text(_lyrics),
                      ),
                    ),
                  ],
                ),
              )
            ),
          )
        )
      )
    );
  }
}