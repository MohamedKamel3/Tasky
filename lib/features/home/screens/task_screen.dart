// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/core/firebase/firebase_firestore.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/widgets/custom_radio_button.dart';
import 'package:to_do_app/features/home/widgets/edit_task_dialog_widget.dart';
import 'package:to_do_app/features/home/widgets/show_priority_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  static const routName = 'TaskScreen';

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  var titleController = TextEditingController();
  var decriptionController = TextEditingController();

  bool originalDone = false;
  TaskModel? task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments as TaskModel?;
      originalDone = task!.isDone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MaterialButton(
                minWidth: 50,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                color: Color(0xffe0dfe3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  setState(() {});
                },
                child: Text(
                  "x",
                  style: TextStyle(color: Colors.red, fontSize: 25),
                ),
              ),
              Row(
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap: () {
                      originalDone = !originalDone;
                      setState(() {});
                    },
                    child: CustomRadioButton(isCompleted: originalDone),
                  ),
                  Expanded(
                    child: Text(
                      task!.title!,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    color: primaryColor1,
                    onPressed: () async {
                      await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return EditTaskDialog(
                            title: titleController,
                            description: decriptionController,
                            onTapDate: () async {
                              task!.date =
                                  await showDatePicker(
                                    initialDate: task!.date,
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  ) ??
                                  task!.date;
                            },
                            onTapPriority: () async => await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => ShowPriorityDialog(
                                selectedPriority: task!.priority!,
                                callBack: (int p1) {
                                  task!.priority = p1;
                                  setState(() {});
                                },
                              ),
                            ),
                            selectedPriority: task!.priority!,
                            callBack: (String title, String description) async {
                              task!.title = title;
                              task!.description = description;
                              setState(() {});
                            },
                            task: task!,
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit, size: 30),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  task!.description!,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                spacing: 20,
                children: [
                  Image.asset("assets/icons/date.png"),
                  Text(
                    "Task Time :",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task!.date!.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 20,
                children: [
                  Image.asset("assets/icons/flag.png"),
                  Text(
                    "Task Priority :",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task!.priority!.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () async {
                  AppDialog.loadingDialog(context: context);
                  await TaskFirebase.deleteTask(task!).then((_) {
                    Navigator.pop(context);
                    setState(() {
                      Navigator.pop(context, true);
                    });
                  });
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 35),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.red, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: MaterialButton(
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minWidth: double.infinity,
          color: primaryColor1,
          onPressed: () async {
            AppDialog.loadingDialog(context: context);
            task!.isDone = originalDone;
            await TaskFirebase.updateTask(task!).then((_) {
              Navigator.pop(context);
              Navigator.pop(context, true);
              setState(() {});
            });
          },
          child: Text(
            "Comfirm Edit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
