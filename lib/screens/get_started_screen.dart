import 'package:flutter/material.dart';
import 'package:urban_council/widgets/common_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Image.asset(
                'assets/get_started.png',
                height: 180,
                width: 250,
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  Text(
                    'Stay',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Informed',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stay',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Connected',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Stay',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    'Engaged',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  )
                ],
              ),
              const Spacer(),
              CommonButton(
                title: 'Get Started',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/homeScreen');
                },
                color: const Color(0xFFFFB300),
                titleColor: Colors.black,
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
