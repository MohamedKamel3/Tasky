import 'dart:math';

import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/core/utils/show_date.dart';
import 'package:to_do_app/core/utils/validator.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';

class ShowModalBottomSheet extends StatefulWidget {
  ShowModalBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.onTapDate,
    required this.onTapPriority,
    required this.onTapSend,
    required this.selectedPriority,
    required this.selectedDate,
  });
  TextEditingController title;
  TextEditingController description;
  void Function() onTapDate;
  void Function() onTapPriority;
  void Function() onTapSend;
  ValueNotifier<int> selectedPriority;
  ValueNotifier<DateTime> selectedDate;
  @override
  State<ShowModalBottomSheet> createState() => _ShowModalBottomSheetState();
}

class _ShowModalBottomSheetState extends State<ShowModalBottomSheet> {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Add Task",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                ValueListenableBuilder<DateTime>(
                  valueListenable: widget.selectedDate,
                  builder:
                      (BuildContext context, DateTime value, Widget? child) {
                        return MaterialButton(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          onPressed: widget.onTapDate,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 2, color: Colors.grey),
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              Image.asset("assets/icons/date.png"),
                              Text(
                                showDate(value),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                ),
                SizedBox(width: 10),
                ValueListenableBuilder<int>(
                  valueListenable: widget.selectedPriority,
                  builder: (BuildContext context, int value, Widget? child) {
                    return MaterialButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      onPressed: widget.onTapPriority,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 2, color: Colors.grey),
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Image.asset(
                            "assets/icons/flag.png",
                            color: priorityColors[value - 1],
                          ),
                          Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            TextFormFieldHelper(
              onValidate: Validator.validateTitle,
              hintFontSize: 20,
              fillColor: Colors.transparent,
              hint: "Title",
              borderRadius: 8,
              controller: widget.title,
            ),
            TextFormFieldHelper(
              onValidate: Validator.validateDescription,
              action: TextInputAction.done,
              hintFontSize: 20,
              fillColor: Colors.transparent,
              hint: "Description",
              borderRadius: 8,
              controller: widget.description,
            ),
            SizedBox(height: 5),
            Row(
              spacing: 15,
              children: [
                GestureDetector(
                  onTap: widget.onTapDate,
                  child: Image.asset("assets/icons/date.png", scale: 0.7),
                ),
                GestureDetector(
                  onTap: widget.onTapPriority,
                  child: Image.asset("assets/icons/flag.png", scale: 0.7),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      widget.onTapSend();
                    }
                  },
                  child: Image.asset("assets/icons/send.png", scale: 0.7),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
