import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({super.key, required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: primaryColor1,
      child: CircleAvatar(
        radius: 13,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 10,
          backgroundColor: isCompleted ? primaryColor1 : Colors.white,
        ),
      ),
    );
  }
}
