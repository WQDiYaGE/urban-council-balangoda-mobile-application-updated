import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:urban_council/screens/bottom_navigation_screen.dart';
import 'package:urban_council/screens/get_started_screen.dart';
import 'package:urban_council/screens/phone_screen.dart';
import 'package:urban_council/screens/register_screen.dart';
import 'package:urban_council/screens/splash_screen.dart';
import 'package:urban_council/services/user_service.dart';

import 'controllers/push_notification_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService().loadUserId(); // Load user ID during app initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    // Initialize controller
    PushNotificationController();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Urban Council',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/getStartedScreen': (_) => const GetStartedScreen(),
        '/homeScreen': (_) => const PhoneScreen(),
        '/registerScreen': (_) => const RegisterScreen(
              uid: '',
            ),
        '/dashScreen': (_) => DashScreen(),
      },
    );
  }
}
