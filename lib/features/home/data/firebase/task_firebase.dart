import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/features/home/data/models/date_filter_model.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';

class TaskFirebase {
  static CollectionReference<TaskModel> getTaskCollection() {
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

  static Future<void> addTask(TaskModel taskModel) async {
    var id = getTaskCollection().doc().id;
    taskModel.id = id;
    await getTaskCollection().doc(id).set(taskModel);
  }

  static Future<List<TaskModel>> getTasksFiltered({
    DateTime? date,
    DateFilterModel? filter,
    int? priority,
    String? search,
  }) async {
    Query<TaskModel> query = getTaskCollection();

    if (filter == DateFilterModel.day && date != null) {
      query = query
          .where(
            'date',
            isGreaterThanOrEqualTo: DateTime.now()
                .subtract(const Duration(hours: 15))
                .millisecondsSinceEpoch,
          )
          .where(
            'date',
            isLessThanOrEqualTo: DateTime.now()
                .add(const Duration(hours: 15))
                .millisecondsSinceEpoch,
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

    return tasks;
  }

  static Future<void> updateTask(TaskModel taskModel) async {
    await getTaskCollection().doc(taskModel.id).update(taskModel.toJson());
  }

  static Future<void> deleteTask(TaskModel taskModel) async {
    await getTaskCollection().doc(taskModel.id).delete();
  }
}
