import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/data_source/home_data_source.dart';
import 'package:to_do_app/features/home/data/repo/data_source/home_data_source_impl.dart';
import 'package:to_do_app/features/home/data/repo/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this.homeDataSource);
  HomeDataSource homeDataSource;
  @override
  Future<ResultNetwork<void>> addTask(TaskModel taskModel) =>
      homeDataSource.addTask(taskModel);

  @override
  Future<ResultNetwork<void>> deleteTask(TaskModel taskModel) =>
      homeDataSource.deleteTask(taskModel);

  @override
  Future<ResultNetwork<List<TaskModel>>> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  }) => homeDataSource.getTasksFiltered(
    date: date,
    filter: filter,
    priority: priority,
    search: search,
  );

  @override
  Future<ResultNetwork<void>> updateTask(TaskModel taskModel) =>
      homeDataSource.updateTask(taskModel);

  @override
  Future<ResultNetwork<void>> addTaskToRecovery(TaskModel taskModel) =>
      homeDataSource.addTaskToRecovery(taskModel);

  @override
  Future<ResultNetwork<void>> deleteRecoverTask(TaskModel taskModel) =>
      homeDataSource.deleteRecoverTask(taskModel);

  @override
  Future<ResultNetwork<List<TaskModel>>> getRecoverTasks() =>
      homeDataSource.getRecoverTasks();
}

HomeRepository injectableHomeRepository() =>
    HomeRepositoryImpl(injectableHomeDataSource());
