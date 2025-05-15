import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juicyswipe/models/fruit.dart';
import 'package:juicyswipe/widgets/heart_capsule.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late double screenWidth;
  late double screenHeight;
  List<FallingFruit> fruits = [];
  late Timer fruitSpawner;
  final Random rng = Random();
  final List<double> columnPositions = [
    -0.7,
    0.0,
    0.7,
  ]; // Left, center, right, which columns to spawn fruits in

  final List<String> baseBaskets = [
    'blueBasket',
    'redBasket',
    'greenBasket',
    'yellowBasket',
    'empty',
  ];
  final List<String> fruitTypes = [
    'apple',
    'banana',
    'watermelon',
    'blueberry',
  ]; // image names in assets
  final double fruitSize = 60.0;

  int currentCenterIndex = 0;

  int getWrappedIndex(int index) {
    final length = baseBaskets.length;
    return (index % length + length) % length;
  }

  @override
  void initState() {
    super.initState();
    startSpawningFruits();
  }

  void startSpawningFruits() {
    fruitSpawner = Timer.periodic(Duration(seconds: 2), (_) {
      final newFruit = FallingFruit(
        type:
            fruitTypes[rng.nextInt(
              fruitTypes.length,
            )], //pick a random fruit type from the list
        xPosition: columnPositions[rng.nextInt(columnPositions.length)],
        yPosition: 0,
      );

      setState(() {
        fruits.add(newFruit);
      });

      animateFruit(newFruit);
    });
  }

  void animateFruit(FallingFruit fruit) async {
    while (fruit.yPosition < 1.0) {
      await Future.delayed(Duration(milliseconds: 16));
      setState(() {
        fruit.yPosition += 0.01;
      });
    }

    handleMissedFruit(fruit);
  }

  void handleMissedFruit(FallingFruit fruit) {
    setState(() {
      fruits.removeWhere((f) => f.key == fruit.key);
    });

    // TODO: deduct a life or show missed animation
  }

  @override
  void dispose() {
    fruitSpawner.cancel();
    super.dispose();
  }

  Widget _buildBasket(int index) {
    final basket = baseBaskets[index];
    if (basket == 'empty') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SizedBox(width: screenWidth * 0.32, height: screenWidth * 0.32),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Image.asset(
        'assets/$basket.png',
        width: screenWidth * 0.32,
        height: screenWidth * 0.32,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          setState(() {
            if (details.primaryVelocity! < 0) {
              // swipe left → next
              currentCenterIndex = getWrappedIndex(currentCenterIndex + 1);
            } else if (details.primaryVelocity! > 0) {
              // swipe right → previous
              currentCenterIndex = getWrappedIndex(currentCenterIndex - 1);
            }
          });
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Heart capsule
            Positioned(
              top: screenWidth * 0.1,
              left: screenWidth * 0.025,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [HeartCapsule(lives: 3)],
              ),
            ),

            // Score
            Positioned(
              top: screenWidth * 0.12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score: ',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '1110',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Basket Row
            Positioned(
              bottom: screenHeight * 0.075,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBasket(getWrappedIndex(currentCenterIndex - 1)),
                  _buildBasket(currentCenterIndex),
                  _buildBasket(getWrappedIndex(currentCenterIndex + 1)),
                ],
              ),
            ),
            ...fruits.map(
              (fruit) => Positioned(
                key: fruit.key,
                top: screenHeight * fruit.yPosition,
                left: (screenWidth / 2) * (fruit.xPosition + 1) - fruitSize / 2,
                child: Image.asset(
                  'assets/${fruit.type}.png',
                  width: fruitSize,
                  height: fruitSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
