
import 'dart:math';

import 'package:flame/composition.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/black_white_hole.dart';
import 'package:rocket/element.dart';
import 'package:rocket/meteorite.dart';
import 'package:rocket/nebula.dart';
import 'package:rocket/sun.dart';
import 'package:rocket/supernova.dart';
import 'package:rocket/worm_hole.dart';

enum ELEMENT {
 BLACK_HOLE, WHITE_HOLE, METEORITE, SUN, WORM_HOLE, NEBULA, SUPERNOVA
}

class ElementData {
  final int max;
  final double appChance, desChance;

  int current = 0;

  ElementData({this.max = 2, this.appChance = 0.2, this.desChance = 0.1});
}

class ElementManager {
  Map<ELEMENT, ElementData> elementDataMap = {
    ELEMENT.BLACK_HOLE: ElementData(),
    ELEMENT.WHITE_HOLE: ElementData(),
    ELEMENT.METEORITE: ElementData(),
    ELEMENT.SUN: ElementData(),
    ELEMENT.WORM_HOLE: ElementData(appChance: 0.4, desChance: 0.05),
    ELEMENT.SUPERNOVA: ElementData(max: 1, appChance: 0.1),
    ELEMENT.NEBULA: ElementData(),
  };

  RocketGame _game;

  ElementManager(this._game);

  Random rng = Random();

  double _t = 0;
  
  List<RocketElement> elementList = [];

  void init() {
    for (final e in elementList) {
      _game.remove(e);
    }
  }

  void update(double dt) {
    if (dt == 0) return;

    _t += dt;
    if (_t < 1) return;
    _t -= 1;

    for (final e in elementList) {
      final data = elementDataMap[e.element];
      removeElement(e, data);
    }

    final randomOrder = elementDataMap.keys.toList()..shuffle();
    
    for (final element in randomOrder) {
      final data = elementDataMap[element];
      addElement(element, data);
    }
  }

  void removeElement(RocketElement c, ElementData data) {
    final rngValue = rng.nextDouble();
    if (rngValue < data.desChance) {
      c.shouldRemove = true;
    }
  }

  void addElement(ELEMENT element, ElementData data) {

    final available = data.max - data.current;
    for (int i = 0; i < available; i++) {
      final rngValue = rng.nextDouble();
      if (rngValue < data.appChance) {
        final radius = elementSize(element);
        final position = createRandomPosition(radius);
        if (isOverlapWithAny(Vector3(position.x, position.y, radius))) {
          continue;
        }

        if (element == ELEMENT.WORM_HOLE) {
          final position2 = createRandomPosition(radius);
          if (isOverlapWithAny(Vector3(position2.x, position2.y, radius))) {
            continue;
          }

          if ((position.x - position2.x) * (position.x - position2.x) +
              (position.y - position2.y) * (position.y - position2.y) <=
              radius * radius * 4) {
            continue;
          }

          createComponent(element, position, position2);
        } else {
          createComponent(element, position);
        }
      }
    }
  }

  Vector2 createRandomPosition(double radius) {
    final randomPos = Vector2.random() - Vector2.all(0.5) ;

    randomPos.setValues(randomPos.x * (15 - radius * 2), randomPos.y * (10 - radius * 2));

    return randomPos;
  }

  bool isOverlapWithAny(Vector3 c) {
    for (final used in elementList) {
      if (used.isOverlap(c)) return true;
    }
    return false;
  }

  bool isOverlap(Vector2 c1, Vector2 c2, double r) {
    double distSq = (c1.x - c2.x) * (c1.x - c2.x) +
        (c1.y - c2.y) * (c1.y - c2.y);
    double radSumSq = r * r * 4;

    return distSq <= radSumSq;
  }


  createComponent(ELEMENT element, Vector2 position, [Vector2 position2]) {
    switch (element) {
      case ELEMENT.BLACK_HOLE:
        BlackHole(_game, this, position); break;
      case ELEMENT.WHITE_HOLE:
        WhiteHole(_game, this, position); break;
      case ELEMENT.METEORITE:
        Meteorite(_game, this, position, rng.nextBool()); break;
      case ELEMENT.SUN:
        Sun(_game, this, position); break;
      case ELEMENT.WORM_HOLE:
        WormHole(_game, this, position, childPosition: position2); break;
      case ELEMENT.SUPERNOVA:
        Supernova(_game, this, position); break;
      case ELEMENT.NEBULA:
        Nebula(_game, this, position); break;
    }

    return null;
  }

  double elementSize(ELEMENT element) {
    switch (element) {
      case ELEMENT.BLACK_HOLE:
        return BWHole.RADIUS;
      case ELEMENT.WHITE_HOLE:
        return BWHole.RADIUS;
      case ELEMENT.METEORITE:
        return Meteorite.RADIUS;
      case ELEMENT.SUN:
        return Sun.RADIUS;
      case ELEMENT.WORM_HOLE:
        return WormHole.RADIUS;
      case ELEMENT.SUPERNOVA:
        return Supernova.RADIUS;
      case ELEMENT.NEBULA:
        return Nebula.RADIUS;
    }

    return null;
  }

}