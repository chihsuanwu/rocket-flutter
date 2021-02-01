import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rocket/RocketGame.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Flame.util.fullScreen();
  Flame.util.setLandscape();

  Flame.images.loadAll(<String>[
    'rocket1P.png',
    'rocket2P.png',
    'background.png',
    'play.png',
    'pause.png',
    'restart.png',
    'blackhole.png',
    'whitehole.png'
  ]);

  runApp(GameWidget(game: RocketGame()));
}
