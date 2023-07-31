/*MIT License

Copyright (c) 2020 Nabil Mosharraf

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/
library graphview;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphview/utils.dart';

import 'GraphView.dart';
import 'networkgraph/NetworkNodeWidget.dart';

typedef NodeWidgetBuilder = Widget Function(Node node);
enum DetailLevel { Low, Medium, High }

class NetworkGraphViewWrapper extends StatefulWidget {
  final Graph graph;
  final List<NetworkNode> networkNodes;
  DetailLevel detailLevel;

  NetworkGraphViewWrapper(
      {Key? key, required this.graph, this.detailLevel = DetailLevel.Medium, required this.networkNodes})
      : super(key: key);

  @override
  _NetworkGraphViewWrapperState createState() => _NetworkGraphViewWrapperState();
}

class _NetworkGraphViewWrapperState extends State<NetworkGraphViewWrapper> {
  NetworkGraphConfiguration builder = NetworkGraphConfiguration()
    ..bendPointShape = MaxCurvedBendPointShape();

  final viewTransformationController = TransformationController();

  Rect? _boundingBox;
  GlobalKey? _key;


  @override
  Widget build (BuildContext context) {
    if (widget.graph.nodes.isEmpty) { return Container(); }
    else {
      return Column(
        children: [
          Visibility(
            visible: false,
            maintainState: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MeasureWidget(
                key: _key,
                child: GraphView(
                  animated: false,
                  graph: widget.graph,
                  algorithm: NetworkGraphAlgorithm(builder),
                  paint: Paint()
                    ..color = NetworkGraphConfiguration.foregroundColor
                    ..strokeWidth = 2
                    ..style = PaintingStyle.stroke,
                  builder: (Node node) {
                    var index = widget.graph.nodes.indexOf(node);
                    return widget.networkNodes.elementAt(index);
                  },
                ),
                measureRect: (Rect? r) {
                  setState(() {
                    _boundingBox = r;

                    var graphWidth = _boundingBox?.width;
                    var graphHeight = _boundingBox?.height;

                    var deviceWidth = MediaQuery.of(context).size.width;
                    var deviceHeight = MediaQuery.of(context).size.height;

                    var heightOfViewPadding = NetworkGraphConfiguration.heightOffset;
                    var zoomPaddingOffset = NetworkGraphConfiguration.widthOffset;

                    var verticalScaleFactor = (deviceHeight - heightOfViewPadding) / graphHeight!;
                    var horizontalScaleFactor = (deviceWidth - zoomPaddingOffset) / graphWidth!;
                    var scaleFactor = min(verticalScaleFactor, horizontalScaleFactor);

                    var zoomFactor = scaleFactor > 1.35 ? 1.35 : scaleFactor;
                    var xOffset = -(deviceWidth - zoomPaddingOffset - graphWidth*zoomFactor) / 2;

                    viewTransformationController.value.setEntry(0, 0, zoomFactor);
                    viewTransformationController.value.setEntry(1, 1, zoomFactor);
                    viewTransformationController.value.setEntry(2, 2, zoomFactor);

                    viewTransformationController.value.setEntry(0, 3, -xOffset);

                    // Set detail level based on zoom factor
                    widget.detailLevel = getDetailLevelFromZoomFactor(zoomFactor);

                    print('Graph dimensions: ${graphWidth}W; ${graphHeight}H');
                    print('Device dimensions: ${deviceWidth}W; ${deviceHeight}H');
                    print('View padding: $heightOfViewPadding');
                    print('Zoom factor: $zoomFactor');
                    print('xOffset: $xOffset');
                    print('Detail level: ${widget.detailLevel.toString()}');
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: NetworkGraphConfiguration.backgroundColor,
              child: InteractiveViewer(
                trackpadScrollCausesScale: true,
                transformationController: viewTransformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.01,
                maxScale: 3.0,
                child: GraphView(
                  graph: widget.graph,
                  algorithm: NetworkGraphAlgorithm(builder),
                  paint: Paint()
                    ..color = NetworkGraphConfiguration.foregroundColor
                    ..strokeWidth = 2
                    ..style = PaintingStyle.stroke,
                  builder: (Node node) {
                    var index = widget.graph.nodes.indexOf(node);
                    return widget.networkNodes.elementAt(index);
                  },
                ),
                onInteractionEnd: (ScaleEndDetails details) {
                  // Details.scale can give values below 0.5 or above 2.0 and resets to 1
                  // Use the Controller Matrix4 to get the correct scale.
                  var zoomFactor = viewTransformationController.value.getMaxScaleOnAxis();
                  setState(() {
                    widget.detailLevel = getDetailLevelFromZoomFactor(zoomFactor);
                  });
                },
              )
            ),
          ),
        ],
      );
    }
  }

  DetailLevel getDetailLevelFromZoomFactor(double zoomFactor) {
    return zoomFactor >= 1.35 ? DetailLevel.High : (zoomFactor < 0.75 ? DetailLevel.Low : DetailLevel.Medium);
  }
}