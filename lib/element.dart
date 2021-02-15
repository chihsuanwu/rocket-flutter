import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:rocket/bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element_manager.dart';

abstract class RocketElement extends SpriteBodyComponent {
  final RocketGame game;

  final ElementManager elementManager;

  final ELEMENT element;

  final List<Bullet> contactBullets = [];

  RocketElement(this.game, this.elementManager, Vector2 size, ui.Image image, this.element) :
        super(Sprite(image), size) {
    game.add(this);
    elementManager.elementList.add(this);
    elementManager.elementDataMap[element].current++;
  }

  @override
  void onRemove() {
    super.onRemove();

    world.destroyBody(body);
    elementManager.elementList.remove(this);
    elementManager.elementDataMap[element].current--;
  }

  bool isOverlap(Vector3 circle);
}

abstract class CircleElement extends RocketElement {

  final Vector2 position;

  final double _radius;

  CircleElement(RocketGame game,
      ElementManager manager,
      this.position,
      this._radius,
      ui.Image image,
      ELEMENT element) :
        super(game, manager, Vector2(_radius * 2, _radius * 2), image, element);

  @override
  Body createBody() {
    final CircleShape shape = CircleShape()..radius = _radius;

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
    double radSumSq = (circle.z + _radius) * (circle.z + _radius);

    return distSq <= radSumSq;
  }
}

class ElementBulletContactCallback extends ContactCallback<RocketElement, Bullet> {
  @override
  void begin(RocketElement a, Bullet b, Contact contact) {
    a.contactBullets.add(b);
  }

  @override
  void end(RocketElement a, Bullet b, Contact contact) {
    a.contactBullets.remove(b);
  }
}