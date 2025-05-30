import 'package:flutter/material.dart';
import 'package:juicyswipe/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final double musicVolume = prefs.getDouble('musicVolume') ?? 0.05;
  final double sfxVolume = prefs.getDouble('sfxVolume') ?? 0.5;
  runApp(FruitCatchApp(musicVolume: musicVolume, sfxVolume: sfxVolume));
}

class FruitCatchApp extends StatelessWidget {
  final double musicVolume;
  final double sfxVolume;
  const FruitCatchApp({
    super.key,
    required this.musicVolume,
    required this.sfxVolume,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Catcher',
      theme: ThemeData(fontFamily: 'ComicSans', useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(musicVolume: musicVolume, sfxVolume: sfxVolume),
    );
  }
}
