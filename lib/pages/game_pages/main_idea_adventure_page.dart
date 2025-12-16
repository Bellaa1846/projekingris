import 'package:flutter/material.dart';
import 'package:ujicoba1/pages/level_play_page.dart';
import 'pages/test_page/level_play_page.dart';

class MainIdeaAdventurePage extends StatefulWidget {
  const MainIdeaAdventurePage({super.key});

  @override
  State<MainIdeaAdventurePage> createState() =>
      _MainIdeaAdventurePageState();
}

class _MainIdeaAdventurePageState extends State<MainIdeaAdventurePage> {
  int unlockedLevel = 1;
  int score = 0;

  /// ================= DATA LEVEL =================
  final List<Map<String, dynamic>> levels = [
    {
      "level": 1,
      "title": "At the Park",
      "image": "assets/images/park.png",
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
      "image": "assets/images/cat.png",
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
      "image": "assets/images/food.png",
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
      "image": "assets/images/library.png",
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
      "image": "assets/images/rain.png",
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

  /// ================= POSISI TITIK DI MAP =================
  final List<Map<String, dynamic>> mapPoints = [
    {"level": 1, "top": 420.0, "left": 40.0},
    {"level": 2, "top": 350.0, "left": 65.0},
    {"level": 3, "top": 270.0, "left": 100.0},
    {"level": 4, "top": 200.0, "left": 135.0},
    {"level": 5, "top": 140.0, "left": 170.0},
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

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Idea Adventure"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/map_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// SCORE
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "⭐ Score: $score",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          /// LEVEL POINTS
          ...mapPoints.map((point) {
            final int level = point["level"];
            final bool isUnlocked = level <= unlockedLevel;

            return Positioned(
              top: point["top"],
              left: point["left"],
              child: GestureDetector(
                onTap: isUnlocked
                    ? () => _openLevel(levels[level - 1])
                    : null,
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isUnlocked ? Colors.green : Colors.grey,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Icon(
                        isUnlocked
                            ? Icons.play_arrow
                            : Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lv $level",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
