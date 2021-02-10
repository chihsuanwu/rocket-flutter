

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/Bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Sun extends RocketElement {
  static const double RADIUS = 1.2;

  bool isTriple;

  Sun(RocketGame game, Vector2 position, ui.Image image) : super(
      game,
      position,
      Vector2(RADIUS * 2, RADIUS * 2),
      image,
      ELEMENT.METEORITE);

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
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;

    for (Bullet b in contactBullets) {
      if (b.bulletStatus != BULLET_STATUS.FIRE) {
        b.bulletStatus = BULLET_STATUS.FIRE;
        b.body.linearVelocity = b.body.linearVelocity.normalized() * Bullet.SPEED * 2;
        b.paint.color = Colors.red;
      }
    }
  }
}