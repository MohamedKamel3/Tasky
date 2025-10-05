import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:to_do_app/core/utils/result_network.dart';
import 'package:to_do_app/features/auth/data/repo/repository/auth_repisitory.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepisitory) : super(AuthInitial());
  AuthRepisitory authRepisitory;

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    var result = await authRepisitory.signup(email, password);
    switch (result) {
      case SuccessNetwork():
        emit(AuthSuccess());
      case ErrorNetwork():
        emit(AuthFailure(message: result.exception.toString()));
    }
  }

  Future<void> addUser(String email, String name) async {
    emit(UserLoading());
    var result = await authRepisitory.addUser(email, name);
    switch (result) {
      case SuccessNetwork():
        emit(UserSuccess());
      case ErrorNetwork():
        emit(UserFailure(message: result.exception.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    var result = await authRepisitory.login(email, password);
    switch (result) {
      case SuccessNetwork():
        emit(AuthSuccess());
      case ErrorNetwork():
        emit(AuthFailure(message: result.exception.toString()));
    }
  }
}
