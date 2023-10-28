import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:musicalization/logic/musicPlayer.dart';
import 'package:musicalization/setting/picture.dart';

import 'Pages/homePage.dart';
import 'Pages/listPage.dart';
import 'Pages/playPage.dart';
import 'Pages/settingPage.dart';

import 'logic/permission.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'musicalization',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: const TextStyle(
                fontFamily: 'NotoSansJP',
                color: Colors.white,
              ),
            ),
      ),
      home: const MyHomePage(title: 'musicalization Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _musicPlayer = MusicPlayer();

  final _picture = PictureConstants();
  final _permissionRequester = MediaAudioPermissionRequester();
  late PageController _pageController;

  int _selecetedIndex = 0;

  late final _pages;

  late final Map<String, Function()> _movePageFuncsMap = HashMap();

  @override
  void initState() {
    super.initState();
    _permissionRequester.requestPermission();
    _pageController = PageController(initialPage: _selecetedIndex);

    _movePageFuncsMap.addAll({
      'Home': moveHomePageCallback,
      'List': moveListPageCallback,
      'Play': movePlayPageCallback,
      'Setting': moveSettingPageCallback
    });

    _pages = [
      HomePage(movePageFuncsMap: _movePageFuncsMap),
      ListPage(movePageFuncsMap: _movePageFuncsMap),
      const PlayPage(),
      const SettingPage(),
    ];
  }

  @override
  void dispose() {
    _musicPlayer.destroy();
    _pageController.dispose();
    super.dispose();
  }

  void moveHomePageCallback(){
    _onPageChanged(0);
  }

  void moveListPageCallback(){
    _onPageChanged(1);
  }

  void movePlayPageCallback(){
    _onPageChanged(2);
  }

  void moveSettingPageCallback(){
    _onPageChanged(3);
  }

  void _onPageChanged(int indexArg) {
    setState(() {
      _selecetedIndex = indexArg;
      _pageController.animateToPage(
        indexArg,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _picture.homeImg,
              width: 35,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Image.asset(
                _picture.listImg,
                width: 25,
              ),
              label: "Music List"),
          BottomNavigationBarItem(
              icon: Image.asset(
                _picture.playMusicBtnImg,
                width: 23,
              ),
              label: "Music Play"),
          BottomNavigationBarItem(
              icon: Image.asset(
                _picture.settingModeImg,
                width: 20,
              ),
              label: "Setting"),
        ],
        selectedItemColor: Colors.white,
        currentIndex: _selecetedIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}
