import 'dart:math';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:juicyswipe/game_over_screen.dart';
import 'package:juicyswipe/models/fruit.dart';
import 'package:juicyswipe/widgets/heart_capsule.dart';

class GameScreen extends StatefulWidget {
  final double musicVolume;

  final double sfxVolume;
  const GameScreen({
    super.key,
    required this.musicVolume,
    required this.sfxVolume,
  });

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
    'blackBasket', //bomb basket
    'greenBasket',
    'yellowBasket',
  ];
  final List<String> fruitTypes = [
    'apple',
    'banana',
    'watermelon',
    'blueberry',
    'bomb',
    'life',
  ]; // image names in assets
  final Map<String, String> fruitColorMap = {
    'apple': 'red',
    'banana': 'yellow',
    'watermelon': 'green',
    'blueberry': 'blue',
    'bomb': 'black',
    'life': 'pink',
  };

  final double fruitSize = 60.0;

  final double baseFallSpeed = 0.005; // Base speed of falling fruits

  int currentCenterIndex = 0;

  //wrap around the index
  int getWrappedIndex(int index) {
    final length = baseBaskets.length;
    return (index % length + length) % length;
  }

  //sound
  final AudioPlayer sfxPlayerPop = AudioPlayer();
  final AudioPlayer sfxPlayerThud = AudioPlayer();
  final AudioPlayer sfxPlayerFall = AudioPlayer();
  final AudioPlayer sfxExplosion = AudioPlayer();
  final AudioPlayer sfxLife = AudioPlayer();
  final AudioPlayer music = AudioPlayer();

  final AudioContext sfxContext = AudioContext(
    android: AudioContextAndroid(
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.none,
      stayAwake: false,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: {AVAudioSessionOptions.mixWithOthers},
    ),
  );
  @override
  void initState() {
    super.initState();
    if (widget.musicVolume != 0) {
      music.setAudioContext(sfxContext);

      music.setReleaseMode(ReleaseMode.loop);
      music.play((AssetSource('music.mp3')));
      music.setVolume(widget.musicVolume);
    }
    final sfxPlayers = [
      sfxPlayerPop,
      sfxPlayerThud,
      sfxPlayerFall,
      sfxExplosion,
      sfxLife,
    ];

    for (var player in sfxPlayers) {
      player.setAudioContext(sfxContext);
    }
    sfxPlayerPop.setSource(AssetSource('pop.mp3'));
    sfxPlayerThud.setSource(AssetSource('thud.mp3'));
    sfxPlayerFall.setSource(AssetSource('fall.mp3'));
    sfxExplosion.setSource(AssetSource('explosion_sound.mp3'));
    sfxLife.setSource(AssetSource('life.mp3'));

    sfxPlayerThud.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(audioFocus: AndroidAudioFocus.none),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ),
    );

    resetGame();
  }

  DateTime lastSpawnTime = DateTime.now();

  void startSpawningFruits() {
    fruitSpawner = Timer.periodic(Duration(milliseconds: 100), (_) {
      int currentSpawnInterval = max(750, 2000 - score * 20);

      final now = DateTime.now();
      // Check if enough time has passed since the last spawn
      if (now.difference(lastSpawnTime).inMilliseconds >=
          currentSpawnInterval) {
        lastSpawnTime = now;

        // Spawn a new fruit
        //if score is less than 10, spawn only fruits
        //roll 10% bomb 5% heart
        final String fruitType;
        if (score >= 10) {
          final double roll = rng.nextDouble();
          if (roll <= 0.1) {
            fruitType = 'bomb';
          } else if (roll <= 0.15) {
            fruitType = 'life';
          } else {
            fruitType = fruitTypes[rng.nextInt(fruitTypes.length - 2)];
          }
        } else {
          fruitType = fruitTypes[rng.nextInt(fruitTypes.length - 2)];
        }

        final fruitColor = fruitColorMap[fruitType]!;

        final newFruit = FallingFruit(
          type: fruitType,
          color: fruitColor,
          xPosition: columnPositions[rng.nextInt(columnPositions.length)],
          yPosition: 0,
        );

        setState(() {
          fruits.add(newFruit);
        });

        animateFruit(newFruit);
      }
    });
  }

  void animateFruit(FallingFruit fruit) async {
    double fallSpeed = baseFallSpeed * (1 + (score * 0.03));
    fallSpeed = fallSpeed.clamp(0.005, 0.02); // Limit the speed to a range
    while (fruit.yPosition < collisionHeight &&
        !fruit.isCaught &&
        !isGameOver) {
      await Future.delayed(Duration(milliseconds: 16));
      setState(() {
        fruit.yPosition += fallSpeed;
      });
    }
    //once the fruit reaches the collision height,
    //check if it was caught or missed
    if (!fruit.isCaught && !isGameOver) {
      handleFruitLanding(fruit);
    }

    if (fruit.shouldFallThrough && !isGameOver) {
      while (fruit.yPosition < 1.2) {
        await Future.delayed(Duration(milliseconds: 16));

        // 1.2 = off bottom of screen
        setState(() {
          fruit.yPosition += fallSpeed;
        });
      }
      setState(() {
        fruits.removeWhere((f) => f.key == fruit.key);
      });
    }
  }

  List<String> get visibleBaskets => [
    baseBaskets[getWrappedIndex(currentCenterIndex - 1)],
    baseBaskets[getWrappedIndex(currentCenterIndex)],
    baseBaskets[getWrappedIndex(currentCenterIndex + 1)],
  ];

  void handleFruitLanding(FallingFruit fruit) async {
    int columnIndex = columnPositions.indexOf(fruit.xPosition);
    String basketColor = visibleBaskets[columnIndex].replaceAll('Basket', '');

    //extra life
    if (fruit.type == 'life' && basketColor != 'black') {
      setState(() {
        lives += 1;
        fruit.isCaught = true;
      });
      if (widget.sfxVolume != 0) {
        sfxLife.seek(Duration.zero);
        sfxLife.setVolume(widget.sfxVolume);
        sfxLife.play((AssetSource('life.mp3')));
      }
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          fruits.removeWhere((f) => f.key == fruit.key);
        });
      });
      return;
    }
    //bomb
    if (fruit.type == 'bomb' && basketColor != 'black') {
      setState(() {
        lives -= 1;
        showExplosion = true;
        if (lives <= 0) {
          isGameOver = true;
          fruitSpawner.cancel(); // stop spawning more
        }
      });
      if (widget.sfxVolume != 0) {
        sfxExplosion.seek(Duration.zero);
        sfxExplosion.setVolume(widget.sfxVolume);
        sfxExplosion.play(AssetSource('explosion_sound.mp3'));
      }
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          fruits.removeWhere((f) => f.key == fruit.key);
        });
      });
      // Hide the explosion after 1 second
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          showExplosion = false;
        });
      });

      return;
    }

    //fruit touches empty/bomb basket
    if (basketColor == 'black') {
      if (fruit.type == 'bomb') {
        setState(() {
          fruit.shouldFallThrough = true;
        });
      } else if (fruit.type == 'life') {
        // If it's a heart, it should fall through without losing a life
        setState(() {
          fruit.shouldFallThrough = true;
        });
      } else {
        setState(() {
          lives -= 1;
          fruit.shouldFallThrough = true;
          if (lives <= 0) {
            isGameOver = true;
            fruitSpawner.cancel(); // stop spawning more
          }
        });
      }
      if (widget.sfxVolume != 0) {
        sfxPlayerFall.seek(Duration.zero);
        sfxPlayerFall.setVolume(widget.sfxVolume);
        sfxPlayerFall.play(AssetSource('fall.mp3'));
      }

      return;
    }

    // Check if the fruit matches the basket color
    if (fruit.color == basketColor) {
      //if sound effects is on
      if (widget.sfxVolume != 0) {
        sfxPlayerPop.seek(Duration.zero);
        sfxPlayerPop.setVolume(widget.sfxVolume);
        sfxPlayerPop.play((AssetSource('pop.mp3')));
      }
      // Correct catch
      setState(() {
        fruit.isCaught = true;
        score += 1;
      });
    } else {
      if (widget.sfxVolume != 0) {
        sfxPlayerThud.seek(Duration.zero);
        sfxPlayerThud.setVolume(widget.sfxVolume);
        sfxPlayerThud.play((AssetSource('thud.mp3')));
      }

      // Missed or wrong basket
      setState(() {
        lives -= 1;
        fruit.isMissed = true;
        if (lives <= 0) {
          isGameOver = true;
          fruitSpawner.cancel(); // stop spawning more
        }
      });
    }
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        fruits.removeWhere((f) => f.key == fruit.key);
      });
    });
  }

  @override
  void dispose() {
    fruitSpawner.cancel();
    music.dispose();

    final sfxPlayers = [
      sfxPlayerPop,
      sfxPlayerThud,
      sfxPlayerFall,
      sfxExplosion,
      sfxLife,
    ];

    for (var player in sfxPlayers) {
      player.dispose();
    }

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

  //collision info
  int score = 0;
  int lives = 3;
  bool isGameOver = false;
  void resetGame() {
    setState(() {
      score = 0;
      lives = 3;
      isGameOver = false;
      fruits.clear();
      startSpawningFruits();
    });
  }

  final double collisionHeight = 0.75;
  bool hasNavigatedToGameOver = false;
  bool showExplosion = false;

  @override
  Widget build(BuildContext context) {
    if (isGameOver && !hasNavigatedToGameOver) {
      hasNavigatedToGameOver = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => GameOverScreen(
                  score: score,
                  musicVolume: widget.musicVolume,
                  sfxVolume: widget.sfxVolume,
                ),
          ),
        );
      });
    }

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
                children: [HeartCapsule(lives: lives)],
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
                    style: TextStyle(
                      fontFamily: 'LuckiestGuy',
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontFamily: 'LuckiestGuy',
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
                key: ValueKey(
                  '${fruit.key}-${fruit.isCaught}-${fruit.isMissed}',
                ),
                top: screenHeight * fruit.yPosition,
                left: (screenWidth / 2) * (fruit.xPosition + 1) - fruitSize / 2,
                child: TweenAnimationBuilder<Offset>(
                  tween:
                      fruit.isMissed
                          ? Tween<Offset>(
                            begin: Offset.zero,
                            end: Offset(screenWidth * 0.5, -screenHeight * 0.2),
                          )
                          : ConstantTween(Offset.zero),
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, offset, child) {
                    return Transform.translate(offset: offset, child: child);
                  },
                  child: TweenAnimationBuilder<double>(
                    tween:
                        fruit.isMissed
                            ? Tween<double>(begin: 1.0, end: 0.0)
                            : ConstantTween(1.0),
                    duration: Duration(milliseconds: 600),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: TweenAnimationBuilder<double>(
                          tween:
                              fruit.isCaught
                                  ? Tween<double>(begin: 1.0, end: 0.0)
                                  : ConstantTween<double>(1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            double scaleY =
                                value > 0.7 ? 1.0 - (1.0 - value) * 2.5 : value;
                            double scaleX =
                                value < 1.0 ? 1.0 + (1.0 - value) * 0.3 : 1.0;

                            return Transform.scale(
                              scaleY: scaleY.clamp(0.0, 1.0),
                              scaleX: scaleX.clamp(0.0, 1.3),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            'assets/${fruit.type}.png',
                            width: fruitSize,
                            height: fruitSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (showExplosion)
              AnimatedOpacity(
                opacity: showExplosion ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Center(
                  child: Image.asset(
                    'assets/explosion.png',
                    width: screenWidth * 0.9,
                    height: screenWidth * 0.9,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
