import 'package:flutter/material.dart';
import 'dice_roller.dart';

const startAlign = Alignment.topLeft;
const endAlign = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer(
    {super.key,
    this.colorList = const [Colors.cyan, Colors.white]}
  );

  const GradientContainer.blackToWhite(Key? key) : 
    this(
      key: key,
      colorList: const [Colors.black, Colors.white]
    );

  final List<Color> colorList;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorList,
          begin: startAlign,
          end: endAlign,
        ),
      ),
      child: Center(
        child: DiceRoller(),
      ),
    );
  }
}

