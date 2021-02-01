
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:forge2d/forge2d.dart';

import 'RocketGame.dart';

class BlackHole extends SpriteBodyComponent {
  static const double RADIUS = 1.6;

  RocketGame _game;

  Vector2 _position;

  BlackHole(this._game, this._position, ui.Image image) : super(Sprite(image), Vector2(RADIUS * 2, RADIUS * 2)) {
    print(_position);
  }

  @override
  Body createBody() {
    final CircleShape shape = CircleShape();
    shape.radius = RADIUS;


    final fixtureDef = FixtureDef()
      ..shape = shape
      ..isSensor = true;

    final bodyDef = BodyDef()
    // To be able to determine object in collision
      ..userData = this
      ..position = _position
      ..type = BodyType.STATIC;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef);
  }



  @override
  void onRemove() {
    world.destroyBody(body);

    super.onRemove();
  }

  @override
  int get priority => 5;

}