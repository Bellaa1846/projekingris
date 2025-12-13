import 'package:flutter/material.dart';
import 'practice_page/practice_vocab_page.dart';
import 'package:url_launcher/url_launcher.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  // ---------------- STATE ----------------
  List<bool> showMiniPracticeAnswers = List.generate(5, (_) => false);

  final String youtubeVideoId = "UAUokmvcIxM"; 
  final String youtubeUrl = "https://www.youtube.com/watch?v=UAUokmvcIxM"; 

  // ---------------- METHODS ----------------
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(youtubeUrl);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka YouTube')),
      );
    }
  }

  // ---------------- WIDGETS ----------------
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

  Widget _buildParagraph(String text, {List<String>? highlights}) {
    if (highlights != null && highlights.isNotEmpty) {
      List<TextSpan> spans = [];
      text.splitMapJoin(
        RegExp(highlights.join('|')),
        onMatch: (m) {
          spans.add(
            TextSpan(
              text: m[0],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
          return "";
        },
        onNonMatch: (n) {
          spans.add(
            TextSpan(
              text: n,
              style: const TextStyle(color: Colors.black87),
            ),
          );
          return "";
        },
      );
      return RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, height: 1.6),
          children: spans,
        ),
      );
    }
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
              const Text(
                "• ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade400],
            ),
          ),
        ),
      ),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Tingkatkan pemahaman kosakata dalam teks",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

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
                      "Semakin banyak vocabulary yang kamu pahami, semakin mudah membaca dan memahami teks. "
                      "Vocabulary sangat penting untuk membaca, menulis, berbicara, dan mendengar dalam bahasa Inggris.",
                      highlights: ["Vocabulary"],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TYPES OF VOCAB
                  _buildSectionCard(
                    title: "Types of Vocabulary",
                    icon: Icons.category,
                    backgroundColor: Colors.blue,
                    content: _buildBulletList([
                      "Active Vocabulary → kata yang sering digunakan saat berbicara/menulis",
                      "Passive Vocabulary → kata yang dipahami saat membaca/dengar, tapi jarang digunakan",
                      "Academic Vocabulary → kata formal yang sering muncul dalam teks pelajaran atau akademik",
                      "Topic Vocabulary → kosakata berdasarkan tema tertentu (health, environment, technology, etc.)",
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
                          "Context clues adalah petunjuk yang terdapat dalam kalimat atau paragraf yang membantu kita menebak arti kata yang tidak diketahui.",
                        ),
                        const SizedBox(height: 12),
                        _buildBulletList([
                          "Definition clue → arti dijelaskan langsung dalam kalimat",
                          "Synonym clue → ada kata yang artinya mirip sebagai petunjuk",
                          "Antonym clue → ada kata yang berlawanan makna",
                          "Example clue → kata dijelaskan melalui contoh",
                          "Inference clue → arti kata harus disimpulkan dari konteks",
                        ]),
                        // Contoh tiap clue
                        _buildExampleCard(
                          title: "Definition clue",
                          text:
                              "The room was very dim, or not bright, so I could barely see.",
                          meaning: "dim = not bright",
                          color: Colors.orange,
                        ),
                        _buildExampleCard(
                          title: "Synonym clue",
                          text: "He is joyful, happy, and always smiling.",
                          meaning: "joyful = happy",
                          color: Colors.orange,
                        ),
                        _buildExampleCard(
                          title: "Antonym clue",
                          text: "Unlike the noisy city, the village is quiet.",
                          meaning: "quiet = opposite of noisy",
                          color: Colors.orange,
                        ),
                        _buildExampleCard(
                          title: "Example clue",
                          text:
                              "Fruits like apples and oranges are nutritious.",
                          meaning: "nutritious = healthy",
                          color: Colors.orange,
                        ),
                        _buildExampleCard(
                          title: "Inference clue",
                          text:
                              "She shivered and wore a thick coat. It must be cold outside.",
                          meaning: "cold inferred from context",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---------------- WORD FORMATION REVISI (LENGKAP) ----------------
                  _buildSectionCard(
                    title: "Word Formation",
                    icon: Icons.build,
                    backgroundColor: Colors.purple,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Word Formation membantu kita memahami bagaimana kata terbentuk dan artinya. "
                          "Ada tiga jenis utama: Prefix (awalan), Suffix (akhiran), dan Root Word (kata dasar).",
                        ),
                        const SizedBox(height: 12),

                        // ================= PREFIX =================
                        _buildParagraph(
                          "1. Prefix (Awalan): awalan kata yang mengubah arti kata dasar.",
                        ),
                        _buildBulletList([
                          "un- : menjadikan kata negatif",
                          "re- : melakukan lagi",
                          "mis- : salah / keliru",
                          "dis- : kebalikan / tidak",
                          "pre- : sebelum",
                          "over- : terlalu berlebihan",
                        ]),

                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "She was unhappy because it rained all day.",
                          meaning: "unhappy → not happy",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "He will redo the homework to make it perfect.",
                          meaning: "redo → do again",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "The teacher misunderstood the question.",
                          meaning: "misunderstood → understood wrongly",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "Smoking is discouraged in public places.",
                          meaning: "discouraged → not encouraged",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "You should preheat the oven before baking.",
                          meaning: "preheat → heat before",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Prefix",
                          text: "He overworked himself and became sick.",
                          meaning: "overworked → worked too much",
                          color: Colors.purple,
                        ),

                        const SizedBox(height: 16),

                        // ================= SUFFIX =================
                        _buildParagraph(
                          "2. Suffix (Akhiran): akhiran kata yang mengubah arti atau fungsi kata.",
                        ),
                        _buildBulletList([
                          "-ful : penuh / memiliki sifat",
                          "-less : tanpa / tidak memiliki",
                          "-able : bisa / layak",
                          "-ness : keadaan / sifat",
                          "-tion : hasil / proses",
                          "-er : orang yang melakukan",
                        ]),

                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text: "The guide was very helpful for tourists.",
                          meaning: "helpful → full of help",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text:
                              "This place is dangerous, but that one is harmless.",
                          meaning: "harmless → without harm",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text: "This task is manageable if you work slowly.",
                          meaning: "manageable → can be managed",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text: "Her kindness made everyone happy.",
                          meaning: "kindness → state of being kind",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text: "Education is important for success.",
                          meaning: "education → process of educating",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Suffix",
                          text: "My father is a teacher.",
                          meaning: "teacher → a person who teaches",
                          color: Colors.purple,
                        ),

                        const SizedBox(height: 16),

                        // ================= ROOT WORD =================
                        _buildParagraph(
                          "3. Root Word (Kata Dasar): kata dasar yang menjadi inti arti kata.",
                        ),
                        _buildBulletList([
                          "photo → light",
                          "bio → life",
                          "act → do / perform",
                          "tele → far",
                          "write → write",
                          "port → carry",
                        ]),

                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text: "Biology is the study of living things.",
                          meaning: "bio = life → biology = study of life",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text: "Photograph means a picture made using light.",
                          meaning: "photo = light → photograph",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text: "The actor performed well on stage.",
                          meaning: "act = perform → actor",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text:
                              "Television allows us to see things from far away.",
                          meaning: "tele = far → television",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text: "She is writing a letter.",
                          meaning: "write = write → writer",
                          color: Colors.purple,
                        ),
                        _buildExampleCard(
                          title: "Contoh Root Word",
                          text: "This ship transports goods overseas.",
                          meaning: "port = carry → transport",
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Video Section - 修改为YouTube缩略图
                  _buildSectionCard(
                    title: "Video Explanation",
                    icon: Icons.play_circle_outline,
                    backgroundColor: Colors.red,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Tonton video cara mudah menghafal vocabulary:",
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _launchUrl,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg',
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.error, size: 50),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Klik untuk menonton di YouTube",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // MINI PRACTICE (Tebak Arti Kata)
                  // ==========================================
                  _buildSectionCard(
                    title: "Mini Practice: Tebak Arti Kata",
                    icon: Icons.quiz,
                    backgroundColor: Colors.brown,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instruksi jelas untuk user
                        _buildParagraph(
                          "Cara mengerjakan:\n"
                          "1. Baca kalimat di dalam kartu.\n"
                          "2. Coba tebak arti kata yang di kutip.\n"
                          "3. Tap kartu untuk melihat jawabannya.",
                        ),

                        const SizedBox(height: 12),

                        // 5 kartu latihan
                        for (int i = 0; i < 5; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showMiniPracticeAnswers[i] =
                                    !showMiniPracticeAnswers[i];
                              });
                            },
                            child: Column(
                              children: [
                                _buildExampleCard(
                                  title: "Soal ${i + 1}",
                                  text: [
                                    "Regular exercise is `beneficial` for health.",
                                    "She was very `diligent` in completing her homework.",
                                    "The weather is `unpredictable` during spring.",
                                    "He solved the `complex` problem with ease.",
                                    "Reading daily `improves` vocabulary gradually.",
                                  ][i],
                                  meaning: showMiniPracticeAnswers[i]
                                      ? [
                                          "beneficial = helpful (bermanfaat)",
                                          "diligent = hardworking (rajin)",
                                          "unpredictable = cannot be predicted (tidak dapat diprediksi)",
                                          "complex = complicated (rumit)",
                                          "improves = meningkatkan",
                                        ][i]
                                      : null,
                                  color: Colors.brown,
                                ),

                                // Hint tap (muncul kalau jawaban belum dibuka)
                                if (!showMiniPracticeAnswers[i])
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      "👆 Tap kartu untuk melihat arti",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.brown.shade700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                        colors: [Colors.green.shade600, Colors.green.shade400],
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
                            builder: (context) => const VocabQuizPage(),
                          ),
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
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
