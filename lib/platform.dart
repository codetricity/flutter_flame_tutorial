import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class Platform extends SpriteComponent with Hitbox, Collidable {
  Platform({
    Vector2 position,
    Vector2 size,
  }) : super(position: position, size: size) {
    // debugMode = true;
    addShape(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);
    print('You hit the platform');
    // remove();
  }
}
