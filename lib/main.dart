import 'package:flutter/material.dart';

import 'Pages/homePage.dart';
import 'Pages/listPage.dart';
import 'Pages/playPage.dart';
import 'Pages/settingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText2: const TextStyle(
                fontFamily: 'NotoSansJP',
                color: Colors.white,
              ),
            ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  late PageController _pageController;

  int _selecetedIndex = 0;

  final _pages = [
    const HomePage(title: "Home"),
    const ListPage(title: "List"),
    const PlayPage(title: "Play"),
    const SettingPage(title: "Setting"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selecetedIndex);
  }

  @override
	void dispose(){
		super.dispose();
		_pageController.dispose();
	}

  void _onPageChanged(int indexArg){
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
        // onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/mp3_ui_home.png',
              width: 35,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/mp3_ui_list.png',
              width: 25,
            ),
            label: "Music List"
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/mp3_ui_play_button.png',
              width: 23,
            ),
            label: "Music Play"
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/mp3_ui_setting_button.png',
              width: 20,
            ),
            label: "Setting"
          ),
        ],
        selectedItemColor: Colors.white,
        currentIndex: _selecetedIndex,
        onTap: _onPageChanged,
      ),
    );
  }
}


