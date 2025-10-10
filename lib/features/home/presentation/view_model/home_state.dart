part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {}

class HomeError extends HomeState {}

class AddSuccess extends HomeState {}

class AddError extends HomeState {}

class UpdateSuccess extends HomeState {}

class UpdateError extends HomeState {}

class DeleteSuccess extends HomeState {}

class DeleteError extends HomeState {}

class AddRecoverySuccess extends HomeState {}

class AddRecoveryError extends HomeState {}

class DeleteRecoverySuccess extends HomeState {}

class DeleteRecoveryError extends HomeState {}

class GetRecoverySuccess extends HomeState {}

class GetRecoveryError extends HomeState {}

class GetRecoveryLoading extends HomeState {}
