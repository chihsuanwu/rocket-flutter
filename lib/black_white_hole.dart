
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/Bullet.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

import 'RocketGame.dart';

abstract class BWHole extends RocketElement {
  static const double RADIUS = 1.6;

  BWHole(RocketGame game, Vector2 position, ui.Image image, ELEMENT element) : super(
      game,
      position,
      Vector2(RADIUS * 2, RADIUS * 2),
      image,
      element);

  @override
  Body createBody() {
    final CircleShape shape = CircleShape();
    shape.radius = RADIUS;


    final fixtureDef = FixtureDef()
      ..shape = shape
      ..isSensor = true;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
      ..type = BodyType.STATIC;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }

  @override
  int get priority => 2;
}

class BlackHole extends BWHole {

  BlackHole(RocketGame game, Vector2 position, ui.Image image) : super(
      game,
      position,
      image,
      ELEMENT.BLACK_HOLE);

  @override
  void update(double dt) {

    contactBullets.forEach((element) {
      final gravityVector = center - element.center;
      print(2 / gravityVector.length2);
      final value = min(2 / gravityVector.length2, 120.0);
      element.body.applyForce(gravityVector * value);
    });

    super.update(dt);
  }

}

class WhiteHole extends BWHole {

  WhiteHole(RocketGame game, Vector2 position, ui.Image image) : super(
      game,
      position,
      image,
      ELEMENT.WHITE_HOLE);

  @override
  void update(double dt) {

    contactBullets.forEach((element) {
      final gravityVector = element.center - center;
      print(2 / gravityVector.length2);
      final value = 2 / gravityVector.length2;
      element.body.applyForce(gravityVector * value);
    });

    super.update(dt);
  }

}