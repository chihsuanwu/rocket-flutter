

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Supernova extends CircleElement {
  static const double RADIUS = 1.8;

  Supernova(RocketGame game, ElementManager manager, Vector2 position) : super(
      game,
      manager,
      position,
      RADIUS,
      game.supernovaImage,
      ELEMENT.SUPERNOVA);

  @override
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;
    shouldRemove = true;

    for (Bullet b in contactBullets) b.shouldRemove = true;

    final rng = Random();

    for (int i = 0; i < 12; ++i) {
      final vector = (Vector2(Bullet.RADIUS, 0) * 4.1)..rotate(pi / 6 * i);
      final center = position + vector;
      Bullet(game,
          center,
          Vector2.copy(vector)..rotate(-pi / 15 + pi/15 * rng.nextDouble()),
          speed: 0.9 + rng.nextDouble() * 0.2)
        ..setFire();
    }
  }
}