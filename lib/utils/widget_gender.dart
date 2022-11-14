import 'package:flutter/material.dart';

String select='';
showGenderInputDialog({
  required BuildContext context,
  required String title,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(String) onSubmit,

}) {


  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: choiceFeild(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(negativeButton),
          ),
          TextButton(
            onPressed: () {
              if (select.isEmpty) return;
              final value = select;
              onSubmit(value);
              Navigator.pop(context);

            },
            child: Text(positiveButton),
          ),
        ],
      ));
}
class choiceFeild extends StatefulWidget {



  @override
  State<choiceFeild> createState() => _choiceFeildState();
}

class _choiceFeildState extends State<choiceFeild> {
  List character=['Male','Female','Other'];


  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var value in character)
    Row(
      children: [
      Radio(
        value: value,
        groupValue: select,
        toggleable: true,
        activeColor: Colors.deepPurple,
        onChanged: (value) {
          setState(() {
            select=value;
          });
        },
      ),
      Text(
        value,
      ),
      ],

      ),
         ],
    );
  }
}

