import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/colors.dart';

abstract class AppDialog {
  static loadingDialog({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(20),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 30,
              children: [
                CircularProgressIndicator(color: primaryColor1),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static errorDialog({required BuildContext context, required String message}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text(
            "Error",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            MaterialButton(
              padding: EdgeInsets.all(10),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
