import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/firebase_api.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/notifpage.dart';
import 'package:flutter_application_1/userHomePage.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseApi().initNotifications();
    print('Firebase initialized');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
        ),
      ),
      home: const MainPage(),
      navigatorKey: navigatorKey,
      routes: {
        '/login_screen': (context) => const MainPage(),
      },
    );
  }
}
