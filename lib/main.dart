import 'package:flutter/material.dart';
import 'package:juicyswipe/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final double? musicVolume = prefs.getDouble('musicVolume');
  final double? sfxVolume = prefs.getDouble('sfxVolume');
  runApp(
    FruitCatchApp(musicVolume: musicVolume ?? 0.5, sfxVolume: sfxVolume ?? 0.5),
  );
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
