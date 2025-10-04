import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';

class AuthFirebase {
  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> addUser(UserModel userModel) async {
    var id = FirebaseAuth.instance.currentUser!.uid;
    await getUserCollection().doc(id).set(userModel);
  }

  static Future<void> updateUser(UserModel userModel) async {
    var id = FirebaseAuth.instance.currentUser!.uid;
    await getUserCollection().doc(id).update(userModel.toJson());
  }

  static Future<void> deleteUser() async {
    var id = FirebaseAuth.instance.currentUser!.uid;
    await getUserCollection().doc(id).delete();
  }
}
