import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';

class TaskFirebase {
  TaskFirebase._();
  static TaskFirebase? _instance;
  static TaskFirebase get instance => _instance ?? TaskFirebase._();

  CollectionReference<TaskModel> getTaskCollection() {
    var id = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(id)
        .collection('tasks')
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  Future<ResultNetwork<void>> addTask(TaskModel taskModel) async {
    try {
      var id = getTaskCollection().doc().id;
      taskModel.id = id;
      await getTaskCollection().doc(id).set(taskModel);
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  Future<ResultNetwork<List<TaskModel>>> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  }) async {
    try {
      Query<TaskModel> query = getTaskCollection();
      if (filter == DateFilterModel.day && date != null) {
        query = query.where(
          'date',
          isEqualTo: DateTime(
            date.year,
            date.month,
            date.day,
          ).millisecondsSinceEpoch,
        );
      } else if (filter == DateFilterModel.week) {
        query = query
            .where(
              'date',
              isGreaterThanOrEqualTo: DateTime.now()
                  .subtract(const Duration(days: 8))
                  .millisecondsSinceEpoch,
            )
            .where(
              'date',
              isLessThanOrEqualTo: DateTime.now()
                  .add(const Duration(days: 7))
                  .millisecondsSinceEpoch,
            );
      } else if (filter == DateFilterModel.month) {
        query = query
            .where(
              'date',
              isGreaterThanOrEqualTo: DateTime.now()
                  .subtract(const Duration(days: 31))
                  .millisecondsSinceEpoch,
            )
            .where(
              'date',
              isLessThanOrEqualTo: DateTime.now()
                  .add(const Duration(days: 30))
                  .millisecondsSinceEpoch,
            );
      }
      if (priority != null) {
        query = query.where('priority', isEqualTo: priority);
      }
      if (search != null && search.isNotEmpty) {
        query = query
            .orderBy('titleLowerCase')
            .startAt([search.toLowerCase()])
            .endAt([search.toLowerCase() + '\uf8ff']);
      }
      var snapshot = await query.get();
      var tasks = snapshot.docs.map((e) => e.data()).toList();
      tasks.sort((a, b) => a.priority!.compareTo(b.priority!));
      return SuccessNetwork(tasks);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  Future<ResultNetwork<void>> updateTask(TaskModel taskModel) async {
    try {
      await getTaskCollection().doc(taskModel.id).update(taskModel.toJson());
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  Future<ResultNetwork<void>> deleteTask(TaskModel taskModel) async {
    try {
      await getTaskCollection().doc(taskModel.id).delete();
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }
}
