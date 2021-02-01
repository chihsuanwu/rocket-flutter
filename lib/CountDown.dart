import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:rocket/RocketGame.dart';

class CountDown extends Component{

  bool _start = false;
  double _counter = 0;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  RocketGame _game;


  CountDown(RocketGame game) {
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

  void startCountDown() {
    _start = true;
  }

  @override
  void render(Canvas c) {
    painter.paint(c, position);
  }

  @override
  void update(double t) {
    if (!_start) return;

    _counter += t;
    if (_counter >= 2) {
      shouldRemove = true;

      _game.onGameStart();


      return;
    }

    String text = _counter >= 1 ? "START" : (-_counter + 3).ceil().toString();

    if ((painter.text ?? '') != text) {
      painter.text = TextSpan(
        text: text,
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (_game.screenSize.x / 2) - (painter.width / 2),
        (_game.screenSize.y * .25) - (painter.height / 2),
      );
    }
  }
}