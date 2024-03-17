import 'package:flutter/material.dart';

void ShowErrorDialog(BuildContext context, title, errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? "Error"),
        content: Text(errorMessage ?? "An error occurred. Please try again."),
      );
    },
  );
}
