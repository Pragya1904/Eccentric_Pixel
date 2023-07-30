import 'package:eccentric_pixel/eccentric_pixel.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  //without await it would work fine on emulators and debug mode but when it is installed and built then it first is in portrait mode so would takes some moments to switch to landscape which can disrupt user experience
  WidgetsFlutterBinding.ensureInitialized(); //wait for flutter to get initialised
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  EccentricPixel game=EccentricPixel();
  runApp( GameWidget(game: kDebugMode? EccentricPixel(): game));
}
