import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mestre_nr/app/my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//emulator -avd Pixel4 -accel on -gpu host

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_KEY'] ?? '');
  runApp(const MyApp());
}
