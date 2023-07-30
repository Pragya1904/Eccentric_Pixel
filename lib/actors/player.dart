import 'dart:async';

import 'package:eccentric_pixel/eccentric_pixel.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

enum PlayerState {idle,running}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<EccentricPixel> {

  String character;
  Player({required this.character,position}):super(position: position);
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime=0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11);
    runningAnimation = _spriteAnimation("Run",12);

    animations = {
      PlayerState.idle:idleAnimation,
      PlayerState.running:runningAnimation,//list all animations
    };

    //setting current animation
    current=PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state,int amount){
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }
}
