import 'dart:ui' as ui;
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'boy.dart';
import 'girl.dart';
import 'platform.dart';

void main() {
  print('starting from main');
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends BaseGame with DoubleTapDetector, HasCollidables {
  Boy boy = Boy();
  bool running = true;
  String direction = 'down';
  Girl girlAnimation = Girl();
  double speed = 2.0;
  Sprite platformSprite;
  double characterScale = 0.5;

  void initPlatform(Sprite sprite, screenSize) {
    for (var i = 1; i < 11; i++) {
      var x = 0.0;
      Anchor anchor = Anchor.centerLeft;

      if (i % 2 == 0) {
        x = 0;
        anchor = Anchor.centerLeft;
      } else {
        x = screenSize[0];
        anchor = Anchor.centerRight;
      }
      Platform platform = Platform(
          position: Vector2(x, (i * size[1] / 12.0) + 50),
          size: Vector2(170 * .7, 40 * .7))
        ..anchor = anchor
        ..sprite = sprite;
      add(platform);
    }
  }

  @override
  Future<void> onLoad() async {
    print('loading assets');

    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size;
    add(background);

    platformSprite = await loadSprite('platform.png');
    initPlatform(platformSprite, size);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(200.0 * characterScale, 200.0 * characterScale)
      ..anchor = Anchor.bottomRight
      ..position = size;

    add(boy);

    var spriteSheet = await images.load('girl_spritesheet.png');
    final spriteSize = Vector2(152 * characterScale, 142 * characterScale);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 9, stepTime: 0.03, textureSize: Vector2(152.0, 142.0));
    girlAnimation = Girl.fromFrameData(spriteSheet, spriteData)
      ..x = 150
      ..y = 30
      ..size = spriteSize;
    add(girlAnimation);
  }

  @override
  update(double dt) {
    super.update(dt);

    switch (direction) {
      case 'down':
        girlAnimation.y += speed;
        break;
      case 'up':
        girlAnimation.y -= speed;
        break;
    }

    if (girlAnimation.y > 500) {
      direction = 'up';
    }
    if (girlAnimation.y < 10) {
      direction = 'down';
    }
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }
    running = !running;
  }
}
