import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';

class ShowPriorityDialog extends StatefulWidget {
  ShowPriorityDialog({
    super.key,
    required this.callBack,
    required this.selectedPriority,
  });
  Function(int) callBack;
  int selectedPriority;

  @override
  State<ShowPriorityDialog> createState() => _ShowPriorityDialogState();
}

class _ShowPriorityDialogState extends State<ShowPriorityDialog> {
  List priorities = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Column(
          children: [
            Text(
              "Task Priority",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(color: Colors.black54, thickness: 2),
          ],
        ),
        content: Wrap(
          runSpacing: 10,
          children: priorities.map((e) {
            bool isSelected = widget.selectedPriority == e ? true : false;
            return GestureDetector(
              onTap: () {
                widget.selectedPriority = e;
                widget.callBack(widget.selectedPriority);
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor1 : Colors.white,
                  border: Border.all(
                    width: 2,
                    color: isSelected ? Colors.transparent : primaryColor1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    Image.asset(
                      "assets/icons/flag.png",
                      color: isSelected ? Colors.white : primaryColor1,
                    ),
                    Text(
                      "$e",
                      style: TextStyle(
                        color: isSelected ? Colors.white : primaryColor1,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(4),
            ),
            minWidth: double.infinity,
            color: primaryColor1,
            padding: EdgeInsets.all(10),
            onPressed: () {
              widget.callBack(widget.selectedPriority);
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
