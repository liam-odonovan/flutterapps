import 'package:flutter/material.dart';
import 'gradient_container.dart';
// same as import 'package:dice_roll/gradient_container.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)
      ),
      home: Scaffold(
        body: GradientContainer(
          colorList: [
            Colors.deepPurple, Colors.indigo
          ]
        ),
        ),
    ),
  );
}

