import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../actors/player.dart';

class Level extends World {
  final Player player;
  Level({required this.player});
  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("PixelAdventure.tmx", Vector2.all(16));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
