import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:platform_game/actors/player.dart';
import 'package:platform_game/levels/level.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:platform_game/actors/player.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player();

  double accelerometerX = 0.0, accelerometerY = 0.0, accelerometerZ = 0.0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(
      player: player,
    );
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    accelerometerEvents.listen((AccelerometerEvent event) {
      // Utilisez les données de l'accéléromètre ici
      accelerometerX = event.x;
      accelerometerY = event.y;
      accelerometerZ = event.z;
    });

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateAccelerometer();
    super.update(dt);
  }

  void updateAccelerometer() {
    if (accelerometerY.abs() > 1) {
      switch (accelerometerX.sign.toInt()) {
        case 1:
          player.playerDirection = accelerometerY > 1
              ? PlayerDirection.right
              : accelerometerY < -1
                  ? PlayerDirection.left
                  : PlayerDirection.none;
          break;
        case -1:
          player.playerDirection = accelerometerY < -1
              ? PlayerDirection.right
              : accelerometerY > 1
                  ? PlayerDirection.left
                  : PlayerDirection.none;
          break;
        default:
          player.playerDirection = PlayerDirection.none;
      }
    } else {
      player.playerDirection = PlayerDirection.none;
    }
  }
}
