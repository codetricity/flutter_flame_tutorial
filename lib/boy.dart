import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Boy extends SpriteComponent with Hitbox, Collidable {
  Boy({
    Vector2 position,
    Vector2 size,
  }) : super(position: position, size: size) {
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);
    print('Hi, I want to be friends');
    // remove();
  }
}
