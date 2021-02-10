import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:rocket/RocketGame.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Flame.util.fullScreen();
  await Flame.util.setLandscape();

  Flame.images.loadAll(<String>[
    'rocket1P.png',
    'rocket2P.png',
    'background.png',
    'play.png',
    'pause.png',
    'restart.png',
    'blackhole.png',
    'whitehole.png',
    'meteorite_2.png',
    'meteorite_3.png',
    'sun.png',
  ]);

  runApp(GameWidget(game: RocketGame()));
}
