import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';

import '../../models/question_model.dart';
import '../../models/q_dta_find.dart';

class FindMainIdea extends StatefulWidget {
  const FindMainIdea({super.key});

  @override
  State<FindMainIdea> createState() => _FindMainIdeaState();
}

class _FindMainIdeaState extends State<FindMainIdea>
    with TickerProviderStateMixin {
  late List<Question> questions;
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;

  int? selectedIndex;
  bool answered = false;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _progressController;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // AMBIL 5 SOAL RANDOM DARI 15 SOAL
    questions = List.of(mainIdeaQuestions)..shuffle();
    questions = questions.take(5).toList();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _progressController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void answerQuestion(int index) {
    if (answered) return;

    setState(() {
      selectedIndex = index;
      answered = true;
    });

    final question = questions[currentQuestion];
    bool isCorrect = index == question.correctIndex;

    if (isCorrect) {
      score++;
      _confettiController.play();
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
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

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Find Main Idea Result"),
          backgroundColor: const Color.fromARGB(255, 231, 231, 231),
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
                onPressed: () {
                  setState(() {
                    // RESET — ambil 5 soal random baru
                    questions = List.of(mainIdeaQuestions)..shuffle();
                    questions = questions.take(5).toList();

                    currentQuestion = 0;
                    score = 0;
                    selectedIndex = null;
                    answered = false;
                    quizFinished = false;
                  });
                },
                child: const Text("Try Again"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
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
        title: const Text("Find Main Idea"),
        backgroundColor: Colors.purple.shade200,
      ),
      body: Stack(
        children: [
          // CONFETTI
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 25,
                maxBlastForce: 10,
                minBlastForce: 5,
                emissionFrequency: 0.01,
                gravity: 0.3,
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              double offset = _shakeAnimation.value;
              return Transform.translate(
                offset: Offset(offset % 2 == 0 ? offset : -offset, 0),
                child: child,
              );
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pertanyaan ${currentQuestion + 1}/${questions.length}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Center(
                      child: SizedBox(
                        height: 200,
                        child: Lottie.asset('assets/lottie/person.json'),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ...List.generate(question.options.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (states) => getButtonColor(index),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        onPressed:
                            answered ? null : () => answerQuestion(index),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }),
                ],
              ),
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
                  builder: (context, _) {
                    return LinearProgressIndicator(
                      value: _progressController.value,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.purple,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
