import 'package:flutter/material.dart';
import 'package:juicyswipe/home_screen.dart';

void main() {
  runApp(const FruitCatchApp());
}

class FruitCatchApp extends StatelessWidget {
  const FruitCatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruit Catcher',
      theme: ThemeData(fontFamily: 'ComicSans', useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
