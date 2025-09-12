// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/firebase/authentication.dart';
import 'package:to_do_app/core/utils/validator.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/auth/data/utils/result_network.dart';
import 'package:to_do_app/features/auth/screens/signup_screen.dart';
import 'package:to_do_app/features/auth/widgets/member-state-widget.dart';
import 'package:to_do_app/features/home/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const String routName = "LoginScreen";
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormFieldHelper(
                    keyboardType: TextInputType.emailAddress,
                    borderRadius: 12,
                    hint: "Enter your email",
                    onValidate: Validator.validateEmail,
                    controller: email,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormFieldHelper(
                    action: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    controller: password,
                    borderRadius: 12,
                    hint: "Enter your password",
                    isPassword: true,
                    onValidate: Validator.validatePassword,
                  ),
                  SizedBox(height: 70),
                  MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        AppDialog.loadingDialog(context: context);
                        await login(context);
                      }
                    },
                    color: Color(0xff5f33e1),
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom == 0
          ? MemberStateWidget(
              title: "Don't have an account?",
              subtitle: "Sign Up",
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SignupScreen()));
              },
            )
          : null,
    );
  }

  Future<void> login(BuildContext context) async {
    Authentication login = AuthEmailAndPassImp(
      email: email.text,
      password: password.text,
    );
    ResultNetwork result = await login.login();
    switch (result) {
      case SuccessNetwork():
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routName);
      case ErrorNetwork():
        Navigator.pop(context);
        AppDialog.errorDialog(
          context: context,
          message: result.exception.toString(),
        );
    }
  }
}
