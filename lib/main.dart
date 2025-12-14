import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // 🔥 TAMBAH INI

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Load .env file
  await dotenv.load(fileName: ".env");

  // 🔥 INIT GEMINI WAJIB ADA DI SINI
  Gemini.init(apiKey: dotenv.env["GEMINI_API_KEY"]!);

  // // ====== HAPUS DATABASE LAMA (sementara) ======
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app.db');

  await deleteDatabase(path);
  print("🔥 DATABASE DELETED — akan dibuat ulang saat app berjalan");
  // // =============================================

  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      home: const HomePage(),
    );
  }
}
