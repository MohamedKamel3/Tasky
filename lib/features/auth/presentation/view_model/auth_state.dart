part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

class UserLoading extends AuthState {}

class UserSuccess extends AuthState {}

class UserFailure extends AuthState {
  final String message;
  UserFailure({required this.message});
}
