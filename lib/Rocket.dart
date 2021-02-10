import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:forge2d/forge2d.dart';
import 'package:rocket/Bullet.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/boundaries.dart';

enum Player {
  PLAYER_1P, PLAYER_2P
}

extension value on Player {
  int get val {
    switch (this) {
      case Player.PLAYER_1P:
        return -1;
      case Player.PLAYER_2P:
        return 1;
    }
    return 1;
  }
}

class Rocket extends SpriteBodyComponent {

  static const double WIDTH = 1.6, HEIGHT = 1.2, SPEED = 3;

  RocketGame _game;

  Player _player;

  bool hasBullet;

  TextPainter painter;
  TextStyle textStyle;

  int _hp = 10;
  int _fullHp = 10;

  Rocket(this._game, ui.Image image, this._player):
        super(Sprite(image), Vector2(Rocket.WIDTH, Rocket.HEIGHT)) {

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 10
    );

    init();
  }

  void init() {
    _hp = 10;
    hasBullet = true;

    body?.setTransform(Vector2((RocketGame.WORLD_WIDTH / 2 - size.x / 2) * _player.val, 0), body.getAngle());
  }

  @override
  int get priority => 5;

  @override
  void render(Canvas c) {
    _renderHPBackground(c);
    _renderHPContainer(c);
    _renderHP(c);

    if (hasBullet) {
      _renderBullet(c);
    }

    super.render(c);
  }


  void rev() {
    body.linearVelocity = Vector2(0, -body.linearVelocity.y);
  }

  void _renderBullet(Canvas c) {
    final o = Offset(_player == Player.PLAYER_1P ?
      (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5 :
      _game.mainGameRect.right + (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5,
        _game.mainGameRect.top + _game.mainGameRect.height * 0.04);

    final r = (_game.screenSize.x - _game.mainGameRect.width) * 0.5 * 0.16;

    Paint paint = Paint()
      ..color = Color(0xffffffff);
    c.drawCircle(o, r, paint);
  }


  void _renderHPBackground(Canvas c) {
    final left = _player == Player.PLAYER_1P ? 0.0 : _game.mainGameRect.right,
        top = 0.0,
        width = (_game.screenSize.x - _game.mainGameRect.width) / 2,
        height = _game.screenSize.y;

    Rect rect = Rect.fromLTWH(left, top, width, height);
    Paint paint = Paint()
      ..color = Color(0xff000000);
    c.drawRect(rect, paint);
  }

  void _renderHPContainer(Canvas c) {
    final top = _game.mainGameRect.top + _game.mainGameRect.height * 0.08,
        height = _game.mainGameRect.height * 0.84,
        width = (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5,
        left = _player == Player.PLAYER_1P ?
          (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.25 :
          _game.mainGameRect.right + (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.25;


    Rect rect = Rect.fromLTWH(left, top, width, height);
    Paint paint = Paint()
      ..color = Color(0xffffffff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.04;
    c.drawRect(rect, paint);
  }

  void _renderHP(Canvas c) {
    final height = _game.mainGameRect.height * 0.84 * (_hp / _fullHp),
        top = _game.mainGameRect.top + _game.mainGameRect.height * 0.08 + _game.mainGameRect.height  * 0.84 * ((_fullHp - _hp) / _fullHp),
        width = (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5,
        left = _player == Player.PLAYER_1P ?
        (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.25 :
        _game.mainGameRect.right + (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.25;


    Rect rect = Rect.fromLTWH(left, top, width, height);
    Paint paint = Paint()
      ..color = Color(0xFF006000);
    c.drawRect(rect, paint);


    painter.paint(c, Offset(
        _player == Player.PLAYER_1P ?
        (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5 - (painter.width / 2) :
        _game.mainGameRect.right + (_game.screenSize.x - _game.mainGameRect.width) / 2 * 0.5 - (painter.width / 2),
      _game.mainGameRect.top + _game.mainGameRect.height * 0.94
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    final text = _hp.toString() + "/" + _fullHp.toString();

    if ((painter.text ?? '') != text) {
      painter.text = TextSpan(
        text: text,
        style: textStyle,
      );

      painter.layout();
    }
  }

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();

    final v1 = Vector2(size.x / 2, size.y / 2);
    final v2 = Vector2(size.x / 2, -size.y / 2);
    final v3 = Vector2(-size.x / 2, -size.y / 2);
    final v4 = Vector2(-size.x / 2, size.y / 2);
    final vertices = [v1, v2, v3, v4];
    shape.set(vertices, vertices.length);

    final fixtureDef = FixtureDef()
      ..shape = shape
      ..restitution = 1
      ..friction = 0
      ..filter = (Filter()..maskBits = 0xFFFD);

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2((RocketGame.WORLD_WIDTH / 2 - size.x / 2) * _player.val, 0)
      ..type = BodyType.DYNAMIC;


    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..createFixture(FixtureDef()..shape = shape..isSensor = true)
      ..linearVelocity = Vector2(0, 5.0 * _player.val);
  }

  Vector2 createBullet() {
    return Vector2(body.position.x - (size.x / 2 + Bullet.RADIUS * 1.1) * _player.val , body.position.y);
  }

  void hitByBullet(Bullet b) {
    if (b.bulletStatus == BULLET_STATUS.FIRE) {
      _hp -= 2;
    } else {
      _hp -= 1;
    }

    if (_hp <= 0) {
      _game.onGameEnd();
    }
  }
}


class RocketBulletContactCallback extends ContactCallback<Rocket, Bullet> {
  @override
  void begin(Rocket a, Bullet b, Contact contact) {
    a.hitByBullet(b);
    b.shouldRemove = true;
  }

  @override
  void end(Rocket a, Bullet b, Contact contact) {}
}
