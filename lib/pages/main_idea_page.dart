import 'package:flutter/material.dart';
import 'practice_page/practice_main_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MainIdeaPage extends StatefulWidget {
  const MainIdeaPage({super.key});

  @override
  State<MainIdeaPage> createState() => _MainIdeaPageState();
}

class _MainIdeaPageState extends State<MainIdeaPage> {
  bool showMiniPracticeAnswer = false;
  
  final String youtubeVideoId = "LbO3lRXT0ww"; 
  final String youtubeUrl = "https://youtu.be/LbO3lRXT0ww?si=4DwBxNvTaMXKuPDW"; 


  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(youtubeUrl);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开YouTube链接')),
      );
    }
  }

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
    String? mainIdea,
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                if (mainIdea != null) ...[
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
                            mainIdea,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Main Idea"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
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
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.menu_book, size: 50, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    "Pelajari Main Idea",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Temukan gagasan utama dalam setiap paragraf",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // What is Main Idea
                  _buildSectionCard(
                    title: "What is Main Idea?",
                    icon: Icons.help_outline,
                    backgroundColor: Colors.blue,
                    content: _buildParagraph(
                      "Main Idea adalah gagasan utama dari sebuah paragraf atau teks. "
                      "Ini adalah pesan paling penting yang ingin disampaikan oleh penulis. "
                      "Detail lainnya hanyalah pendukung dari ide utama ini.",
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Topic vs Main Idea
                  _buildSectionCard(
                    title: "Topic vs Main Idea",
                    icon: Icons.compare_arrows,
                    backgroundColor: Colors.purple,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Banyak orang bingung antara topic dan main idea. Berikut perbedaannya:",
                        ),
                        const SizedBox(height: 12),
                        _buildBulletList([
                          "Topic → apa yang sedang dibahas (kata/frasa pendek)",
                          "Main Idea → apa yang penulis ingin sampaikan tentang topik tersebut (kalimat lengkap)",
                        ]),
                        const SizedBox(height: 12),
                        _buildExampleCard(
                          title: "Contoh",
                          text:
                              "Topic: Dogs\n\nMain Idea: Dogs are popular pets because they are friendly and loyal.",
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Why Important
                  _buildSectionCard(
                    title: "Why is Main Idea Important?",
                    icon: Icons.star,
                    backgroundColor: Colors.amber,
                    content: _buildBulletList([
                      "Membantu memahami inti bacaan dengan cepat",
                      "Memudahkan menjawab soal reading comprehension",
                      "Membantu meringkas teks secara efisien",
                      "Menghindari salah interpretasi terhadap teks",
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // Supporting Details
                  _buildSectionCard(
                    title: "Supporting Details",
                    icon: Icons.format_list_bulleted,
                    backgroundColor: Colors.orange,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Supporting details adalah informasi yang mendukung Main Idea. "
                          "Biasanya berupa contoh, fakta, data, alasan, atau penjelasan tambahan.",
                        ),
                        const SizedBox(height: 12),
                        _buildExampleCard(
                          title: "Contoh",
                          text:
                              "Main Idea: Regular exercise improves health.\n\n"
                              "Supporting Details:\n"
                              "• Exercise keeps the heart strong.\n"
                              "• Exercise helps maintain ideal body weight.\n"
                              "• Exercise reduces stress.",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // How to Find
                  _buildSectionCard(
                    title: "How to Find the Main Idea?",
                    icon: Icons.search,
                    backgroundColor: Colors.teal,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletList([
                          "Baca seluruh paragraf terlebih dahulu",
                          "Tentukan topik utama paragraf",
                          "Cari kalimat yang menjelaskan inti dari topik tersebut",
                          "Abaikan detail seperti contoh atau angka",
                          "Jika tidak tertulis, simpulkan dari seluruh kalimat (implied main idea)",
                          "Coba ubah paragraf menjadi satu kalimat ringkas",
                        ]),
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
                          "Tonton video penjelasan tentang strategi mencari Main Idea:",
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

                  const SizedBox(height: 40),

                  // Examples Section Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Contoh-Contoh Main Idea",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Examples
                  _buildExampleCard(
                    title: "Example 1",
                    text:
                        "Dogs are considered one of the most popular pets around the world. Many people choose to have dogs "
                        "because these animals are friendly, loyal, and enjoy spending time with their owners. Dogs can also "
                        "be trained to follow commands, protect the house, or even help people with disabilities. For families, "
                        "dogs often become more than just pets—they become loving companions who bring joy every day.",
                    mainIdea:
                        "Main Idea: Dogs are popular pets because they are friendly, loyal, and helpful to humans.",
                    color: Colors.blue,
                  ),

                  _buildExampleCard(
                    title: "Example 2",
                    text:
                        "Many people prefer drinking water instead of sugary drinks because water keeps the body properly hydrated. "
                        "Sugary drinks, such as soda and sweetened tea, often contain high amounts of sugar that can lead to health "
                        "problems like weight gain or tooth decay. Water, on the other hand, has no calories and supports important "
                        "body functions, including digestion and temperature regulation. For individuals who want to live a healthier "
                        "lifestyle, choosing water is a simple but effective step.",
                    mainIdea:
                        "Main Idea: Water is a healthier and better choice than sugary drinks.",
                    color: Colors.green,
                  ),

                  _buildExampleCard(
                    title: "Example 3",
                    text:
                        "Social media has become an essential tool for communication in modern society. People use platforms like "
                        "Instagram, Facebook, and TikTok to share personal updates, express their opinions, and learn about what is "
                        "happening around the world. Social media also helps people stay connected with friends and family even if "
                        "they live far away. Additionally, many businesses use social media to promote their products and interact "
                        "with customers, showing how powerful these platforms have become.",
                    mainIdea:
                        "Main Idea: Social media is an important tool for communication in modern life.",
                    color: Colors.red,
                  ),

                  _buildExampleCard(
                    title: "Example 4",
                    text:
                        "Eating fruits and vegetables provides the body with many essential nutrients needed for good health. "
                        "These foods contain vitamins and minerals that support the immune system and help the body function properly. "
                        "Fruits and vegetables are also rich in fiber, which plays an important role in maintaining a healthy digestive "
                        "system and preventing constipation. Doctors often recommend eating a variety of colorful fruits and vegetables "
                        "every day to ensure the body gets all the nutrients it needs.",
                    mainIdea:
                        "Main Idea: Fruits and vegetables are important because they provide essential nutrients for good health.",
                    color: Colors.orange,
                  ),

                  const SizedBox(height: 24),

                  // Mini Practice
                  _buildSectionCard(
                    title: "Mini Practice",
                    icon: Icons.quiz,
                    backgroundColor: Colors.indigo,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph(
                          "Tentukan Main Idea dari paragraf berikut:",
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showMiniPracticeAnswer = !showMiniPracticeAnswer;
                            });
                          },
                          child: _buildExampleCard(
                            title: "Paragraf",
                            text:
                                "Reading every day provides many benefits for students who are learning a language. "
                                "It helps increase vocabulary because readers are exposed to new words in different contexts. "
                                "Daily reading also improves grammar understanding by showing how sentences are structured naturally. "
                                "Furthermore, it strengthens critical thinking skills since readers must understand, evaluate, and connect ideas in the text. "
                                "Even spending just a few minutes reading each day can lead to noticeable progress over time.",
                            mainIdea: showMiniPracticeAnswer
                                ? "Main Idea: Reading every day improves vocabulary, grammar, and critical thinking skills."
                                : null,
                            color: Colors.teal,
                          ),
                        ),
                        // HINT TAP TO SHOW ANSWER
                        Text(
                          showMiniPracticeAnswer
                              ? "Tap again to hide the answer"
                              : "Tap the card to reveal the answer",
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Start Practice Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
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
                            builder: (context) => const PracticeMainIdea(),
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
                          Icon(Icons.play_arrow, size: 28, color: Colors.white,),
                          SizedBox(width: 8),
                          Text(
                            "Start Practice",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
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