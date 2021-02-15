

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Nebula extends CircleElement {
  static const double RADIUS = 1.5;

  Nebula(RocketGame game, ElementManager manager, Vector2 position) : super(
      game,
      manager,
      position,
      RADIUS,
      game.nebulaImage,
      ELEMENT.NEBULA);

  @override
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;

    for (Bullet b in contactBullets) {
      b.invisibleState += dt * 3.6;
      if (b.invisibleState > 1.5) {
        b.invisibleState = 1.5;
      }
    }
  }
}