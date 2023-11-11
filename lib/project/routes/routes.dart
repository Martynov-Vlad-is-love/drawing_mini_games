import 'package:drawing_mini_games/view/screen/draw_screen.dart';
import 'package:drawing_mini_games/view/screen/home_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
'/': (context) => const HomeScreen(),
'/draw': (context) => const DrawScreen(),
};
