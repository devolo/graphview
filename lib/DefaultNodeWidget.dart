import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NetworkGraphViewWrapper.dart';

class DefaultNodeWidget extends StatelessWidget {
  int? nodeId;
  DetailLevel detailLevel;

  DefaultNodeWidget({required this.nodeId, required this.detailLevel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(padding: EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Color(0xFF0072B4), // devolo blue
              shape: BoxShape.circle,
              // border: Border.all(color: Colors.white),
            ),
            child: Icon(
              Icons.rectangle_outlined,
              size: 32,
              color: Colors.white,
            )
        ),
        if (detailLevel != DetailLevel.Low)...[
          Positioned(
            bottom: -20,
            right: 10,
            child: Container(
              color: Colors.white,
              child: Text(
                'Device name',
                style: TextStyle(color: detailLevel == DetailLevel.Low ? Colors.transparent : Colors.black87, fontSize: 12.0),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 10,
            child: Container(
              color: Colors.white,
              child: Text(
                'Product type',
                style: TextStyle(color: detailLevel == DetailLevel.Low ? Colors.transparent : Colors.black87, fontSize: 12.0),
              ),
            ),
          )
        ],
        if (detailLevel == DetailLevel.High)...[
          Positioned(
            top: 0,
            right: 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green,),
            ),
          ),
          Positioned(
            top: 0,
            left: 5,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green,),
            ),
          ),
          Positioned(
            top: 35,
            left: -15,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green,),
            ),
          ),
          Positioned(
            top: 35,
            right: -15,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green,),
            ),
          ),
        ]
      ],
    );
  }
}