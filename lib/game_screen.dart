import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:juicyswipe/widgets/heart_capsule.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late double screenWidth;
  late double screenHeight;

  final List<String> baseBaskets = [
    'blueBasket',
    'redBasket',
    'greenBasket',
    'yellowBasket',
    'empty',
  ];

  int currentCenterIndex = 0;

  int getWrappedIndex(int index) {
    final length = baseBaskets.length;
    return (index % length + length) % length;
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
          ],
        ),
      ),
    );
  }
}
