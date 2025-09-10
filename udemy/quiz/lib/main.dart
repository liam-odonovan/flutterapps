import 'package:flutter/material.dart';
import 'answer_button.dart';
import 'results_bar.dart';
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final void Function() func;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      
      body: GradientContainer(
        child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
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
              // FloatingActionButton.extended(
              //   onPressed: _startQuiz,
              //   label: Text(
              //     'Start Quiz',
              //     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              //       color: Colors.white,
              //       ),
              //   ),
              // ),
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

// class _QuizState extends State<Quiz> {
//   late Widget activeScreen;

//   @override
//   void initState() {
//     super.initState();
//     activeScreen = MyHomePage(
//     startQuiz,
//     title: 'Learn Flutter the fun way!'
//    );
//   }

//   void startQuiz() {
//     setState(() {
//       activeScreen = const QuestionPage();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quiz App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: activeScreen,
//     );
//   }
// }



class _QuizState extends State<Quiz> {
  String activeScreen = 'start-screen';
  int numCorrect = 0;
  List<QuizQuestion> correctList = [];
  List<QuizQuestion> wrongList = [];
  List<({QuizQuestion q, String a, bool b})> results = [];
  
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

  // void answerQuestion(bool isCorrect, String selectedAnswer) {
  //   setState(() {
  //     if (isCorrect) {
  //       correctList.add(currentQuestion);
  //     } else {
  //       wrongList.add(currentQuestion);
  //     }
  //     results.add((currentQuestion,selectedAnswer));
  //     questionsCopy.remove(currentQuestion);
  //     _setNextQuestion();
  //   });
  // }

   void answerQuestion(bool isCorrect, String selectedAnswer) {
    setState(() {
      if (isCorrect) {numCorrect++;}
      results.add((q: currentQuestion, a: selectedAnswer, b: isCorrect));
      questionsCopy.remove(currentQuestion);
      _setNextQuestion();
    });
  }

  // void correct() {
  //   setState(() {
  //     correctList.add(questionsCopy[currentQuestionIndex]);
  //     questionsCopy.removeAt(currentQuestionIndex);
  //     if (questionsCopy.isEmpty) {
  //       activeScreen = 'resutls-screen';
  //     }
  //   });
  // }

  // void wrong() {
  //   setState(() {
  //     wrongList.add(questionsCopy[currentQuestionIndex]);
  //     questionsCopy.removeAt(currentQuestionIndex);
  //     if (questionsCopy.isEmpty) {
  //       activeScreen = 'resutls-screen';
  //     }
  //   });
  // }

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
      screenWidget = ResultsPage(numCorrect: numCorrect, results: results);
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
  final void Function(bool isCorrect, String selectedAnswer) answerQuestion;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // var randomizer = Random();
  // late int currentQuestionIndex = randomizer.nextInt(widget.questionsRemaining.length);
  // void nextQuestion() {
  //   setState(() {
  //     widget.questionsRemaining.removeAt(currentQuestionIndex);
  //     if (widget.questionsRemaining.isEmpty) {
  //       SET ACTIVE SCREEN?????;
  //     } else {
  //       currentQuestionIndex = randomizer.nextInt(widget.questionsRemaining.length);
  //     }
  //   });
  // }

  // late QuizQuestion currentQuestion = widget.questionsRemaining[currentQuestionIndex];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final answersCopy = List<String>.from(widget.currentQuestion.answers);
    final randomizedAnswerButtonList = <AnswerButton>[];

    while (answersCopy.isNotEmpty) {
      final index = random.nextInt(answersCopy.length);
      final answer = answersCopy[index];

      randomizedAnswerButtonList.add(
        AnswerButton(
          answer,
          () => widget.answerQuestion(
            answer == widget.currentQuestion.answers[0],
            answer,
          ),
        ),
      );
      answersCopy.removeAt(index);
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: GradientContainer(
          child: Container(
            margin: const EdgeInsets.all(40),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.currentQuestion.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 246, 222, 255),
                  ),
                ),
                SizedBox(height:30),
                // ...randomizedAnswerButtonList,

                // ...List.generate(
                //   widget.currentQuestion.answers.length,
                //   (i) => AnswerButton(
                //     widget.currentQuestion.answers[i],
                //     () => widget.answerQuestion(
                //       i == 0,
                //       widget.currentQuestion.answers[i],
                //       ),
                //   ),
                // ),
            
                // ...[
                for (var i = 0; i < widget.currentQuestion.answers.length; i++) 
                  AnswerButton(
                  widget.currentQuestion.answers[i],
                  () => widget.answerQuestion(
                    i == 0,
                    widget.currentQuestion.answers[i],
                    ),
                ),
                // ],
            
                // ...currentQuestion.answers.asMap()
                // .map((i, q) => MapEntry(i, AnswerButton(q, i == 0 ? () => correct : () => wrong)))
                // .values,
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    super.key,
    required this.numCorrect,
    required this.results,
  });

  final int numCorrect;
  final List<({QuizQuestion q, String a, bool b})> results;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final List<ResultBar> resultBarList = [];
  

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        child: GradientContainer(
          child: Container(
            margin: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Results',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 36,
                    ),
                  ),
                ),
                Text('You got ${widget.numCorrect}/${widget.results.length} correct.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height:5),
                ...List.generate(
                  widget.results.length,
                  (i) => ResultBar(
                    qNum: i + 1,
                    result: widget.results[i]
                  )                    
                ),                
              ],
            ),
          ),
        ),
      ),
    );
  }
}