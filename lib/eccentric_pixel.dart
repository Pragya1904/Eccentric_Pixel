import 'dart:async';
import 'dart:ui';

import 'package:eccentric_pixel/components//level.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import 'components/player.dart';

class EccentricPixel extends FlameGame with HasKeyboardHandlerComponents,DragCallbacks
{
  @override
  Color backgroundColor()=> const Color(0xff211f30);
  late final CameraComponent cam;
  Player player=Player(character: 'Mask Dude');

  late JoystickComponent joystick;
  bool showJoystick=true;  //for mobile we need joystick but in case of desktop  we had key controls

@override
  FutureOr<void> onLoad() async{
  //load imgs into cache
    await images.loadAllImages();

    final world=Level(levelName: 'level_01',player: player);

    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
    cam.viewfinder.anchor=Anchor.topLeft;
    addAll([cam,world]);
    if(showJoystick) {
      addJoyStick();
    }
    return super.onLoad();
  }
  @override
  void update(double dt) {
    if(showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }
  void addJoyStick() {
    joystick=JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/knob.png')),
      ),
      //knobRadius: 32,
      background: SpriteComponent(
        sprite: Sprite(images.fromCache("HUD/joystick.png")),
      ),
      margin: const EdgeInsets.only(left: 32,bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
      switch(joystick.direction)
      {
        case JoystickDirection.upLeft:
        case JoystickDirection.downLeft:
        case JoystickDirection.left:
          player.horizontalMovement=-1;
          break;
        case JoystickDirection.right:
        case JoystickDirection.upRight:
        case JoystickDirection.downRight:
         player.horizontalMovement=1;
          break;
        default:
          player.horizontalMovement=0;
      }
  }
}