import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../models/question_model.dart';
import '../../models/main_practice_question.dart';

class PracticeMainIdea extends StatefulWidget {
  const PracticeMainIdea({super.key});

  @override
  State<PracticeMainIdea> createState() => _PracticeMainIdeaState();
}

class _PracticeMainIdeaState extends State<PracticeMainIdea>
    with TickerProviderStateMixin {
  // ===================== STATE =====================
  int _currentQuestionIndex = 0;
  int _score = 0;

  bool _quizFinished = false;
  bool _answerLocked = false;
  int? _selectedIndex;

  // ===================== CONTROLLERS =====================
  late final ConfettiController _confettiController;
  late final AudioPlayer _audioPlayer;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  // ===================== LOTTIE =====================
  late final Future<LottieComposition> _educationLottie;
  late final Future<LottieComposition> _starLottie;

  final List<Question> _questions = mainIdeaPracticeQuestions;

  // ===================== INIT =====================
  @override
  void initState() {
    super.initState();
    _initLottie();
    _initAudio();
    _initConfetti();
    _initAnimations();
  }

  void _initLottie() {
    _educationLottie = AssetLottie('assets/lottie/education.json').load();
    _starLottie = AssetLottie('assets/lottie/star.json').load();
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer();
  }

  void _initConfetti() {
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 300),
    );
  }

  void _initAnimations() {
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
  }

  // ===================== DISPOSE =====================
  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    _shakeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // ===================== AUDIO =====================
  Future<void> _playCorrectSound() async {
    await _audioPlayer.play(AssetSource('sound/correct.mp3'));
  }

  Future<void> _playWrongSound() async {
    await _audioPlayer.play(AssetSource('sound/wrong.mp3'));
  }

  // ===================== LOGIC =====================
  void _handleAnswer(int index) {
    if (_answerLocked) return;

    setState(() {
      _selectedIndex = index;
      _answerLocked = true;
    });

    final isCorrect = index == _questions[_currentQuestionIndex].correctIndex;

    if (isCorrect) {
      _score++;
      _confettiController.play();
      _playCorrectSound();
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
      _playWrongSound();
    }

    _progressController.forward(from: 0).whenComplete(_nextQuestion);
  }

  void _nextQuestion() {
    _confettiController.stop();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedIndex = null;
        _answerLocked = false;
      });
    } else {
      setState(() => _quizFinished = true);
    }
  }

  void _restartQuiz() {
    _confettiController.stop();
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizFinished = false;
      _answerLocked = false;
      _selectedIndex = null;
    });
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return _quizFinished ? _buildResultScreen() : _buildQuizScreen();
  }

  // ===================== RESULT SCREEN =====================
  Widget _buildResultScreen() {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Idea Result"),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 240,
              child: FutureBuilder<LottieComposition>(
                future: _starLottie,
                builder: (_, snapshot) =>
                    snapshot.hasData ? Lottie(composition: snapshot.data!) : const SizedBox(),
              ),
            ),
            Text("Your Score", style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              "$_score / ${_questions.length}",
              style: textTheme.bodyLarge!.copyWith(
                fontSize: 36,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _restartQuiz,
              child: const Text("Try Again"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Lesson"),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== QUIZ SCREEN =====================
  Widget _buildQuizScreen() {
    final question = _questions[_currentQuestionIndex];
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Main Idea Practice"),
            backgroundColor: Colors.grey.shade200,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: LinearProgressIndicator(
                value: _currentQuestionIndex / _questions.length,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                color: Colors.purple,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                  style: textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLottieHeader(),
                const SizedBox(height: 16),
                Text(
                  question.text,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 28),
                ..._buildOptions(question),
                if (_answerLocked) _buildProgressBar(),
              ],
            ),
          ),
        ),
        _buildConfetti(),
      ],
    );
  }

  Widget _buildLottieHeader() {
    return Center(
      child: SizedBox(
        height: 180,
        child: FutureBuilder<LottieComposition>(
          future: _educationLottie,
          builder: (_, snapshot) =>
              snapshot.hasData ? Lottie(composition: snapshot.data!) : const SizedBox(),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(Question question) {
    final textTheme = Theme.of(context).textTheme;

    return List.generate(question.options.length, (index) {
      Color? backgroundColor;

      if (_answerLocked) {
        if (index == question.correctIndex) {
          backgroundColor = Colors.green;
        } else if (index == _selectedIndex) {
          backgroundColor = Colors.red;
        } else {
          backgroundColor = Colors.grey.shade400;
        }
      }

      return AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (_, child) {
          final offset =
              (_answerLocked && index == _selectedIndex && index != question.correctIndex)
                  ? (_shakeAnimation.value % 2 == 0
                      ? _shakeAnimation.value
                      : -_shakeAnimation.value)
                  : 0.0;

          return Transform.translate(offset: Offset(offset, 0), child: child);
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 14),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _handleAnswer(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                question.options[index],
                style: textTheme.labelLarge!.copyWith(
                  color: _answerLocked ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (_, __) => LinearProgressIndicator(
        value: _progressAnimation.value,
        backgroundColor: Colors.grey.shade300,
        color: Colors.purple,
      ),
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 20,
        gravity: 0.3,
      ),
    );
  }
}
