import 'dart:async';

import 'package:eccentric_pixel/components/utils.dart';
import 'package:eccentric_pixel/eccentric_pixel.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'collision_block.dart';

enum PlayerState { idle, running }

//enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<EccentricPixel>, KeyboardHandler {
  String character;
  Player({this.character='Virtual Guy', position}) : super(position: position);
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300; //at the end friction air pressure comes into action and the speed slows a bit (Physics)

 // PlayerDirection playerDirection = PlayerDirection.none; ///apparently there is a better way to decide the player direction therefore commenting the unused old code
  double horizontalMovement=0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks=[];
  //bool isFacingRight = true;
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode=true;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // implement update
    _updatePlayerMovement(dt);
    _updatePlayerState();
    _checkHorizontalMovement();
    _applyGravity(dt); //must be after checking horizontal collisions becuase otherwise we would hit the the ground then again would be colliding
    _checkVerticalMovement();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement=0.0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed? -1 : 0; //new code instead of the if else ladder using playerDirection
    horizontalMovement += isRightKeyPressed? 1 : 0;
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation("Idle", 11);
    runningAnimation = _spriteAnimation("Run", 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation, //list all animations
    };

    //setting current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState=PlayerState.idle;
    if(velocity.x<0 && scale.x>0) {
      flipHorizontallyAroundCenter();
    } else if(velocity.x>0 && scale.x<0) {
      flipHorizontallyAroundCenter();
    }

    if(velocity.x>0 || velocity.x<0)
      {
        playerState=PlayerState.running;
      }
    current = playerState;
  }

  void _checkHorizontalMovement() {
    for(final block in collisionBlocks){
        //handle collisions
        //here we have made our  own collisions so we have to hard code it's cases and we are not using the flame collisions which were built in
      if(!block.isPlatform)
        {
          if(checkCollision(this, block))
            {
              if(velocity.x>0)
                {
                  velocity.x = 0;
                  position.x = block.x - width;
                }

              if(velocity.x<0)
              {
                velocity.x = 0;
                position.x = block.x + block.width + width;
              }
            }
        }

    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalMovement() {
    for(final block in collisionBlocks)
      {
          if(block.isPlatform)
            {

            }
          else
            {
              if(checkCollision(this, block))
                {
                  if(velocity.y>0)
                    {
                      velocity.y=0;
                       position.y =block.y - width;
                    }
                }
            }
      }
  }
}
