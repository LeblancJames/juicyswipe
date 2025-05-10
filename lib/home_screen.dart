import 'package:flutter/material.dart';
import 'package:juicyswipe/how_to_play.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5D9),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 84),
                Text(
                  'JUICY',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 88,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                Text(
                  'SWIPE',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 88,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A259), // light orange
                    foregroundColor: Colors.white, // text color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.brown,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.08,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'PLAY',
                          style: GoogleFonts.luckiestGuy(fontSize: 52),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A259), // light orange
                    foregroundColor: Colors.white, // text color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.brown,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.04,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'LEADERBOARD',
                          style: GoogleFonts.luckiestGuy(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Settings
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Color(0xFFF4A259),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  // Help
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Color(0xFFF4A259),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/help_icon.png',
                          width: 36,
                          height: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
