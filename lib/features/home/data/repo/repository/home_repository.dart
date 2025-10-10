import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';

abstract class HomeRepository {
  Future<ResultNetwork<void>> addTask(TaskModel taskModel);

  Future<ResultNetwork<List<TaskModel>>> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  });

  Future<ResultNetwork<void>> updateTask(TaskModel taskModel);

  Future<ResultNetwork<void>> deleteTask(TaskModel taskModel);
}
