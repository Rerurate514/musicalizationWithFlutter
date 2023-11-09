import 'package:flutter/material.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';

enum DrawerItemTappped {
  AUTOVOLUMESETTING,
  LYRICSSETTING,
  NAMESETTING,
  PICTURESETTING
}

class MusisSettingDrawer extends Drawer{
  final _string = StringConstants();
  final _picture = PictureConstants();

  late final Map<DrawerItemTappped, Function> _tappedFuncsMap;

  MusisSettingDrawer(this._tappedFuncsMap);

  Widget build(BuildContext cotext){
    return Drawer(
      child: Column(
        children: [
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemAutoVolumeSetting, 
            _picture.musicSettingDrawerItemAutoVolumeSettingImg,
            _tappedFuncsMap[DrawerItemTappped.AUTOVOLUMESETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemLyricsSetting, 
            _picture.musicSettingDrawerItemLyricsSettingImg,
            _tappedFuncsMap[DrawerItemTappped.LYRICSSETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemNameSetting, 
            _picture.musicSettingDrawerItemNameSettingImg,
            _tappedFuncsMap[DrawerItemTappped.NAMESETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemPictureSetting, 
            _picture.musicSettingDrawerItemPictureSettingImg,
            _tappedFuncsMap[DrawerItemTappped.PICTURESETTING]!
          ),
        ],
      ),
    );
  }
}

class _MusicSettingDrawerItems extends StatelessWidget{
  late final String _itemTitle;
  late final String _itemPicture;
  late final Function _onItemTappedFunc;

  _MusicSettingDrawerItems(this._itemTitle, this._itemPicture, this._onItemTappedFunc);

  Widget build(BuildContext contect){
    return Card(
      child: InkWell(
        onTap: () => _onItemTappedFunc,
        child: ListTile(
          leading: Image.asset(
            _itemPicture,
            width: 25,
          ),
          title: Text(_itemTitle),
        ),
      )
    );
  }
}
