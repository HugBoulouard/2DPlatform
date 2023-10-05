import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:platform_game/components/player.dart';
import 'package:platform_game/components/level.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

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
    if (accelerometerX > 0) {
      if (accelerometerY > 1) {
        player.hozizontalMovement = 1;
      } else if (accelerometerY < -1) {
        player.hozizontalMovement = -1;
      } else {
        player.hozizontalMovement = 0;
      }
    } else {
      if (accelerometerY < -1) {
        player.hozizontalMovement = 1;
      } else if (accelerometerY > 1) {
        player.hozizontalMovement = -1;
      } else {
        player.hozizontalMovement = 0;
      }
    }
  }
}
