// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/firebase/auth_firebase.dart';
import 'package:to_do_app/core/utils/validator.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/features/auth/screens/login_screen.dart';
import 'package:to_do_app/features/auth/widgets/member-state-widget.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const String routName = "SignupScreen";
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "username",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                TextFormFieldHelper(
                  keyboardType: TextInputType.name,
                  borderRadius: 12,
                  hint: "Enter your username",
                  onValidate: Validator.validateName,
                  controller: name,
                ),
                SizedBox(height: 20),
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
                  keyboardType: TextInputType.visiblePassword,
                  controller: password,
                  borderRadius: 12,
                  hint: "Enter your password",
                  isPassword: true,
                  onValidate: Validator.validatePassword,
                ),
                SizedBox(height: 20),
                Text(
                  "confirm password",
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
                  controller: confirmPassword,
                  borderRadius: 12,
                  hint: "Enter your password",
                  isPassword: true,
                  onValidate: (val) =>
                      Validator.validateConfirmPassword(val, password.text),
                ),
                SizedBox(height: 50),
                MaterialButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      AppDialog.loadingDialog(context: context);
                      await _signUp()
                          .then((value) {
                            Navigator.of(context).pop();
                            AuthFirebase.addUser(
                              UserModel(name: name.text, email: email.text),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (route) => false,
                            );
                            ();
                          })
                          .catchError((e) {
                            Navigator.of(context).pop();
                            AppDialog.errorDialog(
                              context: context,
                              message: e.toString(),
                            );
                          });
                    }
                  },
                  color: Color(0xff5f33e1),
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Register",
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
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom == 0
          ? MemberStateWidget(
              title: "Already have an account?",
              subtitle: "Login",
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
    );
  }

  Future<void> _signUp() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
