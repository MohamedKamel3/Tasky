// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/features/home/data/firebase/task_firebase.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/auth/presentation/view/login_screen.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/presentation/view/task_screen.dart';
import 'package:to_do_app/features/home/presentation/widgets/show_modal_bottom_sheet.dart';
import 'package:to_do_app/features/home/presentation/widgets/show_priority_dialog.dart';
import 'package:to_do_app/features/home/presentation/widgets/task_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routName = 'HomeScreen';

  Object? get taskModel => null;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var title = TextEditingController();
  var description = TextEditingController();
  var searchController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  int selectedPriority = 1;

  int? selectedPriorityFilter;
  DateFilterModel selectedDateFilter = DateFilterModel.all;
  DateTime? selectedDateFilterDate = DateTime.now();

  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];
  String? searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          children: [
            TextFormFieldHelper(
              action: TextInputAction.none,
              verticalPadding: 15,
              hint: "Search for your task...",
              controller: searchController,
              prefixIcon: Image.asset("assets/icons/search.png"),
              borderRadius: 10,
              borderWidth: 2,
              onChanged: (val) {
                searchString = val;
                setState(() {});
              },
            ),
            SizedBox(height: 5),
            Row(
              children: [
                DropdownMenu(
                  width: 125,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2, color: Colors.grey),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  showTrailingIcon: false,
                  initialSelection: DateFilterModel.all,
                  leadingIcon: Image.asset("assets/icons/date.png"),
                  dropdownMenuEntries: DateFilterModel.entries,
                  onSelected: (value) async {
                    selectedDateFilter = value!;
                    if (value == DateFilterModel.day) {
                      selectedDateFilterDate =
                          await showDatePicker(
                            initialDate: selectedDateFilterDate,
                            context: context,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 350),
                            ),
                          ) ??
                          selectedDateFilterDate;
                    }
                    setState(() {});
                  },
                ),
                Spacer(),
                selectedPriorityFilter != null
                    ? TextButton(
                        onPressed: () {
                          selectedPriorityFilter = null;
                          setState(() {});
                        },
                        child: Text(
                          "x",
                          style: TextStyle(color: Colors.red, fontSize: 25),
                        ),
                      )
                    : Spacer(),
                MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  onPressed: () async => await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => ShowPriorityDialog(
                      selectedPriority: selectedPriorityFilter ?? 1,
                      callBack: (int p1) {
                        selectedPriorityFilter = p1;
                        setState(() {});
                      },
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(width: 1, color: Colors.grey),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Image.asset("assets/icons/flag.png"),
                      Text(
                        selectedPriorityFilter == null
                            ? "Priority"
                            : selectedPriorityFilter.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: TaskFirebase.getTasksFiltered(
                date: selectedDateFilterDate!,
                filter: selectedDateFilter,
                priority: selectedPriorityFilter,
                search: searchString,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  completedTasks = snapshot.data!
                      .where((element) => element.isDone == true)
                      .toList();
                  tasks = snapshot.data!
                      .where((element) => element.isDone == false)
                      .toList();
                  if (tasks.isEmpty && completedTasks.isEmpty) {
                    return _emptyHomeScreen();
                  } else {
                    return Expanded(
                      child: ListView(
                        children: [
                          ...tasks.map((task) {
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await TaskFirebase.deleteTask(task);
                                      setState(() {});
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: TaskItemWidget(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                        TaskScreen.routName,
                                        arguments: task,
                                      )
                                      .then((value) {
                                        if (value == true) {
                                          setState(() {});
                                        }
                                      });
                                },
                                taskModel: task,
                                callBack: (isCompleted) async {
                                  task.isDone = isCompleted;
                                  await TaskFirebase.updateTask(task);
                                  setState(() {});
                                },
                              ),
                            );
                          }),
                          if (completedTasks.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            const Text(
                              "Completed",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...completedTasks.map((task) {
                              return TaskItemWidget(
                                taskModel: task,
                                callBack: (isCompleted) async {
                                  task.isDone = isCompleted;
                                  await TaskFirebase.updateTask(task);
                                  setState(() {});
                                },
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                        TaskScreen.routName,
                                        arguments: task,
                                      )
                                      .then((value) {
                                        if (value == true) {
                                          setState(() {});
                                        }
                                      });
                                },
                              );
                            }),
                          ],
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor1,
      shape: CircleBorder(),
      onPressed: () async {
        await showModalBottomSheet(
          backgroundColor: Colors.white,
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ShowModalBottomSheet(
              selectedPriority: selectedPriority,
              onTapDate: () async {
                selectedDate =
                    await showDatePicker(
                      initialDate: selectedDate,
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ) ??
                    selectedDate;
              },
              onTapPriority: () async => await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ShowPriorityDialog(
                  selectedPriority: selectedPriority,
                  callBack: (int p1) {
                    selectedPriority = p1;
                    setState(() {});
                  },
                ),
              ),
              onTapSend: () async {
                AppDialog.loadingDialog(context: context);
                await TaskFirebase.addTask(
                  TaskModel(
                    title: title.text,
                    description: description.text,
                    date: selectedDate,
                    priority: selectedPriority,
                    isDone: false,
                  ),
                ).then((_) {
                  title.clear();
                  description.clear();
                  selectedPriority = 1;
                  selectedDate = DateTime.now();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  setState(() {});
                });
              },
              title: title,
              description: description,
            );
          },
        );
      },
      child: Icon(Icons.add, color: Colors.white, size: 40),
    );
  }

  Widget _emptyHomeScreen() {
    return Expanded(
      child: SizedBox(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              spacing: 10,
              children: [
                SizedBox(height: 30),
                Image.asset("assets/images/empty_home_screen.png"),
                Text(
                  "What do you want to do today?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Tap + to add your tasks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset("assets/icons/tasky.png", height: 50, width: 100),
          Spacer(),
          GestureDetector(
            onTap: () async {
              AppDialog.loadingDialog(context: context);
              await FirebaseAuth.instance.signOut().then((_) {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pushReplacementNamed(LoginScreen.routName);
              });
            },
            child: Image.asset("assets/icons/logout.png"),
          ),
        ],
      ),
    );
  }
}
