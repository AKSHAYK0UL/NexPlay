import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditInputWidget extends StatelessWidget {
  final oldValue;
  EditInputWidget(this.oldValue);
  List Images = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Chip(
          elevation: 5,
          label: Text(oldValue),
          onDeleted: () {
            Clipboard.setData(ClipboardData(text: oldValue));
          },
          deleteIcon: Icon(Icons.copy),
        )
      ],
    );
  }
}
