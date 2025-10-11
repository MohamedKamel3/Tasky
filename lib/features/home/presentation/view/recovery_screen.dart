import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:to_do_app/core/widgets/toastification.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/repository/home_repository_impl.dart';
import 'package:to_do_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:to_do_app/features/home/presentation/widgets/task_item_widget.dart';

class RecoveryScreen extends StatelessWidget {
  RecoveryScreen({super.key});
  static const routName = 'RecoveryScreen';
  HomeCubit cubit = HomeCubit(injectableHomeRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Deleted Tasks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            bloc: cubit..getRecoverTasks(),
            builder: (context, state) {
              if (state is GetRecoveryLoading) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: 6,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
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
                      );
                    },
                  ),
                );
              } else if (state is GetRecoveryError) {
                return Center(
                  child: Text('Failed to load deleted tasks'),
                );
              }
              if (cubit.deletedTasks.isEmpty) {
                return Expanded(
                  child: Column(
                    children: [
                      Spacer(
                        flex: 2,
                      ),
                      Image.asset(
                        'assets/icons/recycle.png',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No deleted tasks',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                );
              }
              return Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cubit.deletedTasks.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = cubit.deletedTasks[index];
                    return Slidable(
                      key: ValueKey(task.id),
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          BlocListener<HomeCubit, HomeState>(
                            bloc: cubit,
                            listener: (context, state) {
                              if (state is DeleteRecoveryError) {
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
                                await cubit.deleteTaskFromRecovery(task);
                                await cubit.addTask(task);
                                await cubit.getRecoverTasks();
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              icon: Icons.recycling_rounded,
                              label: 'Restore',
                              borderRadius: BorderRadius.circular(15),
                              spacing: 3,
                            ),
                          ),
                        ],
                      ),
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
                                await cubit.deleteTaskFromRecovery(task);
                                await cubit.getRecoverTasks();
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
                          taskModel: task,
                          callBack: (isCompleted) {},
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
