

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element.dart';
import 'package:rocket/element_manager.dart';

class WormHole extends RocketElement {
  static const double RADIUS = 1.6;

  Vector2 position;

  WormHole parent, child;

  final bool isParent;

  WormHole(RocketGame game, ElementManager manager, this.position, {this.isParent = true, this.parent, Vector2 childPosition}) : super(
      game,
      manager,
      Vector2(RADIUS * 2, RADIUS * 2),
      isParent ? game.wormHoleBlueImage : game.wormHoleGreenImage,
      ELEMENT.WORM_HOLE) {
    if (isParent) {
      child = WormHole(game, manager, childPosition, isParent: false, parent: this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (contactBullets.isEmpty) return;

    for (Bullet b in contactBullets) {

      final out = isParent ? child : parent;
      final yOffset = b.body.position.y - position.y;

      if (b.body.linearVelocity.x > 0) {
        b.body.setTransform(out.position + Vector2(Bullet.RADIUS, yOffset), 0);
      } else {
        b.body.setTransform(out.position + Vector2(-Bullet.RADIUS, yOffset), 0);
      }

    }

    contactBullets.clear();
  }

  @override
  void onRemove() {
    super.onRemove();

    if (isParent)
      child.shouldRemove = true;
    else
      parent.shouldRemove = true;
  }

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();
    shape.setAsEdge(Vector2(0, RADIUS), Vector2(0, -RADIUS));

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..isSensor = true;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
      ..type = BodyType.STATIC;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool isOverlap(Vector3 circle) {
    double distSq = (circle.x - position.x) * (circle.x - position.x) +
        (circle.y - position.y) * (circle.y - position.y);
    double radSumSq = (circle.z + RADIUS) * (circle.z + RADIUS);

    return distSq <= radSumSq;
  }
}