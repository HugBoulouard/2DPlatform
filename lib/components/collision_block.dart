import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  bool isLava;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isLava = false,
  }) : super(
          position: position,
          size: size,
        ) {
    // debugMode = false;
  }
}
