

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/Bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class Meteorite extends RocketElement {
  static const double RADIUS = 0.8;

  ElementManager elementManager;

  bool isTriple;

  Meteorite(this.elementManager, this.isTriple, RocketGame game, Vector2 position, ui.Image image) : super(
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
    shouldRemove = true;
    elementManager.elementDataMap[ELEMENT.METEORITE].current--;
    elementManager.elementList.remove(this);

    final rng = Random();

    for (Bullet b in contactBullets) {
      b.shouldRemove = true;
      final v = b.body.linearVelocity.normalized();
      if (isTriple) {
        Bullet(game,
            b.center + (Vector2.copy(v)..rotate(pi/6)) * Bullet.RADIUS * 2.1,
            Vector2.copy(v)..rotate(pi / 12 + pi/12 * rng.nextDouble()),
            1 + rng.nextDouble() * 0.1,
            b.bulletStatus);
        Bullet(game, b.center,
            Vector2.copy(v)..rotate(-pi / 12 + pi / 6 * rng.nextDouble()),
            0.9 + rng.nextDouble() * 0.1,
            b.bulletStatus);
        Bullet(game,
            b.center + (Vector2.copy(v)..rotate(-pi/6)) * Bullet.RADIUS * 2.1,
            Vector2.copy(v)..rotate(-pi / 12 + -pi/12 * rng.nextDouble()),
            1 + rng.nextDouble() * 0.1,
            b.bulletStatus);
      } else {
        Bullet(game,
            b.center + (Vector2.copy(v)..rotate(pi/6)) * Bullet.RADIUS * 2,
            Vector2.copy(v)..rotate(pi / 8 * rng.nextDouble()),
            0.9 + rng.nextDouble() * 0.2,
            b.bulletStatus);
        Bullet(game,
            b.center+ (Vector2.copy(v)..rotate(-pi/6)) * Bullet.RADIUS * 2,
            Vector2.copy(v)..rotate(-pi / 8 * rng.nextDouble()),
            0.9 + rng.nextDouble() * 0.2,
            b.bulletStatus);
      }

    }
  }
}