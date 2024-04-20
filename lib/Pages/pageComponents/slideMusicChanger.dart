import 'package:flutter/material.dart';

class SlideMusicChanger extends StatefulWidget {
  final List<Widget> slideWidgetList;
  final Function() rightSlidedCallback;
  final Function() leftSlidedCallback;

  const SlideMusicChanger({
    super.key, 
    required this.slideWidgetList,
    required this.rightSlidedCallback,
    required this.leftSlidedCallback
  });

  @override
  _SlideMusicChangerState createState() => _SlideMusicChangerState();
}

class _SlideMusicChangerState extends State<SlideMusicChanger> {
  Widget buildSlideWidget(){
    return GestureDetector();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanEnd: (details) {
        print("${details.velocity.pixelsPerSecond}");
      },
      child: Row(
        children: [
          for(var widget in widget.slideWidgetList) widget,
          SizedBox(width: 32,)
        ],
      ),
    );
  }
}