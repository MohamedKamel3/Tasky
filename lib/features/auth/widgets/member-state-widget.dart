import 'package:flutter/material.dart';

class MemberStateWidget extends StatelessWidget {
  MemberStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPressed,
  });
  String title;
  String subtitle;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        TextButton(
          onPressed: onPressed,
          child: Text(subtitle, style: TextStyle(color: Color(0xffff3951))),
        ),
      ],
    );
  }
}
