import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/home/data/models/user_model.dart';

abstract class AuthFirebase {
  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<ResultNetwork> updateUser(UserModel userModel) async {
    try {
      var id = FirebaseAuth.instance.currentUser!.uid;
      await getUserCollection().doc(id).update(userModel.toJson());
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  static Future<ResultNetwork> deleteUser() async {
    try {
      var id = FirebaseAuth.instance.currentUser!.uid;
      await getUserCollection().doc(id).delete();
      return SuccessNetwork(null);
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }
}
