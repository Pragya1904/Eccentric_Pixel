import 'dart:async';
import 'package:eccentric_pixel/components/collision_block.dart';
import 'package:eccentric_pixel/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks=[];
  @override
  FutureOr<void> onLoad() async {
    // implement onLoad

    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer!.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            //final player = Player(character: 'Virtual Guy',position: Vector2(spawnPoint.x, spawnPoint.y));

            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    final collisionLayer = level.tileMap.getLayer<ObjectGroup>('collisions');

    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'Platforms':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);  //built-in flame feature to add componenents on screen
            break;
            default:
              final block = CollisionBlock(
                  position: Vector2(collision.x, collision.y),
                  size: Vector2(collision.width, collision.height));
              collisionBlocks.add(block);
              add(block);
        }
      }
    }
    player.collisionBlocks=collisionBlocks;
    return super.onLoad();
  }
}
