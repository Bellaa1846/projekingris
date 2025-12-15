import 'package:flutter/material.dart';

class MainIdeaAdventurePage extends StatefulWidget {
  const MainIdeaAdventurePage({super.key});

  @override
  State<MainIdeaAdventurePage> createState() => _MainIdeaAdventurePageState();
}

class _MainIdeaAdventurePageState extends State<MainIdeaAdventurePage> {
  int unlockedLevel = 1;
  int score = 0;

  final List<Map<String, dynamic>> levels = [
    {
      "level": 1,
      "title": "At the Park",
      "text":
          "Many children like to play in the park. They run, jump, and play games together.",
      "options": [
        "Children like playing in the park",
        "Parks are dangerous",
        "Children do homework at the park"
      ],
      "answer": 0,
    },
    {
      "level": 2,
      "title": "My Pet Cat",
      "text":
          "I have a cat at home. She likes to sleep, eat, and play with a ball.",
      "options": [
        "Cats live in the jungle",
        "My cat is lazy",
        "I have a cat as a pet"
      ],
      "answer": 2,
    },
    {
      "level": 3,
      "title": "Healthy Food",
      "text":
          "Eating vegetables and fruits helps our body stay healthy and strong.",
      "options": [
        "Healthy food is expensive",
        "Vegetables and fruits are healthy",
        "Fast food is better"
      ],
      "answer": 1,
    },
    {
      "level": 4,
      "title": "School Library",
      "text":
          "The school library is quiet. Students read books and study there.",
      "options": [
        "The library is noisy",
        "Students eat in the library",
        "The library is a place to read and study"
      ],
      "answer": 2,
    },
    {
      "level": 5,
      "title": "Rainy Day",
      "text":
          "When it rains, people use umbrellas and stay inside to keep dry.",
      "options": [
        "Rain makes people wet",
        "People play outside in the rain",
        "Rain is always fun"
      ],
      "answer": 0,
    },
  ];

  void _openLevel(Map<String, dynamic> levelData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelPlayPage(
          levelData: levelData,
          onCompleted: () {
            setState(() {
              if (unlockedLevel < levelData["level"] + 1) {
                unlockedLevel++;
                score += 20;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Idea Adventure"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMap()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Adventure Map",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Score: $score",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        final isUnlocked = level["level"] <= unlockedLevel;

        return GestureDetector(
          onTap: isUnlocked ? () => _openLevel(level) : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isUnlocked ? Colors.indigo : Colors.grey,
                  child: Text(
                    level["level"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    level["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isUnlocked ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
                Icon(
                  isUnlocked ? Icons.lock_open : Icons.lock,
                  color: isUnlocked ? Colors.green : Colors.grey,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ================= LEVEL PLAY PAGE =================

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

  void _submit() {
    if (selectedAnswer == widget.levelData["answer"]) {
      widget.onCompleted();
      _showDialog(true);
    } else {
      _showDialog(false);
    }
  }

  void _showDialog(bool correct) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(correct ? "Correct 🎉" : "Wrong ❌"),
        content: Text(
          correct
              ? "You found the main idea!"
              : "Try again and focus on the main idea.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (correct) Navigator.pop(context);
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
        title: Text("Level ${widget.levelData["level"]}"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.levelData["text"],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              widget.levelData["options"].length,
              (index) => RadioListTile<int>(
                value: index,
                groupValue: selectedAnswer,
                title: Text(widget.levelData["options"][index]),
                onChanged: (value) {
                  setState(() => selectedAnswer = value);
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null ? null : _submit,
                child: const Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
