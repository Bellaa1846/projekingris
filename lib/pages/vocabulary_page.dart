import 'package:flutter/material.dart';
import 'practice_page/practice_vocab_page.dart';
import 'package:url_launcher/url_launcher.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  bool showMiniPracticeAnswer = false;

  // YouTube Section
  final String youtubeVideoId = "SEz0k7Y7G1U";
  final String youtubeUrl = "https://youtu.be/SEz0k7Y7G1U";

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(youtubeUrl);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka YouTube')),
      );
    }
  }

  // ---------- REUSABLE UI COMPONENTS ----------
  Widget _buildSectionCard({
    required String title,
    required Widget content,
    Color? backgroundColor,
    IconData? icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: backgroundColor != null
              ? LinearGradient(
                  colors: [backgroundColor.withOpacity(0.1), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: backgroundColor ?? Colors.blue, size: 28),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor ?? Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(item, style: const TextStyle(fontSize: 15, height: 1.5)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String text,
    String? meaning,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.article_outlined, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    )),
                if (meaning != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: color, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            meaning,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MAIN BUILD -------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Vocabulary"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.green.shade600,
              Colors.green.shade400,
            ]),
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade400],
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.translate, size: 50, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    "Pelajari Vocabulary",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Tingkatkan pemahaman kosakata dalam teks",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // WHAT IS VOCAB
                  _buildSectionCard(
                    title: "What is Vocabulary?",
                    icon: Icons.help_outline,
                    backgroundColor: Colors.green,
                    content: _buildParagraph(
                      "Vocabulary adalah kumpulan kata yang kamu ketahui atau gunakan. "
                      "Semakin banyak vocabulary yang kamu pahami, semakin mudah kamu membaca dan memahami teks.",
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TYPES
                  _buildSectionCard(
                    title: "Types of Vocabulary",
                    icon: Icons.category,
                    backgroundColor: Colors.blue,
                    content: _buildBulletList([
                      "Active Vocabulary → kata yang sering digunakan saat berbicara/menulis",
                      "Passive Vocabulary → kata yang dipahami saat membaca/dengar",
                      "Academic Vocabulary → kata formal yang sering muncul dalam teks pelajaran",
                      "Topic Vocabulary → kosakata berdasarkan tema tertentu (health, environment, technology)",
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // CONTEXT CLUES
                  _buildSectionCard(
                    title: "Context Clues",
                    icon: Icons.search,
                    backgroundColor: Colors.orange,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Context clues adalah petunjuk dalam kalimat yang membantu menebak arti kata.",
                        ),
                        const SizedBox(height: 12),
                        _buildBulletList([
                          "Definition clue → arti dijelaskan langsung",
                          "Synonym clue → ada kata yang artinya mirip",
                          "Antonym clue → ada kata berlawanan makna",
                          "Example clue → ada contoh",
                          "Inference clue → harus disimpulkan dari konteks",
                        ]),
                        const SizedBox(height: 12),
                        _buildExampleCard(
                          title: "Contoh",
                          text:
                              "The room was very dim, or not bright, so I could barely see.",
                          meaning: "dim = not bright (definition clue)",
                          color: Colors.orange,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // WORD FORMATION
                  _buildSectionCard(
                    title: "Word Formation",
                    icon: Icons.build,
                    backgroundColor: Colors.purple,
                    content: _buildBulletList([
                      "Prefix (awalan): un-, re-, mis-, pre-, auto-",
                      "Suffix (akhiran): -ful, -less, -tion, -able, -ly",
                      "Root word: photo (light), bio (life), act (do)",
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // COLLOCATIONS
                  _buildSectionCard(
                    title: "Collocations",
                    icon: Icons.link,
                    backgroundColor: Colors.indigo,
                    content: _buildBulletList([
                      "make a decision",
                      "take a break",
                      "heavy rain (bukan strong rain)",
                      "fast food (bukan quick food)",
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // LEARNING TIPS
                  _buildSectionCard(
                    title: "Tips to Improve Vocabulary",
                    icon: Icons.lightbulb_outline,
                    backgroundColor: Colors.teal,
                    content: _buildBulletList([
                      "Gunakan flashcard",
                      "Kelompokkan kata berdasarkan tema",
                      "Gunakan kata dalam kalimat",
                      "Baca 10 menit setiap hari",
                      "Tonton video berbahasa Inggris",
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // EXAMPLE PARAGRAPH
                  _buildSectionCard(
                    title: "Example Paragraph",
                    icon: Icons.menu_book_outlined,
                    backgroundColor: Colors.red,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Many students struggle with time management because they find it difficult to prioritize their tasks. "
                          "Procrastination also becomes a problem when they delay important assignments, causing them to feel overwhelmed.",
                        ),
                        const SizedBox(height: 12),
                        _buildBulletList([
                          "struggle = kesulitan",
                          "prioritize = menentukan prioritas",
                          "procrastination = menunda pekerjaan",
                          "overwhelmed = kewalahan",
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // MINI PRACTICE
                  _buildSectionCard(
                    title: "Mini Practice",
                    icon: Icons.quiz,
                    backgroundColor: Colors.brown,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph("Arti dari kata 'beneficial' adalah…"),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showMiniPracticeAnswer = !showMiniPracticeAnswer;
                            });
                          },
                          child: _buildExampleCard(
                            title: "Konteks",
                            text: "Regular exercise is beneficial for health.",
                            meaning: showMiniPracticeAnswer
                                ? "beneficial = helpful (bermanfaat)"
                                : null,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          showMiniPracticeAnswer
                              ? "Tap again to hide answer"
                              : "Tap card to show answer",
                          style: const TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // START PRACTICE BUTTON
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade600,
                          Colors.green.shade400,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const VocabQuizPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, size: 30, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Start Practice",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
