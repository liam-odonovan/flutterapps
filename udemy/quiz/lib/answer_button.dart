import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final void Function() func;

  const AnswerButton(this.answerText, this.func, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: WidgetStateProperty.all(Colors.deepPurpleAccent),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4
          ),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        side: WidgetStateProperty.all(BorderSide.none),
        enableFeedback: false,
        splashFactory: NoSplash.splashFactory,
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        answerText,
        textAlign:TextAlign.center,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}