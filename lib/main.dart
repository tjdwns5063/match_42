import 'package:flutter/material.dart';
import 'package:match_42/router.dart';
import 'package:match_42/ui/theme/color_schemes.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/my_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'matching 42',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routerConfig: MyRouter.router,
    );
  }
}
