import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({super.key, required this.priority});

  final int priority;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 10,
        children: [
          Image.asset(
            "assets/icons/flag.png",
            color: priorityColors[priority - 1],
          ),
          Text(
            priority.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
