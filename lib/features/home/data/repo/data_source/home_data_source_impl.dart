import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/firebase/recover_task_firebase.dart';
import 'package:to_do_app/features/home/data/firebase/task_firebase.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/data_source/home_data_source.dart';

class HomeDataSourceImpl implements HomeDataSource {
  HomeDataSourceImpl(this.taskFirebase, this.recoverTaskFirebase);
  TaskFirebase taskFirebase;
  RecoverTaskFirebase recoverTaskFirebase;
  @override
  Future<ResultNetwork<void>> addTask(TaskModel taskModel) =>
      taskFirebase.addTask(taskModel);

  @override
  Future<ResultNetwork<void>> deleteTask(TaskModel taskModel) =>
      taskFirebase.deleteTask(taskModel);

  @override
  Future<ResultNetwork<List<TaskModel>>> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  }) => taskFirebase.getTasksFiltered(
    date: date,
    filter: filter,
    priority: priority,
    search: search,
  );

  @override
  Future<ResultNetwork<void>> updateTask(TaskModel taskModel) =>
      taskFirebase.updateTask(taskModel);

  @override
  Future<ResultNetwork<void>> addTaskToRecovery(TaskModel taskModel) =>
      recoverTaskFirebase.addTaskToRecovery(taskModel);

  @override
  Future<ResultNetwork<void>> deleteRecoverTask(TaskModel taskModel) =>
      recoverTaskFirebase.deleteRecoverTask(taskModel);

  @override
  Future<ResultNetwork<List<TaskModel>>> getRecoverTasks() =>
      recoverTaskFirebase.getRecoverTasks();
}

HomeDataSource injectableHomeDataSource() =>
    HomeDataSourceImpl(TaskFirebase.instance, RecoverTaskFirebase.instance);
