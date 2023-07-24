library graphview;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphview/utils.dart';

import 'DefaultNodeWidget.dart';
import 'GraphView.dart';

typedef NodeWidgetBuilder = Widget Function(Node node);
enum DetailLevel { Low, Medium, High }

class NetworkGraphViewWrapper extends StatefulWidget {
  final Graph graph;
  final Widget Function(int?, DetailLevel) nodeWidget;
  DetailLevel detailLevel;

  NetworkGraphViewWrapper(
      {Key? key, required this.graph, this.nodeWidget = DefaultNodeWidget, this.detailLevel = DetailLevel.Medium})
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
                  ..color = Colors.grey
                  ..strokeWidth = 2
                  ..style = PaintingStyle.stroke,
                builder: (Node node) {
                  // I can decide what widget should be shown here based on the id
                  var a = node.key!.value as int?;
                  return widget.nodeWidget(a, widget.detailLevel);
                },
              ),
              measureRect: (Rect? r) {
                setState(() {
                  _boundingBox = r;

                  var graphWidth = _boundingBox?.width;
                  var graphHeight = _boundingBox?.height;
                  var graphLongestSide = _boundingBox?.longestSide;

                  var deviceWidth = MediaQuery.of(context).size.width;
                  var deviceHeight = MediaQuery.of(context).size.height;
                  var deviceLongestSide = MediaQuery.of(context).size.longestSide;

                  var heightOfViewPadding = MediaQuery.of(context).viewPadding.top;
                  var zoomFactor = 1.0;
                  var xOffset = 0.0;
                  var zoomBufferPercentage = 98;

                  zoomFactor = (zoomBufferPercentage / 100) * (deviceWidth / graphWidth!);
                  if (zoomFactor > 1.35) {
                    zoomFactor = 1.35;
                    xOffset = - (deviceWidth - graphWidth * 1.35) / 2;
                  }

                  viewTransformationController.value.setEntry(0, 0, zoomFactor);
                  viewTransformationController.value.setEntry(1, 1, zoomFactor);
                  viewTransformationController.value.setEntry(2, 2, zoomFactor);

                  viewTransformationController.value.setEntry(0, 3, -xOffset);

                  // Set detail level based on zoom factor
                  widget.detailLevel = getDetailLevelFromZoomFactor(zoomFactor);

                  print('Graph dimensions: ${graphWidth}W; ${graphHeight}H; ${graphLongestSide}LS');
                  print('Device dimensions: ${deviceWidth}W; ${deviceHeight}H; ${deviceLongestSide}LS');
                  print('View padding: $heightOfViewPadding');
                  print('Zoom factor: $zoomFactor');
                  print('xOffset: $xOffset');
                  print('Detail level: ${widget.detailLevel.toString()}');
                  // print('zoomFactor: $zoomFactor');
                });
              },
            ),
          ),
        ),
        Expanded(
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
                ..color = Colors.grey
                ..strokeWidth = 2
                ..style = PaintingStyle.stroke,
              builder: (Node node) {
                /*I can decide what widget should be shown here based on the id
                as well as the level of detail*/
                var a = node.key!.value as int?;
                return widget.nodeWidget(a, widget.detailLevel);
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
          ),
        ),
      ],
    );
  }

  DetailLevel getDetailLevelFromZoomFactor(double zoomFactor) {
    return zoomFactor >= 1.35 ? DetailLevel.High : (zoomFactor < 0.6 ? DetailLevel.Low : DetailLevel.Medium);
  }
}