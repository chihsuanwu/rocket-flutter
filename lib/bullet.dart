import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/RocketGame.dart';

enum BULLET_STATUS {
  NORMAL, FIRE
}

class Bullet extends BodyComponent {

  static const RADIUS = 0.16, SPEED = 7.2;

  double invisibleState = 0.0;

  RocketGame _game;

  Vector2 _position;
  Vector2 _direction;

  BULLET_STATUS bulletStatus = BULLET_STATUS.NORMAL;

  Bullet(this._game, this._position, Vector2 direction, {double speed = 1.0, Bullet cloneBullet}) {
    _direction = direction.normalized() * SPEED * speed;
    _game.add(this);
    _game.bulletCounter++;

    paint.color = Colors.white;

    if (cloneBullet != null) {
      bulletStatus = cloneBullet.bulletStatus;
      invisibleState = cloneBullet.invisibleState;
      paint.color = cloneBullet.paint.color;
    }
  }

  void setFire() {
    bulletStatus = BULLET_STATUS.FIRE;
    paint.color = Colors.red;
  }

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  Body createBody() {
    final CircleShape shape = CircleShape();
    shape.radius = RADIUS;


    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 1.0
      ..density = 1.0
      ..friction = 0.0
      ..filter = (Filter()..categoryBits = 0x0002);

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.DYNAMIC;

    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = _direction;
  }

  @override
  void onRemove() {
    world.destroyBody(body);
    _game.bulletCounter--;
    super.onRemove();
  }


  @override
  void update(double dt) {
    super.update(dt);

    if ((body.position.x < -RocketGame.WORLD_WIDTH / 2 - RADIUS ||
        body.position.x > RocketGame.WORLD_WIDTH / 2 + RADIUS)) {
      shouldRemove = true;
    }

    if (invisibleState > 0) {
      invisibleState -= dt * 0.5;
    }

    if (invisibleState < 0) invisibleState = 0;

    final color = (bulletStatus == BULLET_STATUS.NORMAL ? Colors.white : Colors.red)
      .withAlpha(((1 - min(invisibleState, 1.0)) * 255).toInt());

    if (paint.color.value != color.value) {
      paint.color = color;
    }
  }

  @override
  int get priority => 3;
}