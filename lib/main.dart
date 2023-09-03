import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:match_42/firebase_options.dart';
import 'package:match_42/local_notification.dart';
import 'package:match_42/router.dart';
import 'package:match_42/ui/theme/color_schemes.dart';
import 'package:match_42/ui/login_page.dart';
import 'package:match_42/ui/my_page.dart';
import 'package:match_42/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  await LocalNotification.initialize();
  runApp(ChangeNotifierProvider(
      create: (context) => LoginViewModel(), child: const MyApp()));
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
      routerConfig: MyRouter(context: context).router,
    );
  }
}
