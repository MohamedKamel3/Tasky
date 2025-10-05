// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/utils/validator.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/core/widgets/toastification.dart';
import 'package:to_do_app/features/auth/data/repo/data_source/auth_data_source_impl.dart';
import 'package:to_do_app/features/auth/data/repo/repository/auth_repisitory_impl.dart';
import 'package:to_do_app/features/auth/presentation/view_model/auth/auth_cubit.dart';
import 'package:to_do_app/features/auth/presentation/widgets/member-state-widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routName = "SignupScreen";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var name = TextEditingController();
  var cubit = AuthCubit(
    injectableAuthRepisitory(injectableAuthEmailAndPassDataSource()),
  );
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
                BlocListener<AuthCubit, AuthState>(
                  bloc: cubit,
                  listener: (context, state) {
                    if (state is AuthFailure ||
                        state is AuthSuccess ||
                        state is UserFailure ||
                        state is UserSuccess) {
                      Navigator.pop(context);
                      if (state is AuthSuccess) {
                      } else if (state is AuthFailure) {
                        AppToastification.errorToastification(
                          title: "Error",
                          context: context,
                          description: state.message,
                        );
                      } else if (state is UserSuccess) {
                        AppToastification.successToastification(
                          title: "Success",
                          context: context,
                          description: "Account has been created successfully",
                        );
                        Navigator.of(context).pop();
                      } else if (state is UserFailure) {
                        AppToastification.errorToastification(
                          title: "Error",
                          context: context,
                          description: state.message,
                        );
                      }
                    } else {
                      AppDialog.loadingDialog(context: context);
                    }
                  },
                  child: MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await cubit.signUp(email.text, password.text);
                        if (FirebaseAuth.instance.currentUser?.uid != null) {
                          await cubit.addUser(email.text, name.text);
                        }
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

  // AuthFirebase.addUser(
  //   UserModel(name: name.text, email: email.text),
  // );
}
