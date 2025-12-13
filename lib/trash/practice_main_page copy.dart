import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import '../models/question_model.dart';
import '../models/main_practice_question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;

  int? selectedIndex;
  bool answered = false;

  late ConfettiController _confettiController;
  late AnimationController _progressController;

  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    questions = questionsData;

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void answerQuestion(int index) {
    if (answered) return;

    setState(() {
      selectedIndex = index;
      answered = true;
    });

    final correct = questions[currentQuestion].correctIndex;

    if (index == correct) {
      score++;
      _confettiController.play();
    }

    _progressController.forward(from: 0);

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          selectedIndex = null;
          answered = false;
        });
      } else {
        setState(() {
          quizFinished = true;
        });
      }
    });
  }

  Color getButtonColor(int index) {
    if (!answered) return Colors.purple;

    final correct = questions[currentQuestion].correctIndex;

    if (index == selectedIndex) {
      return index == correct ? Colors.green.shade700 : Colors.red.shade700;
    }

    if (index == correct) {
      return Colors.green.shade700;
    }

    return Colors.grey.shade400;
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      quizFinished = false;
      selectedIndex = null;
      answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Main Idea Practice Result"),
          backgroundColor: Color.fromARGB(255, 231, 231, 231),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Lottie.asset('assets/lottie/star.json'),
              ),

              const Text("Your Score:", style: TextStyle(fontSize: 28)),
              const SizedBox(height: 10),
              Text(
                "$score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: restartQuiz,
                child: const Text("Try Again"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("Return to Home"),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Idea Practice"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Stack(
        children: [
          // CONFETTI ============================================================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.01,
                numberOfParticles: 25,
                gravity: 0.3,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pertanyaan ${currentQuestion + 1}/${questions.length}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),

                Center(
                  child: SizedBox(
                    height: 230,
                    child: Lottie.asset('assets/lottie/education.json'),
                  ),
                ),

                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                ...List.generate(question.options.length, (index) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: answered ? null : () => answerQuestion(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getButtonColor(index),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(question.options[index]),
                    ),
                  );
                }),

                const SizedBox(height: 40),
              ],
            ),
          ),

          if (answered)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 6,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, __) => LinearProgressIndicator(
                    value: _progressController.value,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
