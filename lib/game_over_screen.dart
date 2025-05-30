import 'package:flutter/material.dart';
import 'package:juicyswipe/game_screen.dart';
import 'package:juicyswipe/home_screen.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final double musicVolume;
  final double sfxVolume;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.musicVolume,
    required this.sfxVolume,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.2), // 50% transparent black
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.15),
                Text(
                  'GAME',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .26,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                Text(
                  'OVER',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .26,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Your Score: $score',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .07,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => GameScreen(
                              musicVolume: musicVolume,
                              sfxVolume: sfxVolume,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      234,
                      244,
                      161,
                      89,
                    ), // light orange
                    foregroundColor: const Color.fromARGB(
                      226,
                      255,
                      255,
                      255,
                    ), // text color
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: screenWidth * 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                    elevation: 4,
                    shadowColor: Colors.brown,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.05,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                        ),
                        child: Text(
                          'PLAY AGAIN',
                          style: TextStyle(
                            fontFamily: 'LuckiestGuy',
                            fontSize: screenWidth * 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => HomeScreen(
                              musicVolume: musicVolume,
                              sfxVolume: sfxVolume,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      230,
                      244,
                      161,
                      89,
                    ), // light orange
                    foregroundColor: const Color.fromARGB(
                      234,
                      255,
                      255,
                      255,
                    ), // text color
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.10,
                      vertical: screenWidth * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                    elevation: 4,
                    shadowColor: Colors.brown,
                  ),

                  child: Padding(
                    padding: EdgeInsets.only(top: screenWidth * 0.02),
                    child: Text(
                      'QUIT',
                      style: TextStyle(
                        fontFamily: 'LuckiestGuy',
                        fontSize: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
