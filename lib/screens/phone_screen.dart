import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_council/widgets/circular_loading_indicator.dart';
import 'package:urban_council/widgets/text_form_field.dart';

import '../widgets/app_textStyle.dart';
import '../widgets/colors.dart';
import '../widgets/common_button.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //send OTP

  sendOTP() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+94${phoneController.text}',
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send OTP. Please try again.'),
            duration: Duration(seconds: 1),
          ),
        );
        log(error.toString());
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(verification: verificationId),
            ));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log("Auto Retireval timeout");
      },
    );
    // await PhoneAuthentication().sendOTPCode(
    //   phoneController.text,
    //   (String verId) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) => OTPScreen(verification: verId),
    //       ),
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    phoneController.dispose();
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
      //         Navigator.of(context).popAndPushNamed('/homeScreen');
      //       },
      //       icon: const Icon(Icons.arrow_back)),
      // ),
      body: SafeArea(
        child: isLoading
            ? const MyLoadingIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
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
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          child: MyTextFieldForm(
                            labelText: 'Mobile Number',
                            controller: phoneController,
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(9)
                            ],
                            onChanged: (value) {
                              setState(() {
                                phoneController.text = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter phone number';
                              }
                              if (value.length != 9) {
                                return 'Enter 9 digit number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          )),
                      const SizedBox(height: 20),
                      CommonButton(
                          title: 'Enter',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              sendOTP();
                            }
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
