import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MeasureWidget extends StatefulWidget {
  final Widget? child;
  final ValueSetter<Rect?>? measureRect;
  final BoxConstraints? boxConstraints;

  const MeasureWidget({
    Key? key,
    this.child,
    this.measureRect,
    this.boxConstraints,
  }) : super(key: key);

  @override
  MeasureWidgetState createState() => MeasureWidgetState();
}

class MeasureWidgetState extends State<MeasureWidget> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(afterFirstLayout);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: Center(
        child: Container(
          key: key,
          constraints: widget.boxConstraints,
          child: widget.child,
        ),
      ),
    );
  }

  void afterFirstLayout(Duration context) {
    Rect? rect = Utils.findGlobalRect(key);
    widget.measureRect?.call(rect);
  }
}

class Utils {
  static Rect? findGlobalRect(GlobalKey key) {
    RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) {
      return null;
    }

    if (renderObject is RenderBox) {
      Offset globalOffset = renderObject.localToGlobal(Offset.zero);

      var bounds = renderObject.paintBounds;
      bounds = bounds.translate(globalOffset.dx, globalOffset.dy);
      return bounds;
    } else {
      var bounds = renderObject.paintBounds;
      final translation = renderObject.getTransformTo(null).getTranslation();
      bounds = bounds.translate(translation.x, translation.y);
      return bounds;
    }
  }

  static Future<Rect> measureWidgetRect({
    required BuildContext context,
    required Widget widget,
    required BoxConstraints boxConstraints,
  }) {
    Completer<Rect> completer = Completer();
    OverlayEntry? entry;
    entry = OverlayEntry(builder: (BuildContext ctx) {
      return Material(
        child: MeasureWidget(
          child: widget,
          boxConstraints: boxConstraints,
          measureRect: (rect) {
            entry!.remove();
            completer.complete(rect);
          },
        ),
      );
    });

    Overlay.of(context)!.insert(entry);
    return completer.future;
  }
}