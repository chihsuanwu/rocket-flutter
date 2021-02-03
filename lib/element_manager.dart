
import 'dart:math';

import 'package:flame/composition.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:rocket/RocketGame.dart';
import 'package:rocket/black_white_hole.dart';
import 'package:rocket/element.dart';

enum ELEMENT {
 BLACK_HOLE, WHITE_HOLE
}

class ElementData {
  int max = 3, current = 0;
  List<Offset> position = List.empty();
  double appChance = 0.5, desChance = 0.05;
}

class ElementManager {
  Map<ELEMENT, ElementData> elementDataMap = {
    ELEMENT.BLACK_HOLE: ElementData(),
    ELEMENT.WHITE_HOLE: ElementData(),
  };

  RocketGame _game;

  ElementManager(this._game);

  Random rng = Random();

  double t = 0;
  
  List<RocketElement> elementList = List();

  void init() {

  }

  void update(double dt) {
    if (dt == 0) return;

    t += dt;
    if (t < 1) return;
    t -= 1;

    List<RocketElement> rem = List.empty(growable: true);
    for (final e in elementList) {
      final data = elementDataMap[e.element];
      removeElement(e, data, rem);
    }

    for (final e in rem) {
      elementList.remove(e);
    }

    final randomOrder = elementDataMap.keys.toList()..shuffle();
    
    for (final element in randomOrder) {
      final data = elementDataMap[element];
      addElement(element, data);
    }
  }

  void removeElement(RocketElement c, ElementData data, List<RocketElement> rem) {
    final rngValue = rng.nextDouble();
    if (rngValue < data.desChance) {
      rem.add(c);
      c.shouldRemove = true;
      data.current--;
    }
  }

  void addElement(ELEMENT element, ElementData data) {
    //if (unusedBlock.isEmpty) return;
    final available = data.max - data.current;
    for (int i = 0; i < available; i++) {
      final rngValue = rng.nextDouble();
      if (rngValue < data.appChance) {
        final randomPos = Vector2.random() - Vector2.all(0.5) ;
        //print(randomPos);
        final radius = elementSize(element);
        randomPos.setValues(randomPos.x * (15 - radius * 2), randomPos.y * (10 - radius * 2));
        //print(randomPos);
        Vector3 c = Vector3(randomPos.x, randomPos.y, radius);
        if (isOverlapIn(c)) {
          continue;
        }

        // final randomIndex = rng.nextInt(unusedBlock.length);
        // final position = unusedBlock[randomIndex];
        // unusedBlock.removeAt(randomIndex);
        //usedBlock.add(position);


        final component = createComponent(element, randomPos);
        elementList.add(component);
        data.current++;
        _game.add(component);

      }
    }
  }

  bool isOverlapIn(Vector3 c) {
    for (final used in elementList) {
      if (isOverlap(c, Vector3(used.position.x, used.position.y, used.size.x / 2))) return true;
    }
    return false;
  }

  bool isOverlap(Vector3 c1, Vector3 c2) {
    double distSq = (c1.x - c2.x) * (c1.x - c2.x) + (c1.y - c2.y) * (c1.y - c2.y);
    double radSumSq = (c1.z + c1.z) * (c2.z + c2.z);

    return distSq <= radSumSq;
  }



  RocketElement createComponent(ELEMENT element, Vector2 position) {

    switch (element) {
      case ELEMENT.BLACK_HOLE:
        return BlackHole(_game, position, _game.blackHoleImage);
      case ELEMENT.WHITE_HOLE:
        return WhiteHole(_game, position, _game.whiteHoleImage);
    }
  }

  double elementSize(ELEMENT element) {
    switch (element) {
      case ELEMENT.BLACK_HOLE:
        return BWHole.RADIUS;
      case ELEMENT.WHITE_HOLE:
        return BWHole.RADIUS;
    }
  }
}