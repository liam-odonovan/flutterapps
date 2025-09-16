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
        Column(
          children: [
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
            Row(
              children: [
                AnswerColumn(header: 'Your Answer', answer: result.a,),
                AnswerColumn(header: 'Correct Answer', answer: result.q.answers[0]),
              ],
            ),
          ],
        ),
      ],
    );
  }

}

class AnswerColumn extends StatelessWidget {
  const AnswerColumn({
    super.key,
    required this.answer,
    required this.header,

  });

  final String answer;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(header,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
                color: Colors.white,
                fontSize: 26
              ),
            ),
          ),
          Text(answer,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ),
        ],
      ),
    );
  }
}