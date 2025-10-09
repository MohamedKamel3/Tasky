// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:to_do_app/core/constants/colors.dart';
import 'package:to_do_app/core/widgets/toastification.dart';
import 'package:to_do_app/features/home/data/firebase/task_firebase.dart';
import 'package:to_do_app/core/widgets/alert_dialog.dart';
import 'package:to_do_app/core/widgets/text_form_field_helper.dart';
import 'package:to_do_app/features/auth/presentation/view/login_screen.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/repository/home_repository_impl.dart';
import 'package:to_do_app/features/home/presentation/view/task_screen.dart';
import 'package:to_do_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:to_do_app/features/home/presentation/widgets/show_modal_bottom_sheet.dart';
import 'package:to_do_app/features/home/presentation/widgets/show_priority_dialog.dart';
import 'package:to_do_app/features/home/presentation/widgets/task_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var title = TextEditingController();
  var description = TextEditingController();
  var searchController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  int selectedPriority = 1;
  DateFilterModel selectedDateFilter = DateFilterModel.all;
  DateTime? selectedDateFilterDate = DateTime.now();
  String? searchString;
  HomeCubit cubit = HomeCubit(injectableHomeRepository());
  ValueNotifier<int?> selectedPriorityFilterNotifier = ValueNotifier(null);

  @override
  void dispose() {
    super.dispose();
    selectedPriorityFilterNotifier.dispose();
  }

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
              action: TextInputAction.done,
              verticalPadding: 15,
              hint: "Search for your task...",
              controller: searchController,
              prefixIcon: Image.asset("assets/icons/search.png"),
              borderRadius: 10,
              borderWidth: 2,
              onChanged: (val) async {
                searchString = val;
                await cubit.getTasksFiltered(
                  date: selectedDateFilterDate!,
                  filter: selectedDateFilter,
                  priority: selectedPriorityFilterNotifier.value,
                  search: searchString,
                );
              },
            ),
            SizedBox(height: 5),
            ValueListenableBuilder<int?>(
              valueListenable: selectedPriorityFilterNotifier,
              builder: (BuildContext context, int? value, Widget? child) {
                return Row(
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
                        await cubit.getTasksFiltered(
                          date: selectedDateFilterDate,
                          filter: selectedDateFilter,
                          priority: selectedPriorityFilterNotifier.value,
                          search: searchString,
                        );
                      },
                    ),
                    Spacer(),
                    selectedPriorityFilterNotifier.value != null
                        ? TextButton(
                            onPressed: () async {
                              selectedPriorityFilterNotifier.value = null;
                              await cubit.getTasksFiltered(
                                date: selectedDateFilterDate!,
                                filter: selectedDateFilter,
                                priority: selectedPriorityFilterNotifier.value,
                                search: searchString,
                              );
                            },
                            child: Text(
                              "x",
                              style: TextStyle(color: Colors.red, fontSize: 25),
                            ),
                          )
                        : Spacer(),
                    MaterialButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      onPressed: () async => await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => ShowPriorityDialog(
                          selectedPriority:
                              selectedPriorityFilterNotifier.value ?? 1,
                          callBack: (int p1) async {
                            selectedPriorityFilterNotifier.value = p1;
                            await cubit.getTasksFiltered(
                              date: selectedDateFilterDate!,
                              filter: selectedDateFilter,
                              priority: selectedPriorityFilterNotifier.value,
                              search: searchString,
                            );
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
                            selectedPriorityFilterNotifier.value == null
                                ? "Priority"
                                : selectedPriorityFilterNotifier.value
                                      .toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder(
              bloc: cubit..getTasksFiltered(),
              builder: (context, state) {
                if (state is HomeError) {
                  return AppDialog.errorDialog(
                    context: context,
                    message: "Something went wrong, please try again",
                  );
                }
                if (state is HomeLoading) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          enabled: true,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TaskItemWidget(
                              taskModel: TaskModel(
                                title: "title",
                                description: "description",
                                date: DateTime.now(),
                                priority: 1,
                                isDone: false,
                              ),
                              callBack: (bool p1) {},
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                var tasks = cubit.tasks;
                var completedTasks = cubit.completedTasks;
                if (tasks.isEmpty && completedTasks.isEmpty) {
                  return _emptyHomeScreen();
                } else {
                  return Expanded(
                    child: ListView(
                      children: [
                        //! Tasks
                        if (tasks.isNotEmpty)
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Slidable(
                                key: ValueKey(task.id),
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    BlocListener<HomeCubit, HomeState>(
                                      bloc: cubit,
                                      listener: (context, state) {
                                        if (state is DeleteError) {
                                          AppToastification.errorToastification(
                                            title: "Error",
                                            description:
                                                "Failed to delete task, please try again",
                                            context: context,
                                          );
                                        }
                                      },
                                      child: SlidableAction(
                                        onPressed: (context) async {
                                          await cubit.deleteTask(task);
                                          await cubit.getTasksFiltered(
                                            date: selectedDateFilterDate!,
                                            filter: selectedDateFilter,
                                            priority:
                                                selectedPriorityFilterNotifier
                                                    .value,
                                            search: searchString,
                                          );
                                        },
                                        backgroundColor: const Color(
                                          0xFFFF4C4C,
                                        ),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_outline,
                                        label: 'Delete',
                                        borderRadius: BorderRadius.circular(15),
                                        spacing: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
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
                                          .then((value) async {
                                            if (value == true) {
                                              await cubit.getTasksFiltered(
                                                date: selectedDateFilterDate!,
                                                filter: selectedDateFilter,
                                                priority:
                                                    selectedPriorityFilterNotifier
                                                        .value,
                                                search: searchString,
                                              );
                                            }
                                          });
                                    },
                                    taskModel: task,
                                    callBack: (isCompleted) async {
                                      task.isDone = isCompleted;
                                      await cubit.updateTask(task);
                                      await cubit.getTasksFiltered(
                                        date: selectedDateFilterDate!,
                                        filter: selectedDateFilter,
                                        priority: selectedPriorityFilterNotifier
                                            .value,
                                        search: searchString,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        //! Completed Tasks
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
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: completedTasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final task = completedTasks[index];
                              return Slidable(
                                key: ValueKey(task.id),
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    BlocListener<HomeCubit, HomeState>(
                                      bloc: cubit,
                                      listener: (context, state) {
                                        if (state is DeleteError) {
                                          AppToastification.errorToastification(
                                            title: "Error",
                                            description:
                                                "Failed to delete task, please try again",
                                            context: context,
                                          );
                                        }
                                      },
                                      child: SlidableAction(
                                        onPressed: (context) async {
                                          await cubit.deleteTask(task);
                                          await cubit.getTasksFiltered(
                                            date: selectedDateFilterDate!,
                                            filter: selectedDateFilter,
                                            priority:
                                                selectedPriorityFilterNotifier
                                                    .value,
                                            search: searchString,
                                          );
                                        },
                                        backgroundColor: const Color(
                                          0xFFFF4C4C,
                                        ),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_outline,
                                        label: 'Delete',
                                        borderRadius: BorderRadius.circular(15),
                                        spacing: 3,
                                      ),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
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
                                          .then((value) async {
                                            if (value == true) {
                                              await cubit.getTasksFiltered(
                                                date: selectedDateFilterDate!,
                                                filter: selectedDateFilter,
                                                priority:
                                                    selectedPriorityFilterNotifier
                                                        .value,
                                                search: searchString,
                                              );
                                            }
                                          });
                                    },
                                    taskModel: task,
                                    callBack: (isCompleted) async {
                                      task.isDone = isCompleted;
                                      await cubit.updateTask(task);
                                      await cubit.getTasksFiltered(
                                        date: selectedDateFilterDate!,
                                        filter: selectedDateFilter,
                                        priority: selectedPriorityFilterNotifier
                                            .value,
                                        search: searchString,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
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
                  },
                ),
              ),
              onTapSend: () async {
                AppDialog.loadingDialog(context: context);
                await cubit
                    .addTask(
                      TaskModel(
                        title: title.text,
                        description: description.text,
                        date: selectedDate,
                        priority: selectedPriority,
                        isDone: false,
                      ),
                    )
                    .then((_) async {
                      title.clear();
                      description.clear();
                      selectedPriority = 1;
                      selectedDate = DateTime.now();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      await cubit.getTasksFiltered(
                        date: selectedDateFilterDate!,
                        filter: selectedDateFilter,
                        priority: selectedPriorityFilterNotifier.value,
                        search: searchString,
                      );
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
