import 'package:flutter/material.dart';
import 'package:match_42/color_schemes.dart';
import 'package:match_42/match_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'matching 42',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const MatchPage(),
    );
  }
}
