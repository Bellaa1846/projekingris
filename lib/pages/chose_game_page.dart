import 'package:flutter/material.dart';
import 'package:ujicoba1/pages/game_pages/word_match_challenge_page.dart'; // contoh
import 'package:ujicoba1/pages/game_pages/main_idea_adventure_page.dart'; // contoh

class ChoseGame extends StatefulWidget {
  const ChoseGame({super.key});

  @override
  State<ChoseGame> createState() => _ChoseGameState();
}

class _ChoseGameState extends State<ChoseGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Learning Games"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Colors.amber.shade400],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade700, Colors.amber.shade400],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.videogame_asset_rounded, size: 50, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    "Pilih Game Pembelajaran",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Latih kemampuanmu melalui berbagai game interaktif",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1
                  _buildFullMenuCard(
                    icon: Icons.quiz,
                    title: "Game 1",
                    subtitle: "Tingkatkan kosakata melalui mini-games",
                    color: Colors.amber.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WordMatchChallengePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2
                  _buildFullMenuCard(
                    icon: Icons.menu_book,
                    title: "Game 2",
                    subtitle: "Latih pemahaman teks dengan petualangan seru",
                    color: Colors.deepOrange.shade600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainIdeaAdventurePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // // 3
                  // _buildFullMenuCard(
                  //   icon: Icons.lightbulb_outline,
                  //   title: "Game 3",
                  //   subtitle: "Asah kemampuan menemukan ide utama",
                  //   color: Colors.green.shade600,
                  //   onTap: () {
                  //     // bisa diganti halaman game lain
                  //   },
                  // ),
                  // const SizedBox(height: 16),

                  // // 4
                  // _buildFullMenuCard(
                  //   icon: Icons.assignment,
                  //   title: "Game 4",
                  //   subtitle: "Latih kemampuan inferensi",
                  //   color: Colors.blue.shade600,
                  //   onTap: () {
                  //     // bisa diganti halaman game lain
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Full Menu Card (sama persis style-nya)
  // -------------------------------------------------------------------------
  Widget _buildFullMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: color.withOpacity(0.95),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
