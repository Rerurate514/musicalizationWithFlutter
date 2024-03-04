import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/logic/pickImage.dart';
import 'package:musicalization/logic/pictureBinaryConverter.dart';
import 'package:musicalization/logic/realm/logic/musicInfo/musicInfoEditor.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:musicalization/setting/colors.dart';

class ImagePickFragment extends StatefulWidget {
  final Function() closeFragmentCallback;

  const ImagePickFragment({super.key, required this.closeFragmentCallback});

  @override
  _ImagePickFragmentState createState() => _ImagePickFragmentState();
}

class _ImagePickFragmentState extends State<ImagePickFragment> {
  final _color = MyColors();
  final _musicPlayer = MusicPlayer();
  final _globalKey = GlobalKey();
  final _converter = PictureBinaryConverter();
  final _picker = ImagePickerController();

  String _selectedPath = "";
  Matrix4 transform = Matrix4.identity();

  void _initValue(){
    transform = Matrix4.identity();
  }

  void _selectFile() async {
    XFile? file = await _picker.getImageFromGarally();
    _selectedPath = file?.path ?? "";
  }

  void _updatePicture(String newPictureBinary) async {
    final MusicInfo info = MusicInfo(
      _musicPlayer.currentMusic.id, 
      _musicPlayer.currentMusic.name,
      _musicPlayer.currentMusic.path,
      _musicPlayer.currentMusic.volume, 
      _musicPlayer.currentMusic.lyrics, 
      newPictureBinary
    );
    final MusicInfoEditor editer = MusicInfoEditor();
    editer.edit(newMusicInfoArg: info);
  }

  Future<void> _captureImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    String imageDataBinary = await _converter.convertBoundaryToImageBase64(boundary);
    _updatePicture(imageDataBinary);
 }

  Widget buildPicture(){
    return MatrixGestureDetector(
      onMatrixUpdate: (matrix, translationDeltaMatrix, scaleDeltaMatrix, rotationDeltaMatrix) {
        setState(() {
          transform = matrix;
        });
      },
      child: Transform(
        transform: transform,
        child: _selectedPath != ""
          ? Image.file(File(_selectedPath))
          : const SizedBox(height: 10,width: 10,),
      ),
    );
  }

  Widget _buildButton(IconData iconData, Function() onPressed){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        child: IconButton(
          icon: Icon(
            iconData,
            size: 40,
            color: _color.primaryBlue,
          ),
          onPressed: onPressed,
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container( 
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: size.height * 0.2),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.1),
            child: Column(
              children: [
                const Text("画像を選択して、ジャケットを決定する。"),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000)
                    ),
                    elevation: 16,
                    child: SizedBox(
                      width: size.width * 0.74,
                      height: size.height * 0.34,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: buildPicture(),
                        ),
                      ),
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(Icons.arrow_back, () => widget.closeFragmentCallback()),
                    _buildButton(Icons.file_download, () {
                      _selectFile();
                      _initValue();
                    }),
                    _buildButton(Icons.restart_alt, () => _initValue() ),
                    _buildButton(Icons.check, () async {
                      await _captureImage();
                      widget.closeFragmentCallback();
                    }),
                  ],
                )
              ],
            )
          ),
        ),
      )
    );
  }
}