import 'package:flutter/material.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';

class EditTaskDialog extends StatelessWidget {
  EditTaskDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onTapDate,
    required this.onTapPriority,
    required this.selectedPriority,
    required this.onSave,
    required this.onCancel,
    required this.task,
  });

  TextEditingController title;
  TextEditingController description;
  final VoidCallback onTapDate;
  final VoidCallback onTapPriority;
  final TaskModel task;
  Function(String, String) onSave;
  Function onCancel;

  int selectedPriority = 1;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Column(
          children: [
            Text(
              "Edit Task",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(color: Colors.black54, thickness: 2),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              TextFormFieldHelper(
                hintFontSize: 20,
                fillColor: Colors.transparent,
                hint: task.title,
                borderRadius: 8,
                controller: title,
              ),
              TextFormFieldHelper(
                hintFontSize: 20,
                fillColor: Colors.transparent,
                hint: task.description,
                borderRadius: 8,
                controller: description,
                action: TextInputAction.done,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 15,
                children: [
                  GestureDetector(
                    onTap: onTapDate,
                    child: Image.asset("assets/icons/date.png", scale: 0.7),
                  ),
                  GestureDetector(
                    onTap: onTapPriority,
                    child: Image.asset("assets/icons/flag.png", scale: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onCancel();
              title.clear();
              description.clear();
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              if (title.text.isNotEmpty && description.text.isNotEmpty) {
                onSave(title.text, description.text);
              } else if (title.text.isEmpty && description.text.isNotEmpty) {
                onSave(task.title!, description.text);
              } else if (title.text.isNotEmpty && description.text.isEmpty) {
                onSave(title.text, task.description!);
              } else {
                onSave(task.title!, task.description!);
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
