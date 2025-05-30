import 'package:flutter/material.dart';

class HeartCapsule extends StatelessWidget {
  final int lives;

  const HeartCapsule({super.key, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 0, right: 16, bottom: 0),
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
            child: Image.asset('assets/heart.png', width: 46, height: 46),
          ),
          const SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'x $lives',
              style: TextStyle(
                fontFamily: 'LuckiestGuy',
                fontSize: 24,
                color: Colors.black,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
