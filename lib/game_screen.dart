import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late double screenWidth;
  late double screenHeight;
  final List<String> basketList = [
    'blueBasket',
    'redBasket',
    'greenBasket',
    'yellowBasket',
    'empty',
  ];

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 24,
            left: 24,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Heart Capsule
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 0,
                    right: 16,
                    bottom: 0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9B3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Image.asset(
                          'assets/heart.png',
                          width: 46,
                          height: 46,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'x 3',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 24,
                            color: Colors.black,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // score
          Positioned(
            top: 34,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Score: 0',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Basket Row (bottom)
          // Basket Row (bottom)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: screenHeight * 0.18, // scale with screen height
              child: PageView.builder(
                controller: PageController(viewportFraction: 1 / 3),
                itemCount: basketList.length,
                physics: const ClampingScrollPhysics(), // smoother swipe
                itemBuilder: (context, index) {
                  final basket = basketList[index];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (basket == 'empty') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          'assets/$basket.png',
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
