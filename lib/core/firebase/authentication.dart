import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/core/utils/result_network.dart';

abstract class Authentication {
  Future<ResultNetwork> login();
  Future<ResultNetwork> signup();
}

class AuthEmailAndPassImp implements Authentication {
  AuthEmailAndPassImp({
    required this.email,
    required this.password,
  });
  String email;
  String password;

  @override
  Future<ResultNetwork<UserCredential>> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SuccessNetwork(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ErrorNetwork(Exception('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return ErrorNetwork(
          Exception('Wrong password provided for that user.'),
        );
      } else {
        return ErrorNetwork(Exception(e.code));
      }
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }

  @override
  Future<ResultNetwork<UserCredential>> signup() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
      return SuccessNetwork(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ErrorNetwork(Exception('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return ErrorNetwork(
          Exception('The account already exists for that email.'),
        );
      } else {
        return ErrorNetwork(Exception(e.code));
      }
    } catch (e) {
      return ErrorNetwork(Exception(e.toString()));
    }
  }
}
