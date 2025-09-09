import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/models/quiz_questions.dart';

class ResultBar extends StatelessWidget {
  final int qNum;
  final ({QuizQuestion q,String a,bool b}) result; 
  
  const ResultBar({
    required this.qNum,
    required this.result,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: result.b
            ? Colors.greenAccent
            : Colors.redAccent,
          radius: 25,
          child: Text('$qNum',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 200,
          height: 150,
          child: Text(result.q.text,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your Answer',
              style: GoogleFonts.lato(),
              selectionColor: Colors.white,
            ),
            Text(result.a)
          ],
        ),
      ],
    );
  }

}