import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';
import 'package:to_do_app/features/home/data/repo/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepository) : super(HomeInitial());
  HomeRepository homeRepository;
  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];

  Future<void> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  }) async {
    emit(HomeLoading());
    var result = await homeRepository.getTasksFiltered(
      date: date,
      filter: filter,
      priority: priority,
      search: search,
    );
    switch (result) {
      case SuccessNetwork<List<TaskModel>>():
        tasks = result.data.where((task) => task.isDone == false).toList();
        completedTasks = result.data
            .where((task) => task.isDone == true)
            .toList();
        emit(HomeSuccess());
      case ErrorNetwork<List<TaskModel>>():
        emit(HomeError());
    }
  }

  Future<void> updateTask(TaskModel task) async {
    var result = await homeRepository.updateTask(task);
    switch (result) {
      case SuccessNetwork<void>():
        emit(UpdateSuccess());
      case ErrorNetwork<void>():
        emit(UpdateError());
    }
  }

  Future<void> deleteTask(TaskModel taskId) async {
    var result = await homeRepository.deleteTask(taskId);
    switch (result) {
      case SuccessNetwork<void>():
        emit(DeleteSuccess());
      case ErrorNetwork<void>():
        emit(DeleteError());
    }
  }

  Future<void> addTask(TaskModel task) async {
    var result = await homeRepository.addTask(task);
    switch (result) {
      case SuccessNetwork<void>():
        emit(DeleteSuccess());
      case ErrorNetwork<void>():
        emit(DeleteError());
    }
  }
}
