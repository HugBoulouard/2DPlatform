import 'dart:async';

import 'package:flame/components.dart';
import 'package:platform_game/components/collision_block.dart';
import 'package:platform_game/components/utils.dart';
import 'package:platform_game/pixel_adventure.dart';

enum PlayerState { idle, running, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({position}) : super(position: position);

  late final SpriteAnimation idleAnimation, runningAnimation, fallingAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  double hozizontalMovement = 0.0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    startingPosition = Vector2(position.x, position.y);
    // debugMode = true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();

    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    fallingAnimation = _spriteAnimation('Fall', 1);
    //list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.falling: fallingAnimation
    };
    //set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/Ninja Frog/$state (32x32).png"),
      SpriteAnimationData.sequenced(
          amount: 11, stepTime: stepTime, textureSize: Vector2.all(32)),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }

    if (velocity.y < 0) {
      playerState = PlayerState.falling;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = hozizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - width;
          }
        }
      }
      if (block.isLava) {
        if (checkCollision(this, block)) {
          position.x = startingPosition.x;
          position.y = startingPosition.y;
        }
      }
    }
  }
}
