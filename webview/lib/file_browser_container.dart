import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileBrowserContainer extends StatefulWidget {
  void Function() onPressed;

  FileBrowserContainer({required this.onPressed});

  @override
  _State createState() => _State();
}

class _State extends State<FileBrowserContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      height: 50 + 16,
      child: FractionallySizedBox(
        widthFactor: 0.3,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF0072B4)), foregroundColor: MaterialStateProperty.all(Colors.white)),
          child: Text('Upload file'),
          onPressed: widget.onPressed
        ),
      ),
    );
  }
}