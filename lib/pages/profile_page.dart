import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../database/db_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/* =========================
   MODEL ACHIEVEMENT
========================= */
class Achievement {
  final String title;
  final IconData icon;
  final bool unlocked;
  final String hint;

  Achievement({
    required this.title,
    required this.icon,
    required this.unlocked,
    required this.hint,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String birthDateIso = "";
  String photoPath = "";

  final TextEditingController nameController = TextEditingController();

  /* =========================
     DATA ACHIEVEMENT
  ========================= */
  final List<Achievement> achievements = [
    Achievement(
      title: "Beginner",
      icon: Icons.emoji_events,
      unlocked: true,
      hint: "Hint 1",
    ),
    Achievement(
      title: "Explorer",
      icon: Icons.explore,
      unlocked: true,
      hint: "Hint 2",
    ),
    Achievement(
      title: "Consistency",
      icon: Icons.calendar_month,
      unlocked: false,
      hint: "Hint 3",
    ),
    Achievement(
      title: "Expert",
      icon: Icons.star,
      unlocked: false,
      hint: "Hint 4",
    ),
    Achievement(
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
     EDIT PROFILE
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
                          color:
                              a.unlocked ? Colors.black : Colors.grey.shade600,
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
     MAIN UI
  ========================= */
  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
            // PROFILE CARD
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
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // LOTTIE CAT
                SizedBox(
                  height: 160,
                  child: Lottie.asset(
                    'assets/lottie/catPlaying.json',
                    fit: BoxFit.contain,
                  ),
                ),

                // ACHIEVEMENTS (OFFSET KE ATAS)
                Transform.translate(
                  offset: const Offset(0, 140),
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
