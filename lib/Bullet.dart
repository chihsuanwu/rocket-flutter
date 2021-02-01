import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/RocketGame.dart';

class Bullet extends BodyComponent {

  static const RADIUS = 0.16, SPEED = 7.2;

  RocketGame _game;

  Vector2 _position;
  Vector2 _direction;

  Bullet(this._game, this._position, double direction, [double speed = 1.0]) {
    _direction = Vector2(SPEED * speed, 0);
    _direction.rotate(direction);
  }

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    // TODO: implement renderCircle
    //print("hi");
    super.renderCircle(canvas, center, radius);
  }

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
    // To be able to determine object in collision
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
    if ((body.position.x < -RocketGame.WORLD_WIDTH / 2 - RADIUS ||
        body.position.x > RocketGame.WORLD_WIDTH / 2 + RADIUS)) {
      shouldRemove = true;
    }

    super.update(dt);
  }

  @override
  int get priority => 10;
}