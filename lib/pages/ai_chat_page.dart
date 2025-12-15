import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:lottie/lottie.dart';

import '../../database/db_helper.dart';


// ==========================================
//   WIDGET ANIMASI TITIK (TYPING INDICATOR)
// ==========================================
class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots({super.key});

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _anim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            double offsetY = (i == 0)
                ? _anim.value
                : (i == 1)
                    ? (_anim.value - 3).abs()
                    : (6 - _anim.value);

            return Transform.translate(
              offset: Offset(0, offsetY),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


// ==========================================
//            HALAMAN AI CHAT
// ==========================================
class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;

  // 🔑 ACHIEVEMENT STATE
  bool _firstChatAchievementUnlocked = false;

  // ===================== SEND MESSAGE =====================
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // 🏆 FIRST CHAT ACHIEVEMENT
    if (_messages.isEmpty && !_firstChatAchievementUnlocked) {
      await _unlockFirstChatAchievement();
    }

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });

    _controller.clear();

    try {
      final res = await Gemini.instance.prompt(
        parts: [Part.text(text)],
      );
      final botReply = res?.output ?? "Maaf, saya tidak bisa menjawab.";

      setState(() {
        _messages.add({'sender': 'bot', 'text': botReply});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': "Terjadi kesalahan: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ===================== ACHIEVEMENT LOGIC =====================
  Future<void> _unlockFirstChatAchievement() async {
    await DatabaseHelper.instance.unlockAchievement(2);
    _firstChatAchievementUnlocked = true;

    // 🔔 Show dialog safely after frame
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _showAchievementDialog();
      }
    });
  }

  // ===================== ACHIEVEMENT DIALOG =====================
  void _showAchievementDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "🤖 Achievement Unlocked!",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Welcome!\nYou started your first AI conversation.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Nice!"),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== CHAT BUBBLE =====================
  Widget _buildBubble(Map<String, dynamic> msg) {
    final bool isUser = msg["sender"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 270),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[600] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isUser ? const Radius.circular(12) : Radius.zero,
            bottomRight:
                isUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          msg["text"],
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // 🔥 TYPING INDICATOR
  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: const _AnimatedDots(),
      ),
    );
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 1,
        title: const Text("MARY AI Assistant"),
      ),

      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            child: Lottie.asset(
                              'assets/lottie/marai.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text(
                            "Start Chat with MARAI✨",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Write down your question",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_isLoading &&
                            index == _messages.length) {
                          return _typingBubble();
                        }
                        return _buildBubble(_messages[index]);
                      },
                    ),
            ),

            // ===================== INPUT =====================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Write Message...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.indigo,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _sendMessage,
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
