import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget DefaultNodeWidget(int? nodeId) {
  return Container(
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      child: Text(
        'Node ${nodeId}',
        style: TextStyle(color: Colors.black45),
      )
  );
}