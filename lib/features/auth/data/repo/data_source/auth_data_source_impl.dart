import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/auth/data/firebase/auth_api.dart';
import 'package:to_do_app/features/auth/data/firebase/auth_firebase.dart';
import 'package:to_do_app/features/auth/data/models/user_model.dart';
import 'package:to_do_app/features/auth/data/repo/data_source/auth_data_source.dart';

class AuthEmailAndPassDataSourceImpl implements AuthEmailAndPassDataSource {
  AuthEmailAndPassDataSourceImpl(this._authAPI);
  AuthAPI _authAPI;
  @override
  Future<ResultNetwork<UserCredential>> login(
    String email,
    String password,
  ) => _authAPI.login(email, password);

  @override
  Future<ResultNetwork<UserCredential>> signup(
    String email,
    String password,
  ) => _authAPI.signup(email, password);

  @override
  Future<ResultNetwork> addUser(String email, String name) =>
      AuthFirebase.addUser(
        UserModel(name: name, email: email),
      );
}

AuthEmailAndPassDataSource injectableAuthEmailAndPassDataSource() =>
    AuthEmailAndPassDataSourceImpl(AuthAPI.instance);
