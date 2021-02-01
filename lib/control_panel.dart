import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:rocket/RocketGame.dart';

class ControlPanel extends Component{

  bool _start = false;
  double _counter = 0;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  RocketGame _game;

  ControlPanel(RocketGame game) {
    _game = game;

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
        color: Color(0xFFDE0000),
        fontSize: 90
      // shadows: [
      //   Shadow(
      //     blurRadius: 7,
      //     color: Color(0xff000000),
      //     offset: Offset(3, 3),
      //   ),
      // ],
    );

    position = Offset.zero;
  }

  @override
  void render(Canvas c) {

  }

  @override
  void update(double t) {

  }
}