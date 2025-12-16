import 'package:flutter/material.dart';

class LevelPlayPage extends StatefulWidget {
  final Map<String, dynamic> levelData;
  final VoidCallback onCompleted;

  const LevelPlayPage({
    super.key,
    required this.levelData,
    required this.onCompleted,
  });

  @override
  State<LevelPlayPage> createState() => _LevelPlayPageState();
}

class _LevelPlayPageState extends State<LevelPlayPage> {
  int? selectedAnswer;

  void _submitAnswer() {
    final bool isCorrect =
        selectedAnswer == widget.levelData["answer"];

    if (isCorrect) {
      widget.onCompleted();
    }

    _showResultDialog(isCorrect);
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          isCorrect ? "Correct 🎉" : "Wrong ❌",
          textAlign: TextAlign.center,
        ),
        content: Text(
          isCorrect
              ? "Great job! You found the main idea."
              : "Read the text again and focus on the main idea.",
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.levelData["title"]),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.levelData["image"],
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// TEXT STORY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.levelData["text"],
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// OPTIONS
            ...List.generate(
              widget.levelData["options"].length,
              (index) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: selectedAnswer,
                  title: Text(
                    widget.levelData["options"][index],
                    style: const TextStyle(fontSize: 15),
                  ),
                  onChanged: (value) {
                    setState(() => selectedAnswer = value);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    selectedAnswer == null ? null : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Submit Answer",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
