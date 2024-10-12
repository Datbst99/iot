import 'package:flutter/material.dart';

import 'button.dart';

void showErrorDiaLog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          MyElevatedButton(
            borderRadius: BorderRadius.circular(20),
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Thoát',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    },
  );
}
