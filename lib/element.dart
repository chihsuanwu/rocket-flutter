import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:rocket/RocketGame.dart';

abstract class Element extends SpriteBodyComponent {
  RocketGame game;

  Vector2 position;

  Element(Sprite sprite, Vector2 size) : super(sprite, size);

  //Element(this.game) : super()
}