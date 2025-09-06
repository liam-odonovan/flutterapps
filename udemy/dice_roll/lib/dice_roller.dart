import 'package:flutter/material.dart';
import 'dart:math';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {
  int dieRoll = 6;
  String get dieImageGetter => 'assets/images/dice_images/dice-$dieRoll.png';
  
  // late String dieImage;
  // @override
  // void initState() {
  //   super.initState();
  //   String dieImage = 'assets/images/dice_images/dice-$dieRoll.png';
  // }

  void rollDice() {
    setState(() {
      dieRoll = randomizer.nextInt(6) + 1;
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              dieImageGetter,
              width: 200
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {rollDice();},                 
              style: TextButton.styleFrom(
                  // alternative to sizedbox  // padding: const EdgeInsets.only(top: 20),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 28,),
                  ),
              child: Text('Roll Die'),
            ),
          ], 
        );
  }
}