import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mestre_nr/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//emulator -avd Pixel4 -accel on -gpu host

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
