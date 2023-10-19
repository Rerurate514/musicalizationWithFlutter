import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/inListPageComponent.dart';
import 'package:musicalization/Pages/pageComponents/listPageComponents.dart';
import 'package:musicalization/logic/realm/model/schema.dart';

import '../setting/string.dart';
import '../setting/picture.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _string = StringConstants();
  final _picture = PictureConstants();

  bool _isListSelected = false;

  late MusicList _selectedMusicList; 

  @override
  void initState() {
    super.initState();
  }

  void _toggleListSelectedCallback() {
    setState(() {
      _isListSelected = !_isListSelected;
    });
  }

  void _setSelectedListCallback(MusicList listArg){
    _selectedMusicList = listArg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(_string.appNameStr),
            const Spacer(),
            Image.asset(
              _picture.listModeImg,
              width: 70,
            )
          ]),
        ),
        body: _isListSelected 
        ? InListPageComponent(toggleListSelectedCallback: _toggleListSelectedCallback, musicList: _selectedMusicList)
        :ListPageComponent(toggleListSelectedCallback: _toggleListSelectedCallback,  setSelectedListCallback: _setSelectedListCallback));
  }
}
