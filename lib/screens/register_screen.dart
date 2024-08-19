import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_council/controllers/user_controller.dart';
import 'package:urban_council/screens/bottom_navigation_screen.dart';
import 'package:urban_council/widgets/circular_loading_indicator.dart';
import 'package:urban_council/widgets/text_form_field.dart';

import '../widgets/colors.dart';

class RegisterScreen extends StatefulWidget {
  final String uid;

  const RegisterScreen({super.key, required this.uid});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String uid;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //add user details
  registerUser() async {
    setState(() {
      isLoading = true;
    });
    await UserController().submitDetails(
      uid,
      fNameController.text,
      lNameController.text,
      emailController.text,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', uid);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashScreen()),
      (Route<dynamic> route) => false,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      uid = ModalRoute.of(context)!.settings.arguments as String;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Resident Registration',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: ColorTheme.whiteColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/homeScreen');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: isLoading
            ? const MyLoadingIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              MyTextFieldForm(
                                labelText: 'First Name',
                                hintText: 'Enter First Name',
                                isRequierd: true,
                                controller: fNameController,
                                inputFormatter: [],
                                onChanged: (value) {
                                  setState(() {
                                    fNameController.text = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter First Name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              MyTextFieldForm(
                                labelText: 'Last Name',
                                hintText: 'Enter Last Name',
                                isRequierd: true,
                                controller: lNameController,
                                inputFormatter: [],
                                onChanged: (value) {
                                  setState(() {
                                    lNameController.text = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Last Name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              MyTextFieldForm(
                                labelText: 'Email',
                                hintText: 'Enter Email',
                                isRequierd: true,
                                controller: emailController,
                                inputFormatter: [],
                                onChanged: (value) {
                                  setState(() {
                                    emailController.text = value;
                                  });
                                },
                                validator: (value) {
                                  const pattern =
                                      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                                  final regex = RegExp(pattern);

                                  if (value!.isEmpty) {
                                    return 'Enter Email';
                                  }

                                  if (!regex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }

                                  return null;
                                },
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color(0xFF3B3B3B),
                                      width: 1.5)),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: GestureDetector(
                            onTap: registerUser,
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF3B3B3B),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                      // CommonButton(
                      //     title: 'Enter',
                      //     onPressed: () async {
                      //       if (_formKey.currentState!.validate()) {
                      //         sendOTP();
                      //       }
                      //     })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
