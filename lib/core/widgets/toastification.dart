import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class AppToastification {
  static successToastification({
    required String title,
    required String description,
    required BuildContext context,
  }) => toastification.show(
    context: context,
    title: Text(title, style: const TextStyle(fontSize: 20)),
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    description: Text(
      description,
      style: const TextStyle(fontSize: 16),
    ),
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(Icons.check),
    showIcon: true,
    primaryColor: Colors.green,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: true,
    dragToClose: true,
  );

  static errorToastification({
    required String title,
    required String description,
    required BuildContext context,
  }) => toastification.show(
    context: context,
    title: Text(title),
    type: ToastificationType.error,
    style: ToastificationStyle.flatColored,
    description: Text(description),
    autoCloseDuration: const Duration(seconds: 5),
    icon: const Icon(Icons.error),
    showIcon: true,
    primaryColor: Colors.red,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    showProgressBar: true,
    dragToClose: true,
  );
}
