import 'package:flutter/material.dart';

import '../logic/permission.dart';
import '../setting/string.dart';
import '../logic/fetchFile.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});
  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final _string = SetedString();

  final _list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(_string.appNameStr),
          const Spacer(),
          Image.asset(
            'images/mp3_ui_list_mode.png',
            width: 70,
          )
        ]),
      ),
      body: Column(
        children: [
          const _UpMenuBarWidget(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    leading: Image.asset(
                      'images/mp3_menu_picture_setting.png',
                      width: 50,
                    ),
                    title: Text(_list[index]),
                  ),
                );
              },
              itemCount: _list.length,
            ),
          )
        ],
      ),
    );
  }
}

class _UpMenuBarWidget extends StatelessWidget {
  const _UpMenuBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            'images/mp3_ui_mp3player_letters.png',
            width: 80,
          ),
          Card(
              elevation: 4.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Image.asset(
                  'images/mp3_ui_music_shuffle_button.png',
                  width: 50,
                ),
              )),
          Card(
              elevation: 4.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Image.asset(
                  'images/mp3_ui_list_make.png',
                  width: 50,
                ),
              )),
        ],
      ),
    );
  }
}
