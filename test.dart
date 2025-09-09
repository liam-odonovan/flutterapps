import 'dart:ffi';

import 'package:flutter/material.dart';
import 'answer_button.dart';
import 'package:quiz/data/questions.dart';
import 'package:quiz/models/quiz_questions.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Quiz();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.func, {super.key, required this.title});


  final String title;
  final void Function() func;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: <Widget>[
              Image.asset(
                'assets/images/quiz-logo.png',
                width: 300,
                color: Color.fromARGB(150, 255, 255, 255),
              ),
              Text(
                widget.title,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.func,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                label: Text('Start Quiz',),
                icon: Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientContainer extends Container {
  GradientContainer({
    super.key,
    super.alignment,
    super.padding,
    super.color,
    super.decoration = const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    super.foregroundDecoration,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.transform,
    super.transformAlignment,
    super.child,
    super.clipBehavior = Clip.none,
  });
}

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String activeScreen = 'start-screen';
  List<QuizQuestion> correctList = [];
  List<QuizQuestion> wrongList = [];
  List<(QuizQuestion,String)> results = [];
  
  late List<QuizQuestion> questionsCopy;

  late QuizQuestion currentQuestion;

  @override
  void initState() {
    super.initState();
    questionsCopy = List.of(questions);
    _setNextQuestion();
  }

  void _setNextQuestion() {
    if (questionsCopy.isEmpty) {
      setState(() {
        activeScreen = 'results-screen';
      });
      return;
    }

    final randomIndex = Random().nextInt(questionsCopy.length);
    currentQuestion = questionsCopy[randomIndex];
  }

  void answerQuestion(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        correctList.add(currentQuestion);
      } else {
        wrongList.add(currentQuestion);
      }
      results.add((currentQuestion,selectedAnswer)); // HOW TO I ACCESS THE SELECTED ANSWER HERE TO PUT IT IN THE RESULTS 
      questionsCopy.remove(currentQuestion);
      _setNextQuestion();
    });
  }

  void startQuiz() {
    setState(() {
      activeScreen = 'question-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = MyHomePage(startQuiz, title: 'Learn flutter the fun way!');

    if (activeScreen == 'question-screen') {
      screenWidget = QuestionPage(
        currentQuestion: currentQuestion,
        answerQuestion: answerQuestion,
      );
    } else if (activeScreen == 'results-screen') {
      screenWidget = ResultsPage(results: results);
    }

    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: screenWidget,
    );
  }
}


class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.currentQuestion,
    required this.answerQuestion,
  });

  final QuizQuestion currentQuestion;
  final void Function(bool isCorrect) answerQuestion;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GradientContainer(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.currentQuestion.text,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 246, 222, 255),
                ),
                textAlign: TextAlign.center),
              SizedBox(height:30),
              ...List.generate(
                widget.currentQuestion.answers.length,
                (i) => AnswerButton(
                  widget.currentQuestion.answers[i],
                  () => widget.answerQuestion(i == 0),
                ),
              ),              
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
    required this.results,
  });

  final List<QuizQuestion> results;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GradientContainer2(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Results',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
              SizedBox(height:30),
            ],
          ),
        ),
      ),
    );
  }
}