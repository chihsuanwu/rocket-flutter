
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:rocket/boundaries.dart';
import 'package:rocket/element_manager.dart';

import 'Bullet.dart';
import 'CountDown.dart';
import 'Rocket.dart';



enum GAME_STATUS {
  PAUSE, COUNTDOWN, PLAYING, END
}

class RocketGame extends Forge2DGame with MultiTouchTapDetector {

  static const WORLD_WIDTH = 20, WORLD_HEIGHT = 10;

  Vector2 screenSize;
  Rect mainGameRect;

  Rocket rocket1P, rocket2P;

  GAME_STATUS _status;

  int bulletCounter = 0;

  ui.Image rocket1PImage,
      rocket2PImage,
      backgroundImage, playImage, restartImage, pauseImage,blackHoleImage, whiteHoleImage;

  ElementManager elementManager;

  RocketGame() : super(gravity: Vector2(0, 0)) {

    elementManager = ElementManager(this);

    _status = GAME_STATUS.END;

    final b = createBoundaries(this);
    b.forEach(add);

    addContactCallback(RocketBulletContactCallback());
  }

  @override
  void onResize(Vector2 size) {
    //print("MAIN RE");
    screenSize = size;


    double width, height;
    if (size.x / size.y >= 2) {
      height = size.y * 0.9;
      width = height * 2;
    } else {
      width = size.x * 0.9;
      height = width * 0.5;
    }
    mainGameRect = Rect.fromLTWH(
        (size.x - width) * 0.5,
        (size.y - height) * 0.5,
        width,
        height
    );

    viewport.scale = width / 20;

    super.onResize(size);
  }

  @override
  void lifecycleStateChange(ui.AppLifecycleState state) {
    print(state);
    //super.lifecycleStateChange(state);

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        print("INACTIVE");
        break;
      case AppLifecycleState.paused:
        onGamePause();
        print("PAUSED");
        break;
      case AppLifecycleState.detached:
        print("DETACH");
        break;
    }


  }


  @override
  Future<void> onLoad() async {
    rocket1PImage = await images.load('rocket1P.png');
    rocket2PImage = await images.load('rocket2P.png');
    backgroundImage = await images.load('background.png');
    playImage = await images.load('play.png');
    restartImage = await images.load('restart.png');
    pauseImage = await images.load('pause.png');
    blackHoleImage = await images.load('blackhole.png');
    whiteHoleImage = await images.load('whitehole.png');

    rocket1P = Rocket(this, rocket1PImage, Player.PLAYER_1P);
    rocket2P = Rocket(this, rocket2PImage, Player.PLAYER_2P);
    add(rocket1P);
    add(rocket2P);

    return super.onLoad();
  }

  void onGameStart() {
    _status = GAME_STATUS.PLAYING;
  }

  void onGameResume() {
    _status = GAME_STATUS.PLAYING;
  }

  void onGamePause() {
    _status = GAME_STATUS.PAUSE;
  }

  void onGameEnd() {
    _status = GAME_STATUS.END;
    components.forEach((element) {
      if (element.runtimeType == Bullet) {
        element.shouldRemove = true;
      }
    });
  }

  @override
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.x, screenSize.y);
    Paint paint = Paint()..color = Color(0xff000000);
    canvas.drawRect(bgRect, paint);
    canvas.drawImageRect(backgroundImage,
        Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
        mainGameRect,
        paint);


    if (_status != GAME_STATUS.PAUSE && _status != GAME_STATUS.END)  {
      final iconSize = (screenSize.y - mainGameRect.height) / 2;

      canvas.drawImageRect(pauseImage,
          Rect.fromLTWH(0, 0, pauseImage.width.toDouble(), pauseImage.height.toDouble()),
          Rect.fromLTWH(mainGameRect.center.dx - iconSize / 2,
              mainGameRect.bottomCenter.dy,
              iconSize,
              iconSize),
          paint);
    }

    super.render(canvas);

    final iconSize = mainGameRect.height * 0.2;
    if (_status == GAME_STATUS.PAUSE) {

      canvas.drawImageRect(restartImage,
          Rect.fromLTWH(0, 0, restartImage.width.toDouble(), restartImage.height.toDouble()),
          Rect.fromCenter(center: mainGameRect.center.translate(-iconSize, 0),
              width: iconSize,
              height: iconSize),
          paint);

      canvas.drawImageRect(playImage,
          Rect.fromLTWH(0, 0, playImage.width.toDouble(), playImage.height.toDouble()),
          Rect.fromCenter(center: mainGameRect.center.translate(iconSize, 0),
              width: iconSize,
              height: iconSize),
          paint);
    } else if (_status == GAME_STATUS.END) {
      canvas.drawImageRect(restartImage,
          Rect.fromLTWH(0, 0, restartImage.width.toDouble(), restartImage.height.toDouble()),
          Rect.fromCenter(center: mainGameRect.center,
              width: iconSize,
              height: iconSize),
          paint);
    }
  }

  @override
  void update(double dt) {

    double time = dt;


    if (_status != GAME_STATUS.PLAYING) {
      time = 0;
    }

    if (_status == GAME_STATUS.COUNTDOWN) {
      components.forEach((element) {
        if (element.runtimeType == CountDown) {
          element.update(dt);
        }
        //if (element.runtimeType != Rocket && element.runtimeType != Bullet) {
          //element.update(dt);
        //}
      });
      //return;
    }

    if (_status == GAME_STATUS.PLAYING) {
      if (!rocket1P.hasBullet && !rocket2P.hasBullet && bulletCounter == 0) {
        rocket1P.hasBullet = true;
        rocket2P.hasBullet = true;
      }

      elementManager.update(dt);
    }


    super.update(time);
  }

  @override
  void onTapUp(int pointerId, TapUpDetails details) {
    print("Player tap up on ${details.globalPosition.dx} - ${details.globalPosition.dy}");

    if (_status == GAME_STATUS.END) {
      _status = GAME_STATUS.COUNTDOWN;
      rocket1P.init();
      rocket2P.init();
      bulletCounter = 0;
      CountDown countDown = CountDown(this);
      add(countDown);
      countDown.startCountDown();
    } else if (_status == GAME_STATUS.PAUSE) {
      _status = GAME_STATUS.COUNTDOWN;
      final restart = details.globalPosition.dx < screenSize.x / 2;
      if (restart) {
        components.forEach((element) {
          if (element.runtimeType == Bullet) {
            element.remove();
          }
        });
        rocket1P.init();
        rocket2P.init();
      }
      CountDown countDown = CountDown(this);
      add(countDown);
      countDown.startCountDown();

    } else if (_status == GAME_STATUS.PLAYING) {
      if (details.globalPosition.dy > mainGameRect.bottom &&
          details.globalPosition.dx > mainGameRect.center.dx - (screenSize.y - mainGameRect.bottom) &&
          details.globalPosition.dx < mainGameRect.center.dx + (screenSize.y - mainGameRect.bottom)) {
        onGamePause();
      } else if (details.globalPosition.dx < screenSize.x / 2) {
        print("1P click");
        if (rocket1P.hasBullet) {
          rocket1P.hasBullet = false;
          Vector2 v = rocket1P.createBullet();

          Bullet b = Bullet(this, v, 0);
          add(b);
          bulletCounter++;
        } else {
          rocket1P.rev();
        }
      } else {
        print("2P click");
        if (rocket2P.hasBullet) {
          rocket2P.hasBullet = false;
          Vector2 v = rocket2P.createBullet();

          Bullet b = Bullet(this, v, math.pi);
          add(b);
          bulletCounter++;
        } else {
          rocket2P.rev();
        }
      }
    }
  }

}