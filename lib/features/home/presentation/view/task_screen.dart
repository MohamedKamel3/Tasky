// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/core/utils/show_date.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/repository/home_repository_impl.dart';
import 'package:to_do_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:to_do_app/features/home/presentation/widgets/custom_radio_button.dart';
import 'package:to_do_app/features/home/presentation/widgets/edit_task_dialog_widget.dart';
import 'package:to_do_app/features/home/presentation/widgets/show_priority_dialog.dart';

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
  bool hasChanges = false;
  TaskModel? task;
  DateTime? date;
  int? priority;
  HomeCubit homeCubit = HomeCubit(injectableHomeRepository());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments as TaskModel?;
      originalDone = task!.isDone;
      date = task!.date;
      priority = task!.priority;
    }
  }

  void checkForChanges() {
    bool changed =
        originalDone != task!.isDone ||
        titleController.text != task!.title ||
        decriptionController.text != task!.description ||
        date != task!.date ||
        priority != task!.priority;

    if (changed != hasChanges) {
      setState(() {
        hasChanges = changed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black87),
            onPressed: () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return EditTaskDialog(
                    title: titleController,
                    description: decriptionController,
                    onCancel: () {
                      date = task!.date;
                      priority = task!.priority;
                    },
                    onTapDate: () async {
                      final newDate =
                          await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          ) ??
                          date;

                      if (newDate != date) {
                        setState(() {
                          date = newDate;
                          hasChanges = true; // 🔥 New
                        });
                      }
                    },
                    onTapPriority: () async => await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => ShowPriorityDialog(
                        selectedPriority: priority!,
                        callBack: (int p1) {
                          if (p1 != priority) {
                            priority = p1;
                            hasChanges = true;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    selectedPriority: priority!,
                    onSave: (String title, String description) async {
                      if (title != task!.title ||
                          description != task!.description ||
                          date != task!.date ||
                          priority != task!.priority) {
                        task!.title = title;
                        task!.description = description;
                        task!.date = date!;
                        task!.priority = priority!;
                        hasChanges = true;
                        setState(() {});
                      }
                    },
                    task: task!,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: () {
                        originalDone = !originalDone;
                        hasChanges = true; // 🔥 New
                        setState(() {});
                      },
                      child: CustomRadioButton(isCompleted: originalDone),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task!.title!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: originalDone ? Colors.grey : Colors.black,
                              decoration: originalDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task!.description ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                ),
                title: const Text(
                  "Task Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor1,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    showDate(task!.date!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.flag_outlined, color: Colors.black54),
                title: const Text(
                  "Priority",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColors[task!.priority! - 1],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task!.priority.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                label: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  AppDialog.loadingDialog(context: context);
                  await homeCubit.addTaskToRecovery(task!);
                  await homeCubit.deleteTask(task!).then((_) {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  });
                },
              ),
            ),
            if (hasChanges)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor1,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    AppDialog.loadingDialog(context: context);
                    task!.isDone = originalDone;
                    await homeCubit.updateTask(task!).then((_) {
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    });
                  },
                  child: const Text(
                    "Confirm Edit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
