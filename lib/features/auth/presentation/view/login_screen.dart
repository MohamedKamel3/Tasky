// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/core/widgets/toastification.dart';
import 'package:to_do_app/core/utils/validator.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/auth/data/repo/data_source/auth_data_source_impl.dart';
import 'package:to_do_app/features/auth/data/repo/repository/auth_repisitory_impl.dart';
import 'package:to_do_app/features/auth/presentation/view/signup_screen.dart';
import 'package:to_do_app/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:to_do_app/features/auth/presentation/widgets/member-state-widget.dart';
import 'package:to_do_app/features/home/presentation/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const String routName = "LoginScreen";
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();

  var cubit = AuthCubit(
    injectableAuthRepisitory(
      injectableAuthEmailAndPassDataSource(),
    ),
  );

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
                  BlocListener<AuthCubit, AuthState>(
                    bloc: cubit,
                    listener: (context, state) {
                      if (cubit.state is AuthSuccess) {
                        Navigator.pop(context);
                        AppToastification.successToastification(
                          title: "Success",
                          description: "Login successfully",
                          context: context,
                        );
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(HomeScreen.routName);
                      } else if (cubit.state is AuthFailure) {
                        Navigator.pop(context);
                        AppToastification.errorToastification(
                          title: "Error",
                          description: "Login failed, try again",
                          context: context,
                        );
                      } else {
                        AppDialog.loadingDialog(context: context);
                      }
                    },
                    child: MaterialButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await cubit.login(email.text, password.text);
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
}
