// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/assets_consts.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/features/auth/screens/login_screen.dart';
import 'package:to_do_app/features/home/screens/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key, required this.nextRoutName});

  static const String routName = 'SplashScreen';

  String nextRoutName;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1720), () {
      Navigator.of(context).pushReplacementNamed(widget.nextRoutName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor1,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInLeft(
              duration: Duration(milliseconds: 900),
              child: Image.asset(AssetsConsts.taskIcon),
            ),
            BounceInDown(
              delay: Duration(milliseconds: 900),
              duration: Duration(milliseconds: 800),
              from: 50,
              child: Image.asset(AssetsConsts.yIcon),
            ),
          ],
        ),
      ),
    );
  }
}
