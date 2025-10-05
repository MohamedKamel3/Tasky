import 'package:to_do_app/core/utils/result_network.dart';

abstract class AuthRepisitory {
  Future<ResultNetwork> login(String email, String password);
  Future<ResultNetwork> signup(String email, String password);
  Future<ResultNetwork> addUser(String email, String name);
}
