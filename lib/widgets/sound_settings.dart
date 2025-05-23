import 'package:flutter/material.dart';

class CenteredSettingsDialog extends StatefulWidget {
  const CenteredSettingsDialog({super.key});

  @override
  State<CenteredSettingsDialog> createState() => _CenteredSettingsDialogState();
}

class _CenteredSettingsDialogState extends State<CenteredSettingsDialog> {
  double musicVolume = 0.5;
  double sfxVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Color(0xFFF4A259),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                color: Colors.brown,
                fontSize: screenWidth * .1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 1,
              decoration: BoxDecoration(
                color: Colors.brown,
                border: Border(bottom: BorderSide(color: Colors.brown)),
              ),
            ),
            SizedBox(height: 24),
            Text('Music Volume'),
            Slider(
              value: musicVolume,
              onChanged: (value) {
                setState(() => musicVolume = value);
                // TODO: update music player volume
                // music.setVolume(musicVolume);
              },
              thumbColor: Colors.brown,
              activeColor: Colors.brown,
              min: 0,
              max: 1,
            ),
            const SizedBox(height: 12),
            Text('SFX Volume'),
            Slider(
              value: sfxVolume,
              onChanged: (value) {
                setState(() => sfxVolume = value);
                // TODO: update sfx player volume
                // sfxPlayer.setVolume(sfxVolume);
              },
              thumbColor: Colors.brown,
              activeColor: Colors.brown,
              min: 0,
              max: 1,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
