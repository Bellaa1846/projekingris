import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../models/question_model.dart';
import '../../models/q_dta_p_main_idea.dart';

class PracticeMainIdea extends StatefulWidget {
  const PracticeMainIdea({super.key});

  @override
  State<PracticeMainIdea> createState() => _PracticeMainIdeaState();
}

class _PracticeMainIdeaState extends State<PracticeMainIdea>
    with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;

  bool answerLocked = false;
  int? selectedIndex;

  /// 🔒 CONFETTI GUARD
  bool confettiPlayed = false;

  // Lottie preload
  late final Future<LottieComposition> _lottieEducation;
  late final Future<LottieComposition> _lottieStar;

  // Confetti
  late ConfettiController _confettiController;

  // Shake animation
  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  // Progress bar animation
  late AnimationController progressController;
  late Animation<double> progressAnimation;

  // 🔊 AUDIO PLAYER
  late AudioPlayer _audioPlayer;

  final List<Question> questions = mainIdeaPracticeQuestions;

  @override
  void initState() {
    super.initState();

    // Preload Lottie
    _lottieEducation = AssetLottie('assets/lottie/education.json').load();
    _lottieStar = AssetLottie('assets/lottie/star.json').load();

    // 🎉 Confetti
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 100),
    );

    // Shake animation
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: shakeController, curve: Curves.elasticIn),
    );

    // Progress bar
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(progressController);

    // 🔊 Audio
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    shakeController.dispose();
    progressController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// 🔊 PLAY SOUND
  Future<void> _playCorrectSound() async {
    await _audioPlayer.play(
      AssetSource('sound/correct.mp3'),
    );
  }

  Future<void> _playWrongSound() async {
    await _audioPlayer.play(
      AssetSource('sound/wrong.mp3'),
    );
  }

  void handleAnswer(int index) {
    if (answerLocked) return;

    setState(() {
      selectedIndex = index;
      answerLocked = true;
    });

    final correct = index == questions[currentQuestion].correctIndex;

    if (correct && !confettiPlayed) {
      confettiPlayed = true;
      score++;
      _confettiController.play();
      _playCorrectSound(); // ✅ SOUND BENAR
    } else if (!correct) {
      shakeController.forward().then((_) => shakeController.reverse());
      _playWrongSound(); // ❌ SOUND SALAH
    }

    progressController.forward(from: 0).whenComplete(_nextQuestion);
  }

  void _nextQuestion() {
    _confettiController.stop();
    confettiPlayed = false;

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedIndex = null;
        answerLocked = false;
      });
    } else {
      setState(() => quizFinished = true);
    }
  }

  void restartQuiz() {
    _confettiController.stop();
    setState(() {
      currentQuestion = 0;
      score = 0;
      quizFinished = false;
      answerLocked = false;
      selectedIndex = null;
      confettiPlayed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizFinished) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Main Idea Practice Result"),
          backgroundColor: const Color.fromARGB(255, 231, 231, 231),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: FutureBuilder<LottieComposition>(
                  future: _lottieStar,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Lottie(composition: snapshot.data!);
                    }
                    return const SizedBox(height: 200);
                  },
                ),
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
                onPressed: () => Navigator.pop(context),
                child: const Text("Return to Home"),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Main Idea Practice"),
            backgroundColor: const Color.fromARGB(255, 231, 231, 231),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pertanyaan ${currentQuestion + 1}/${questions.length}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    height: 200,
                    child: FutureBuilder<LottieComposition>(
                      future: _lottieEducation,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Lottie(composition: snapshot.data!);
                        }
                        return const SizedBox(height: 200);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // OPTIONS
                ...List.generate(question.options.length, (index) {
                  Color? color;
                  if (answerLocked) {
                    if (index == question.correctIndex) {
                      color = Colors.green;
                    } else if (index == selectedIndex) {
                      color = Colors.red;
                    } else {
                      color = Colors.grey.shade400;
                    }
                  }

                  return AnimatedBuilder(
                    animation: shakeAnimation,
                    builder: (context, child) {
                      final offset = shakeAnimation.value;
                      return Transform.translate(
                        offset: Offset(
                          answerLocked &&
                                  selectedIndex != question.correctIndex &&
                                  index == selectedIndex
                              ? (offset % 2 == 0 ? offset : -offset)
                              : 0,
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                        ),
                        onPressed: () => handleAnswer(index),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                if (answerLocked)
                  AnimatedBuilder(
                    animation: progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: progressAnimation.value,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.purple,
                      );
                    },
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // 🎉 CONFETTI
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 25,
            maxBlastForce: 15,
            minBlastForce: 10,
            emissionFrequency: 0.01,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }
}
