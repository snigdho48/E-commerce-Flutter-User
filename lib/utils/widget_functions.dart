import 'package:flutter/material.dart';

showSingleTextFieldInputDialog({
  required BuildContext context,
  required String title,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final txtController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: txtController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter $title',
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(negativeButton),
              ),
              TextButton(
                onPressed: () {
                  if (txtController.text.isEmpty) return;
                  final value = txtController.text;
                  Navigator.pop(context);
                  onSubmit(value);
                },
                child: Text(positiveButton),
              ),
            ],
          ));
}
