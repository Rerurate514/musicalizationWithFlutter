import 'package:flutter/material.dart';
import 'package:musicalization/Pages/pageComponents/inListPageComponent.dart';
import 'package:musicalization/Pages/pageComponents/listPageComponents.dart';
import 'package:musicalization/logic/realm/model/schema.dart';

import '../setting/string.dart';
import '../setting/picture.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.movePageFuncsMap});

  final Map<String, Function()> movePageFuncsMap;

  @override
  State<ListPage> createState() => _ListPageState(movePageFuncsMapArg: movePageFuncsMap);
}

class _ListPageState extends State<ListPage> {
  final _string = StringConstants();
  final _picture = PictureConstants();

  bool _isListSelected = false;

  late MusicList _selectedMusicList; 

  late final Map<String, Function()> _movePageFuncsMap;

  _ListPageState({required Map<String, Function()> movePageFuncsMapArg}){
    _movePageFuncsMap = movePageFuncsMapArg;
  } 


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

  void movePlayPageCallback(){
    Function() movePageCallback = _movePageFuncsMap['Play']!;
    movePageCallback();
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
        ? InListPageComponent(musicList: _selectedMusicList, toggleListSelectedCallback: _toggleListSelectedCallback, movePlayPageCallback: movePlayPageCallback)
        :ListPageComponent(toggleListSelectedCallback: _toggleListSelectedCallback,  setSelectedListCallback: _setSelectedListCallback));
  }
}

