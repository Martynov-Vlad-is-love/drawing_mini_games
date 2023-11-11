import 'package:drawing_mini_games/view/screen/draw_screen.dart';
import 'package:drawing_mini_games/view/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/draw': (context) => const DrawScreen(),
      },
    );
  }
}
