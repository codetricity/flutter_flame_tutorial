import 'dart:ui' as ui;

import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

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

  @override
  Future<void> onLoad() async {
    print('loading assets');

    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size;
    add(background);

    platformSprite = await loadSprite('platform.png');

    SpriteComponent platform = SpriteComponent()
      ..sprite = platformSprite
      ..size = Vector2(170, 40)
      ..x = 0
      ..y = 200;
    add(platform);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(200.0, 200.0)
      ..x = 150
      ..y = 600;
    add(boy);

    var spriteSheet = await images.load('girl_spritesheet.png');
    final spriteSize = Vector2(152 * 1.4, 142 * 1.4);
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

class Boy extends SpriteComponent with Hitbox, Collidable {
  Boy({
    Vector2 position,
    Vector2 size,
  }) : super(position: position, size: size) {
    debugMode = true;
    addShape(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    // TODO: implement onCollision
    super.onCollision(points, other);
    print('hit');
  }
}

class Girl extends SpriteAnimationComponent with Hitbox, Collidable {
  Girl({Vector2 position, Vector2 size})
      : super(position: position, size: size);

  Girl.fromFrameData(
    ui.Image image,
    SpriteAnimationData data, {
    Vector2 position,
    Vector2 size,
  }) : super(position: position, size: size) {
    animation = SpriteAnimation.fromFrameData(image, data);
    debugMode = true;
    addShape(HitboxRectangle());
  }
}
