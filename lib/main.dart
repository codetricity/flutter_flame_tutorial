import 'package:flutter/material.dart';
import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

void main() {
  print('starting from main');
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends BaseGame with DoubleTapDetector {
  SpriteComponent girl = SpriteComponent();
  bool running = true;
  String direction = 'down';
  SpriteAnimationComponent girlAnimation = SpriteAnimationComponent();
  double speed = 2.0;

  @override
  Future<void> onLoad() async {
    print('loading assets');
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(100.0, 100.0)
      ..x = 150
      ..y = 50;
    // add(girl);

    var spriteSheet = await images.load('girl_spritesheet.png');
    final spriteSize = Vector2(152 * 1.4, 142 * 1.4);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 9, stepTime: 0.03, textureSize: Vector2(152.0, 142.0));
    girlAnimation =
        SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
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