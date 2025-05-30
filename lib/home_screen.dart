import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:juicyswipe/how_to_play.dart';
import 'package:juicyswipe/widgets/sound_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'package:games_services/games_services.dart';

class HomeScreen extends StatefulWidget {
  final double musicVolume;
  final double sfxVolume;
  const HomeScreen({
    super.key,
    required this.musicVolume,
    required this.sfxVolume,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayer music;
  late double musicVolumeHome;
  late double sfxVolumeHome;
  @override
  void initState() {
    super.initState();
    // GamesServices.signIn();
    playMusic();
  }

  void playMusic() async {
    musicVolumeHome = widget.musicVolume;
    sfxVolumeHome = widget.sfxVolume;

    music = AudioPlayer();

    await music.play((AssetSource('music.mp3')));
    await music.setReleaseMode(ReleaseMode.loop);
    await music.setVolume(musicVolumeHome);
  }

  @override
  void dispose() {
    music.dispose();
    super.dispose();
  }

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
              children: [
                SizedBox(height: screenHeight * 0.15),
                Text(
                  'JUICY',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .26,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                Text(
                  'SWIPE',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: screenWidth * .26,
                    color: Colors.brown,
                    height: 1,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => GameScreen(
                              musicVolume: musicVolumeHome,
                              sfxVolume: sfxVolumeHome,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      220,
                      244,
                      161,
                      89,
                    ), // light orange
                    foregroundColor: const Color.fromARGB(
                      223,
                      255,
                      255,
                      255,
                    ), // text color
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: screenWidth * 0.055,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                    elevation: 4,
                    shadowColor: Colors.brown,
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.16,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.075,
                          right: screenWidth * 0.075,
                        ),
                        child: Text(
                          'PLAY',
                          style: TextStyle(
                            fontFamily: 'LuckiestGuy',
                            fontSize: screenWidth * 0.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const LeaderboardScreen(),
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(
                //       228,
                //       244,
                //       161,
                //       89,
                //     ), // light orange
                //     foregroundColor: const Color.fromARGB(
                //       204,
                //       255,
                //       255,
                //       255,
                //     ), // text color
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 0,
                //       vertical: screenWidth * 0.055,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(48),
                //     ),
                //     elevation: 4,
                //     shadowColor: Colors.brown,
                //   ),
                //   child: SizedBox(
                //     width: screenWidth * 0.45,
                //     height: screenWidth * 0.055,
                //     child: Center(
                //       child: Padding(
                //         padding: EdgeInsets.only(
                //           left: screenWidth * 0.05,
                //           right: screenWidth * 0.05,
                //         ),
                //         child: Text(
                //           'LEADERBOARD',
                //           style: TextStyle(
                //             fontFamily: 'LuckiestGuy',
                //             fontSize: screenWidth * 0.05,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * .02,
                horizontal: screenWidth * .05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Settings
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => CenteredSettingsDialog(
                              musicVolume: musicVolumeHome,
                              sfxVolume: sfxVolumeHome,
                              onVolumeChanged: (
                                newMusicVolume,
                                newSfxVolume,
                              ) async {
                                setState(() {
                                  musicVolumeHome = newMusicVolume;
                                  sfxVolumeHome = newSfxVolume;
                                  music.setVolume(musicVolumeHome);
                                });
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setDouble(
                                  'musicVolume',
                                  musicVolumeHome,
                                );
                                await prefs.setDouble(
                                  'sfxVolume',
                                  sfxVolumeHome,
                                );
                              },
                            ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
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
                        size: screenWidth * 0.1,
                      ),
                    ),
                  ),
                  // Help
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HowToPlayScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
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
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
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
