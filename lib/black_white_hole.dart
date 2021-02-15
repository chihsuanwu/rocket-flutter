
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

import 'RocketGame.dart';

abstract class BWHole extends CircleElement {
  static const double RADIUS = 1.6;

  BWHole(RocketGame game, ElementManager manager, Vector2 position, ui.Image image, ELEMENT element) : super(
      game,
      manager,
      position,
      RADIUS,
      image,
      element);

  @override
  int get priority => 2;
}

class BlackHole extends BWHole {

  BlackHole(RocketGame game, ElementManager manager, Vector2 position) : super(
      game,
      manager,
      position,
      game.blackHoleImage,
      ELEMENT.BLACK_HOLE);

  @override
  void update(double dt) {
    super.update(dt);

    contactBullets.forEach((element) {
      final gravityVector = center - element.center;
      final value = min(2 / gravityVector.length2, 120.0);
      element.body.applyForce(gravityVector * value);
    });
  }
}

class WhiteHole extends BWHole {

  WhiteHole(RocketGame game, ElementManager manager, Vector2 position) : super(
      game,
      manager,
      position,
      game.whiteHoleImage,
      ELEMENT.WHITE_HOLE);

  @override
  void update(double dt) {
    super.update(dt);

    contactBullets.forEach((element) {
      final gravityVector = element.center - center;
      final value = 2 / gravityVector.length2;
      element.body.applyForce(gravityVector * value);
    });
  }
}