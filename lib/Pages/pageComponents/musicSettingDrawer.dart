import 'package:flutter/material.dart';
import 'package:musicalization/setting/picture.dart';
import 'package:musicalization/setting/string.dart';

enum DrawerItemTappped {
  AUTO_VOLUME_SETTING,
  LYRICS_SETTING,
  NAME_SETTING,
  PICTURE_SETTING
}

class MusisSettingDrawer extends Drawer{
  final _string = StringConstants();
  final _picture = PictureConstants();

  late final Map<DrawerItemTappped, Function> _tappedFuncsMap;

  MusisSettingDrawer(this._tappedFuncsMap);

  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Image.asset(
                  _picture.settingModeImg,
                  width: size.width * 0.07,
                ),
              ),
              Text(
                _string.musicSettingStr,
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemAutoVolumeSetting, 
            _picture.musicSettingDrawerItemAutoVolumeSettingImg,
            _tappedFuncsMap[DrawerItemTappped.AUTO_VOLUME_SETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemLyricsSetting, 
            _picture.musicSettingDrawerItemLyricsSettingImg,
            _tappedFuncsMap[DrawerItemTappped.LYRICS_SETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemNameSetting, 
            _picture.musicSettingDrawerItemNameSettingImg,
            _tappedFuncsMap[DrawerItemTappped.NAME_SETTING]!
          ),
          _MusicSettingDrawerItems(
            _string.musicSettingDrawerItemPictureSetting, 
            _picture.musicSettingDrawerItemPictureSettingImg,
            _tappedFuncsMap[DrawerItemTappped.PICTURE_SETTING]!
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
        onTap: () => _onItemTappedFunc(),
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
