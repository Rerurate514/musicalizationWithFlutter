import 'package:flutter/material.dart';
import 'package:musicalization/logic/realm/logic/musicList/musicListController.dart';
import 'package:musicalization/logic/realm/logic/recordFetcher.dart';
import 'package:musicalization/logic/realm/model/schema.dart';
import 'package:realm/realm.dart';

import '../../setting/string.dart';
import '../../setting/picture.dart';

class ListPageComponent extends StatefulWidget{
  late final List<MusicList> listInMusicList;
  late final Function(MusicList) onListBtnTappedCallback;
  late final Function(ObjectId) onDeleteListBtnTappedCallback;

  ListPageComponent({
    required this.listInMusicList,
    required this.onListBtnTappedCallback,
    required this.onDeleteListBtnTappedCallback,
  });

  State<ListPageComponent> createState() => ListPageComponentState(
    listInMusicList,
    onListBtnTappedCallback,
    onDeleteListBtnTappedCallback,
  );
}

class ListPageComponentState extends State<ListPageComponent>{
  final _picture = PictureConstants();

  late final List<MusicList> _listInMusicList;
  late final Function(MusicList) _onListBtnTappedCallback;
  late final Function(ObjectId) _onDeleteListBtnTappedCallback;

  ListPageComponentState(
    List<MusicList> listArg,
    Function(MusicList) onListBtnTappedCallbackArg,
    Function(ObjectId) onDeleteListBtnTappedCallbackArg
  ){
    _listInMusicList = listArg;
    _onListBtnTappedCallback = onListBtnTappedCallbackArg;
    _onDeleteListBtnTappedCallback = onDeleteListBtnTappedCallbackArg;
  }

  @override
  void initState(){

  }

  @override
  Widget build(BuildContext context){
    return(
      Scaffold(
        body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 4.0,
                    child: InkWell(
                      onTap: () => _onListBtnTappedCallback(_listInMusicList[index]),
                      child: ListTile(
                          leading: Image.asset(
                            _picture.listImg,
                            width: 50,
                          ),
                          title: Text(_listInMusicList[index].name),
                          trailing: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 4.0,
                            child: InkWell(
                              onTap: () => _onDeleteListBtnTappedCallback(
                                  _listInMusicList[index].id),
                              child: Image.asset(
                                _picture.deleteListImg,
                                width: 40,
                              ),
                            ),
                          )),
                    ));
              },
              itemCount: _listInMusicList.length,
            ),
      )
    );
  }
}