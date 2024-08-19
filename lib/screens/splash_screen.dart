import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _showSplashScreen();
  }

  Future<void> _showSplashScreen() async {
    // Show the splash screen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      // User is logged in, navigate to the dashboard
      Navigator.of(context).pushReplacementNamed('/dashScreen');
    } else {
      // User is not logged in, navigate to the login screen
      Navigator.of(context).pushReplacementNamed('/getStartedScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset('assets/splash_top.svg')),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo.png',
                  height: 180,
                  width: 250,
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset('assets/splash_down.svg'))
          ],
        ),
      ),
    );
  }
}
