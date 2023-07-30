import 'dart:async';
import 'package:eccentric_pixel/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
class Level extends World{

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async{
    // implement onLoad

    level= await  TiledComponent.load("level_01.tmx", Vector2.all(16));

    add(level);
    final spawnPointsLayer=level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    for(final spawnPoint in spawnPointsLayer!.objects)
      {
        switch(spawnPoint.class_)
        {
          case 'Player':
            final player=Player(character: 'Virtual Guy');
            add(Player(character: "Virtual Guy",position: Vector2(spawnPoint.x,spawnPoint.y)));
            break;
          default:
        }
      }


    return super.onLoad();
  }
}