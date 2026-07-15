// Minimal Flutter app entrypoint
import 'package:flutter/material.dart';
import 'game/flapping_bird_game.dart';

void main() {
  runApp(const FlappyBirdApp());
}

class FlappyBirdApp extends StatelessWidget {
  const FlappyBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird Ultra',
      home: const Scaffold(
        body: Center(
          child: Text('Game placeholder — run FlappingBirdGame here'),
        ),
      ),
    );
  }
}
