import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../database/db_helper.dart';

/* =========================
   MODEL ACHIEVEMENT
========================= */
class Achievement {
  final int id;
  final String title;
  final IconData icon;
  bool unlocked;
  final String hint;

  Achievement({
    required this.id,
    required this.title,
    required this.icon,
    required this.unlocked,
    required this.hint,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String birthDateIso = "";
  String photoPath = "";

  final TextEditingController nameController = TextEditingController();

  /* =========================
     ACHIEVEMENT HARDCODE
     (status diambil dari SQLite)
  ========================= */
  final List<Achievement> achievements = [
    Achievement(
      id: 0,
      title: "Beginner",
      icon: Icons.emoji_events,
      unlocked: false,
      hint: "Hint 1",
    ),
    Achievement(
      id: 1,
      title: "Explorer",
      icon: Icons.explore,
      unlocked: false,
      hint: "Hint 2",
    ),
    Achievement(
      id: 2,
      title: "Consistency",
      icon: Icons.calendar_month,
      unlocked: false,
      hint: "Hint 3",
    ),
    Achievement(
      id: 3,
      title: "Expert",
      icon: Icons.star,
      unlocked: false,
      hint: "Hint 4",
    ),
    Achievement(
      id: 4,
      title: "Master",
      icon: Icons.workspace_premium,
      unlocked: false,
      hint: "Hint 5",
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadAchievements();
  }

  /* =========================
     LOAD PROFILE
  ========================= */
  Future<void> loadProfile() async {
    final data = await DatabaseHelper.instance.getProfile();
    if (data != null) {
      setState(() {
        name = data["name"];
        birthDateIso = data["birthDate"];
        photoPath = data["photoPath"] ?? "";
      });
    }
  }

  /* =========================
     LOAD ACHIEVEMENTS (SQLITE)
  ========================= */
  Future<void> loadAchievements() async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query("achievements");

    // jika DB kosong → seed default (SEMUA LOCK)
    if (res.isEmpty) {
      for (final a in achievements) {
        await db.insert("achievements", {"id": a.id, "unlocked": 0});
      }
      return;
    }

    // mapping unlocked dari DB ke UI
    for (final row in res) {
      final id = row["id"] as int;
      final unlocked = (row["unlocked"] as int) == 1;

      final index = achievements.indexWhere((a) => a.id == id);
      if (index != -1) {
        achievements[index].unlocked = unlocked;
      }
    }

    setState(() {});
  }

  /* =========================
     FORMAT DATE
  ========================= */
  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${date.day} ${months[date.month]} ${date.year}";
  }

  /* =========================
     EDIT PROFILE (TIDAK DIUBAH)
  ========================= */
  void _editProfile() {
    nameController.text = name;
    DateTime currentDate = DateTime.parse(birthDateIso);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Profile"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          setDialogState(() {
                            photoPath = image.path;
                          });
                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: photoPath.isNotEmpty
                                ? FileImage(File(photoPath))
                                : null,
                            child: photoPath.isEmpty
                                ? const Icon(Icons.person, size: 48)
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap to change photo",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.cyan.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: currentDate,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            birthDateIso =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Born on ${formatDate(birthDateIso)}"),
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.updateProfile(
                      nameController.text,
                      birthDateIso,
                      photoPath,
                    );
                    setState(() {
                      name = nameController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /* =========================
     ACHIEVEMENTS UI
  ========================= */
  Widget _buildAchievements() {
    final unlockedCount = achievements.where((a) => a.unlocked).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Achievements",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "$unlockedCount / ${achievements.length}",
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Tap a medal to see how to unlock it",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final a = achievements[index];
              final color = a.unlocked ? Colors.amber : Colors.grey;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(a.title),
                      content: Text(a.hint),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(a.icon, size: 36, color: color),
                      const SizedBox(height: 8),
                      Text(
                        a.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: a.unlocked
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /* =========================
     MAIN UI (ASLI)
  ========================= */
  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /* =========================
               PROFILE CARD + EDIT ICON
            ========================= */
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: photoPath.isNotEmpty
                            ? FileImage(File(photoPath))
                            : null,
                        child: photoPath.isEmpty
                            ? const Icon(Icons.person, size: 48)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Born on ${formatDate(birthDateIso)}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: _editProfile,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /* =========================
               CAT + ACHIEVEMENT OVERLAP
            ========================= */
            Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 160,
                  child: Lottie.asset(
                    'assets/lottie/catPlaying.json',
                    fit: BoxFit.contain,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 140),
                  child: _buildAchievements(),
                ),
              ],
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
