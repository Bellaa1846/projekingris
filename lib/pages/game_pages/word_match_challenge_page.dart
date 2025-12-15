import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../database/db_helper.dart';

class WordMatchChallengePage extends StatefulWidget {
  const WordMatchChallengePage({super.key});

  @override
  State<WordMatchChallengePage> createState() =>
      _WordMatchChallengePageState();
}

class _WordMatchChallengePageState extends State<WordMatchChallengePage>
    with TickerProviderStateMixin {

  // ================= DATA =================
  final List<Map<String, String>> _pairs = [
    {"word": "Happy", "meaning": "Feeling joyful"},
    {"word": "Brave", "meaning": "Not afraid"},
    {"word": "Smart", "meaning": "Very intelligent"},
    {"word": "Angry", "meaning": "Feeling mad"},
    {"word": "Fast", "meaning": "Moving quickly"},
    {"word": "Honest", "meaning": "Always telling the truth"},
    {"word": "Kind", "meaning": "Caring and friendly"},
    {"word": "Strong", "meaning": "Having great power"},
    {"word": "Quiet", "meaning": "Making little noise"},
    {"word": "Careful", "meaning": "Avoiding danger or mistakes"},
  ];

  late List<String> _words;
  late List<String> _meanings;

  String? _selectedWord;
  String? _selectedMeaning;

  final Set<String> _matchedWords = {};
  final Set<String> _matchedMeanings = {};

  int _score = 0;
  bool _gameFinished = false;
  bool _achievementSaved = false;

  late final AudioPlayer _sfxPlayer;
  late final AudioPlayer _bgmPlayer;
  late final ConfettiController _confettiController;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _words = _pairs.map((e) => e["word"]!).toList();
    _meanings = _pairs.map((e) => e["meaning"]!).toList()..shuffle();

    _sfxPlayer = AudioPlayer();
    _bgmPlayer = AudioPlayer();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _playBgm();
  }

  @override
  void dispose() {
    _sfxPlayer.dispose();
    _bgmPlayer.dispose();
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _playBgm() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(0.35);
    await _bgmPlayer.play(AssetSource('sound/game1.mp3'));
  }

  // ================= LOGIC =================
  void _selectWord(String word) {
    if (_matchedWords.contains(word) || _gameFinished) return;
    setState(() => _selectedWord = word);
    _checkMatch();
  }

  void _selectMeaning(String meaning) {
    if (_matchedMeanings.contains(meaning) || _gameFinished) return;
    setState(() => _selectedMeaning = meaning);
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedWord == null || _selectedMeaning == null) return;

    final correct = _pairs.any((p) =>
        p["word"] == _selectedWord &&
        p["meaning"] == _selectedMeaning);

    if (correct) {
      _sfxPlayer.play(AssetSource('sound/correct.mp3'));
      setState(() {
        _matchedWords.add(_selectedWord!);
        _matchedMeanings.add(_selectedMeaning!);
        _score += 10;
      });

      if (_matchedWords.length == _pairs.length && !_gameFinished) {
        _gameFinished = true;
        _finishGame();
      }
    } else {
      _sfxPlayer.play(AssetSource('sound/wrong.mp3'));
      _shakeController.forward(from: 0);
    }

    setState(() {
      _selectedWord = null;
      _selectedMeaning = null;
    });
  }

  Future<void> _finishGame() async {
    await _bgmPlayer.stop();
    _confettiController.play();
    _sfxPlayer.play(AssetSource('sound/complete.mp3'));

    if (!_achievementSaved) {
      await DatabaseHelper.instance.unlockAchievement(3);
      _achievementSaved = true;
    }

    if (!mounted) return;
    _showAchievementDialog();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      // ✅ APP BAR NORMAL
      appBar: AppBar(
        title: const Text("Word Match Challenge", 
        style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 1,
      ),

      body: Stack(
        children: [
          Column(
            children: [
              _buildProgress(),
              Expanded(child: _buildGameArea()),
            ],
          ),
          _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final progress = _matchedWords.length / _pairs.length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 6),
          Text(
            "${_matchedWords.length}/${_pairs.length} matched • Score $_score",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(child: _buildColumn(_words, true)),
          const SizedBox(width: 16),
          Expanded(child: _buildColumn(_meanings, false)),
        ],
      ),
    );
  }

  Widget _buildColumn(List<String> items, bool isWord) {
    return ListView(
      children: items.map((text) {
        final matched =
            isWord ? _matchedWords.contains(text) : _matchedMeanings.contains(text);
        final selected =
            isWord ? _selectedWord == text : _selectedMeaning == text;

        return _buildCard(
          text: text,
          isMatched: matched,
          isSelected: selected,
          onTap: () => isWord ? _selectWord(text) : _selectMeaning(text),
        );
      }).toList(),
    );
  }

  Widget _buildCard({
    required String text,
    required bool isMatched,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (_, child) {
        final double offset =
            isSelected ? sin(_shakeController.value * pi * 4) * 6 : 0.0;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isMatched
                ? Colors.green
                : isSelected
                    ? Colors.indigo
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isMatched || isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 30,
        gravity: 0.3,
      ),
    );
  }

  // ================= DIALOG =================
  void _showAchievementDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🏆 Achievement Unlocked"),
        content: const Text(
          "Vocabulary Hero\n\nYou have completed this challenge!",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showResultDialog();
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Game Completed"),
        content: Text("Final Score: $_score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }
}
