import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UrlResWidget extends StatelessWidget {
  final res;
  final urllink;
  UrlResWidget({required this.res, required this.urllink});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' Resolution : $res'),
        Chip(
          label: Text(urllink),
          onDeleted: () {
            Clipboard.setData(
              ClipboardData(text: urllink),
            );
          },
          deleteIcon: Icon(Icons.copy),
        )
      ],
    );
  }
}
