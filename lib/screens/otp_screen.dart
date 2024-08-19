import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_council/screens/bottom_navigation_screen.dart';
import 'package:urban_council/services/user_service.dart';
import 'package:urban_council/widgets/circular_loading_indicator.dart';

import '../controllers/phone_authentication.dart';
import '../widgets/app_textStyle.dart';
import '../widgets/colors.dart';
import '../widgets/common_button.dart';

class OTPScreen extends StatefulWidget {
  final String verification;
  const OTPScreen({
    super.key,
    required this.verification,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool isLoading = false;
  final otpController = TextEditingController();

  _commonPinput([Color color = ColorTheme.blackColor, double width = 1]) =>
      PinTheme(
        width: 45,
        height: 45,
        textStyle: const TextStyle(fontSize: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color, width: width),
        ),
      );

  //verifyOTP
  verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: widget.verification, smsCode: otpController.text);

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(cred);

      // If user already registered
      if (userCredential.user != null) {
        if (await PhoneAuthentication()
            .checkIfUserExists(userCredential.user!.uid)) {
          // Store user ID in device storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userCredential.user!.uid);

          UserService().setUserId(userCredential.user!.uid);

          // Navigate to the dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          // If new user
          await PhoneAuthentication().storeUserData(userCredential.user!);

          UserService().setUserId(userCredential.user!.uid);

          Navigator.of(context).pushReplacementNamed(
            '/registerScreen',
            arguments: userCredential.user!.uid,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP Verification Failed'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });

    // try {
    //   Map<String, String> resultMap = await PhoneAuthentication().verifyOTPCode(
    //     verifyId: widget.verification,
    //     otp: otpController.text,
    //   );

    //   String result = resultMap['result']!;
    //   String uid = resultMap['uid']!;

    //   UserService().setUserId(uid);

    //   if (result == 'registered') {
    //     // Store user ID in device storage
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setString('userId', uid);

    //     // Navigate to the dashboard
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => DashScreen()),
    //       (Route<dynamic> route) => false,
    //     );
    //   } else if (result == 'new_user') {
    //     Navigator.of(context).pushReplacementNamed(
    //       '/registerScreen',
    //       arguments: uid,
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('OTP Verification Failed'),
    //         duration: Duration(seconds: 1),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   e.toString();
    // }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: ColorTheme.whiteColor,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.of(context).popAndPushNamed('/phoneScreen');
      //       },
      //       icon: const Icon(Icons.arrow_back)),
      // ),
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: isLoading
              ? const MyLoadingIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Resident Login',
                        style: appTextStyle(
                            ColorTheme.blackColor, FontWeight.w400, 24),
                      ),
                      Image.asset(
                        'assets/images/logo.jpeg',
                        height: 180,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Enter OTP',
                            style: appTextStyle(
                                ColorTheme.blackColor, FontWeight.w400, 14),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Pinput(
                        controller: otpController,
                        length: 6,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        defaultPinTheme: _commonPinput(),
                        submittedPinTheme:
                            _commonPinput(ColorTheme.blackColor, 1.5),
                        focusedPinTheme:
                            _commonPinput(ColorTheme.blackColor, 1.5),
                        followingPinTheme:
                            _commonPinput(ColorTheme.blackColor, 1.5),
                        onChanged: (value) {
                          otpController.text = value;
                        },
                      ),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't get a code?",
                            style: appTextStyle(
                                ColorTheme.blackColor, FontWeight.w400, 14),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            child: Text(
                              "Resend",
                              style: appTextStyle(
                                  ColorTheme.blackColor, FontWeight.w500, 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 45),
                      CommonButton(
                        title: 'Submit',
                        onPressed: verifyOTP,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Change mobile number.",
                          style: appTextStyle(
                              ColorTheme.blackColor, FontWeight.w400, 14),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
