import 'dart:async';
import 'dart:ui';

import 'package:eccentric_pixel/levels/level.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';

class EccentricPixel extends FlameGame
{
  @override
  Color backgroundColor()=> const Color(0xff211f30);
  late final CameraComponent cam;
  final world=Level();
@override
  FutureOr<void> onLoad() async{
  //load imgs into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor=Anchor.topLeft;
    addAll([cam,world]);


    return super.onLoad();
  }
}