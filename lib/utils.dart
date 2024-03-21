import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, title, errorMessage) {
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

class HunterClassParsers {
  Map<String, String> classParser(List<Map<String, dynamic>> list) {
    var result = <String, String>{};
    for (var item in list) {
      result[item['name']] = item['id'];
    }
    return result;
  }
}
