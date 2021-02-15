import 'dart:ui';

import 'package:forge2d/forge2d.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:rocket/RocketGame.dart';

List<Wall> createBoundaries(RocketGame game) {
  return [
    Wall(Vector2(-RocketGame.WORLD_WIDTH / 2, -RocketGame.WORLD_HEIGHT / 2),
        Vector2(RocketGame.WORLD_WIDTH / 2, -RocketGame.WORLD_HEIGHT / 2)),
    Wall(Vector2(-RocketGame.WORLD_WIDTH / 2, RocketGame.WORLD_HEIGHT / 2),
        Vector2(RocketGame.WORLD_WIDTH / 2, RocketGame.WORLD_HEIGHT / 2))
  ];
}

class Wall extends BodyComponent {
  Paint paint = BasicPalette.white.paint;
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  void renderPolygon(Canvas canvas, List<Offset> coordinates) {
    final start = coordinates[0];
    final end = coordinates[1];
    canvas.drawLine(start, end, paint);
  }

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();
    shape.setAsEdge(start, end);

    final fixtureDef = FixtureDef()
      ..userData = this
      ..shape = shape
      ..restitution = 0
      ..friction = 0;

    final bodyDef = BodyDef()
      ..position = Vector2.zero()
      ..type = BodyType.STATIC;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}