

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Meteorite extends CircleElement {
  static const double RADIUS = 0.8;

  bool isTriple;

  Meteorite(RocketGame game, ElementManager manager, Vector2 position, this.isTriple) : super(
      game,
      manager,
      position,
      RADIUS,
      isTriple ? game.meteorite3Image : game.meteorite2Image,
      ELEMENT.METEORITE);

  @override
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;
    shouldRemove = true;

    final rng = Random();

    for (Bullet b in contactBullets) b.shouldRemove = true;

    final bullet = contactBullets.first;

    final v = bullet.body.linearVelocity.normalized();
    if (isTriple) {
      Bullet(game,
          bullet.center + (Vector2.copy(v)..rotate(pi/6)) * Bullet.RADIUS * 2.1,
          Vector2.copy(v)..rotate(pi / 12 + pi/12 * rng.nextDouble()),
          speed: 1 + rng.nextDouble() * 0.1,
          cloneBullet: bullet);
      Bullet(game, bullet.center,
          Vector2.copy(v)..rotate(-pi / 12 + pi / 6 * rng.nextDouble()),
          speed: 0.9 + rng.nextDouble() * 0.1,
          cloneBullet: bullet);
      Bullet(game,
          bullet.center + (Vector2.copy(v)..rotate(-pi/6)) * Bullet.RADIUS * 2.1,
          Vector2.copy(v)..rotate(-pi / 12 + -pi/12 * rng.nextDouble()),
          speed: 1 + rng.nextDouble() * 0.1,
          cloneBullet: bullet);
    } else {
      Bullet(game,
          bullet.center + (Vector2.copy(v)..rotate(pi/6)) * Bullet.RADIUS * 2,
          Vector2.copy(v)..rotate(pi / 8 * rng.nextDouble()),
          speed: 0.9 + rng.nextDouble() * 0.2,
          cloneBullet: bullet);
      Bullet(game,
          bullet.center+ (Vector2.copy(v)..rotate(-pi/6)) * Bullet.RADIUS * 2,
          Vector2.copy(v)..rotate(-pi / 8 * rng.nextDouble()),
          speed: 0.9 + rng.nextDouble() * 0.2,
          cloneBullet: bullet);
    }
  }
}