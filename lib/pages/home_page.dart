import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:ujicoba1/models/motivation_model.dart';
import 'package:ujicoba1/pages/ai_chat_page.dart';
import 'package:ujicoba1/pages/chose_test_page.dart';
import '../database/db_helper.dart';
import 'main_idea_page.dart';
import 'profile_page.dart';
import 'vocabulary_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> motivationalTexts = MotivationData.motivationalTexts;
  late String currentMotivation;

  // ===== DATA PROFILE DARI DB =====
  String name = "User";
  String photoPath = "";

  @override
  void initState() {
    super.initState();
    _generateRandomMotivation();
    _loadProfileData();
  }

  void _generateRandomMotivation() {
    setState(() {
      final random = Random();
      currentMotivation =
          motivationalTexts[random.nextInt(motivationalTexts.length)];
    });
  }

  Future<void> _loadProfileData() async {
    final profile = await DatabaseHelper.instance.getProfile();

    if (profile != null) {
      setState(() {
        name = profile["name"];
        photoPath = profile["photoPath"] ?? "";
      });
    }
  }

  // ================= MENU CARD ====================
  Widget _buildMenuCard({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
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
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        // ================= APPBAR BARU =================
        appBar: AppBar(
          title: Text(
            "MARY ",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.cyan.shade400,
          elevation: 0.4,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
                _loadProfileData();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.all(0), // jarak border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyan.shade800, // warna border putih
                      width: 2, // ketebalan border
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: photoPath.isNotEmpty
                        ? FileImage(File(photoPath))
                        : null,
                    child: photoPath.isEmpty
                        ? const Icon(Icons.person, color: Colors.black87)
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ================= BODY =================
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 0),
                  child: Text(
                    "Welcome, $name 👋",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                // ================= LOTTIE =================
                Center(
                  child: SizedBox(
                    height: 280,
                    child: Lottie.asset(
                      'assets/lottie/animasi.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // ================= MOTIVATION CARD =================
                Transform.translate(
                  offset: const Offset(0, -30), // geser ke atas 20px
                  child: InkWell(
                    child: InkWell(
                      onTap: _generateRandomMotivation,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.withOpacity(0.15),
                              Colors.amber.withOpacity(0.20),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: Colors.orange,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Today's Motivation",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "“$currentMotivation”",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Learn Reading Text Topics 📘",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Choose what you want to learn below",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMenuCard(
                      icon: Icons.lightbulb_outline_rounded,
                      title: "Main Idea",
                      subtitle: "Understand the main idea in texts",
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainIdeaPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.translate_rounded,
                      title: "Vocabulary",
                      subtitle: "Learn new words & meanings",
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VocabularyPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //Test button
                _buildFullMenuCard(
                  icon: Icons.quiz_rounded,
                  title: "Test Your Knowledge",
                  subtitle: "Practice the skills you've learned",
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChoseTest(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                //Ai chat
                _buildFullMenuCard(
                  icon: Icons.smart_toy,
                  title: "Chat with AI",
                  subtitle: "Ask the AI about Main Ideas and Vocabulary",
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIChatPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                //Games
                _buildFullMenuCard(
                  icon: Icons.gamepad,
                  title: "Games",
                  subtitle: "Learn while playing",
                  color: Colors.amber.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChoseTest(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Made with ❤️ by `Fedriko`, Melky`, and `Nabila`",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "© 2025 Mava",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
