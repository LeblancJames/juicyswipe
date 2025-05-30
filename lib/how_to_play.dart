import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5D9),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * .12),
                Text(
                  'HOW TO PLAY',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .12,
                    color: Colors.brown,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenHeight * .04),
                Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF0B3),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Color(0xFFFFF0B3), // optional, but recommended
                      width: 1.0, // optional
                    ),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * .04),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [
                            SizedBox(width: screenWidth * .05),
                            Text(
                              'Swipe screen \nto move the\nbaskets',
                              style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * .06,
                                color: Colors.black,
                              ),
                            ),

                            Image.asset(
                              'assets/swipe_help.png',
                              width: screenWidth * .32,
                            ),
                            SizedBox(width: screenWidth * .05),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * .03),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [
                            SizedBox(width: screenWidth * .05),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Text(
                                  'Catch the\nfruits with\nthe matching\ncolor basket',
                                  style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * .06,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/all_fruits.png',
                              width: screenWidth * .36,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * .02),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(width: screenWidth * .05),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                Text(
                                  'Avoid the\nbombs, catch\nthe hearts!',
                                  style: TextStyle(
                                    fontFamily: 'Fredoka',
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * .06,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'assets/bomb_heart.png',
                              width: screenWidth * .36,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * .04,
            left: screenWidth * .02,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 32),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context); // Goes back to previous screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
