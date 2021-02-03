import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/element_manager.dart';

abstract class RocketElement extends SpriteBodyComponent {
  RocketGame game;

  Vector2 position;

  ELEMENT element;

  RocketElement(this.game, this.position, Vector2 size, ui.Image image, this.element) : super(Sprite(image), size);

  @override
  void onRemove() {
    world.destroyBody(body);

    super.onRemove();
  }
}