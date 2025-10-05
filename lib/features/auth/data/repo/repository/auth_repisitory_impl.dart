import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/auth/data/repo/data_source/auth_data_source.dart';
import 'package:to_do_app/features/auth/data/repo/repository/auth_repisitory.dart';

class AuthRepisitoryImpl implements AuthRepisitory {
  AuthRepisitoryImpl(this.authEmailAndPassDataSource);
  AuthEmailAndPassDataSource authEmailAndPassDataSource;

  @override
  Future<ResultNetwork> login(String email, String password) =>
      authEmailAndPassDataSource.login(email, password);

  @override
  Future<ResultNetwork> signup(String email, String password) =>
      authEmailAndPassDataSource.signup(email, password);

  @override
  Future<ResultNetwork> addUser(String email, String name) =>
      authEmailAndPassDataSource.addUser(email, name);
}

AuthRepisitory injectableAuthRepisitory(
  AuthEmailAndPassDataSource dataSource,
) => AuthRepisitoryImpl(dataSource);
