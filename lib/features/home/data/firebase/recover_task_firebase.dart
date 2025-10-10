import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/models/task_model.dart';

class RecoverTaskFirebase {
  static CollectionReference<TaskModel> getRecoverTaskCollection() {
    var id = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(id)
        .collection('deleted-tasks')
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<ResultNetwork<void>> addTask(TaskModel taskModel) async {
    try {
      await getRecoverTaskCollection().doc(taskModel.id).set(taskModel);
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  static Future<ResultNetwork<List<TaskModel>>> getTasks() async {
    try {
      Query<TaskModel> query = getRecoverTaskCollection();

      List<TaskModel> tasks = await query.get().then(
        (value) => value.docs.map((e) => e.data()).toList(),
      );
      tasks.sort((a, b) => a.priority!.compareTo(b.priority!));
      return SuccessNetwork(tasks);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  static Future<ResultNetwork<void>> deleteTask(TaskModel taskModel) async {
    try {
      await getRecoverTaskCollection().doc(taskModel.id).delete();
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }
}
