

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Sun extends CircleElement {
  static const double RADIUS = 1.2;

  Sun(RocketGame game, ElementManager manager, Vector2 position) : super(
      game,
      manager,
      position,
      RADIUS,
      game.sunImage,
      ELEMENT.SUN);

  @override
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;

    for (Bullet b in contactBullets) {
      b.invisibleState = 0.0;
      b.setFire();
      b.body.linearVelocity = b.body.linearVelocity.normalized() * Bullet.SPEED * 2;
    }
  }
}