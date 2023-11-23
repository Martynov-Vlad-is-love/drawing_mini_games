 import 'package:drawing_mini_games/view/widget/main_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing mini games'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Welcome to the Drawing Mini Games',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            MainButton(text: 'Start',),
            MainButton(text: 'Go To Paint',),
            MainButton(text: 'Drawing',),
          ],
        ),
      ),
    );
  }
}


