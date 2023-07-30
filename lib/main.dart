import 'package:eccentric_pixel/eccentric_pixel.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //wait for flutter to get initialised
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  EccentricPixel game=EccentricPixel();
  runApp( GameWidget(game: kDebugMode? EccentricPixel(): game));
}
