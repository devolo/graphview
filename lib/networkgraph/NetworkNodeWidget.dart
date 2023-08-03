/*MIT License

Copyright (c) 2020 Nabil Mosharraf

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'NetworkNodeConfiguration.dart';

class NetworkNode extends StatefulWidget {
  final String? name;
  final String icon;
  final String id;
  final String productName;
  final String type;
  final int uplinkSpeedInMbps;
  final int downlinkSpeedInMbps;
  final bool showSpeeds;
  final bool isConnectedToCurrentClient;
  final bool isOffline;
  final bool isEasyMeshController;
  final void Function(String deviceId) onDeviceTap;

  NetworkNode({
    required this.name,
    required this.icon,
    required this.id,
    required this.productName,
    required this.type,
    required this.uplinkSpeedInMbps,
    required this.downlinkSpeedInMbps,
    required this.showSpeeds,
    required this.isConnectedToCurrentClient,
    required this.isOffline,
    required this.isEasyMeshController,
    required this.onDeviceTap,
    Key? key
  }) : super(key: key);

  @override
  State<NetworkNode> createState() => _NetworkNodeState();
}

class _NetworkNodeState extends State<NetworkNode> {
  final double maxTextWidth = 84.0;
  final double circleSize = 96.0;
  final double iconSize = 24.0;
  final double internetIconSize = 48.0;
  final double speedIconSize = 12.0;

  final double textPadding = 8.0;

  final bool shouldShowClients = false;

  @override
  Widget build(BuildContext context) {
    final _showEasyMeshInformation = NetworkNodeConfiguration.showEasyMeshInformation;
    var easyMeshControllerCircleOffset = widget.showSpeeds ? 6 : 8;

    return widget.name!.isNotEmpty && widget.name == 'Internet' ?
    _getInternetWidget() : Column(
      children: [
        GestureDetector(
          onTap: () => widget.onDeviceTap(widget.id),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  width: circleSize,
                  height: circleSize*3,
                  padding: EdgeInsets.all(textPadding),
                  margin: EdgeInsets.symmetric(horizontal: 48.0),
                  decoration: BoxDecoration(
                      color: widget.showSpeeds ? NetworkNodeConfiguration.foregroundColor : NetworkNodeConfiguration.backgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: _getColorForDeviceState(widget.isOffline), width: 2)
                  ),
                  child: widget.showSpeeds ?
                  Column(
                    children: [
                      Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.download, size: 12.0, color: NetworkNodeConfiguration.backgroundColor),
                            Expanded(
                              child: Text(
                                '${widget.downlinkSpeedInMbps} Mbps',
                                textScaleFactor: 1.0,
                                style: NetworkNodeConfiguration.bodySmallTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]
                      ),
                      Container(
                        height: 2,
                        color: NetworkNodeConfiguration.backgroundColor,
                        margin: const EdgeInsets.symmetric(vertical: 1),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 12.0, color: NetworkNodeConfiguration.backgroundColor),
                            Expanded(
                              child: Text(
                                '${widget.uplinkSpeedInMbps} Mbps',
                                textScaleFactor: 1.0,
                                style: NetworkNodeConfiguration.bodySmallTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]
                      ),
                      Spacer(),
                    ],
                  ) : Container(
                    padding: EdgeInsets.all(4.0),
                    child:  SvgPicture.asset(
                      widget.icon,
                      color: _getColorForDeviceState(widget.isOffline),
                      fit: BoxFit.contain,
                    )
                  ),
              ),
              if(widget.isConnectedToCurrentClient)
                Positioned(
                  top: circleSize - 10,
                  left: 0,
                  right: -circleSize - 25,
                  child: Container(
                    width: iconSize * 1.5,
                    height: iconSize * 1.5,
                    decoration: BoxDecoration(
                        color: widget.showSpeeds ? NetworkNodeConfiguration.backgroundColor : NetworkNodeConfiguration.foregroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: NetworkNodeConfiguration.foregroundColor, width: 2)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: Icon(Icons.phone_iphone, size: speedIconSize * 1.5, color: widget.showSpeeds ? NetworkNodeConfiguration.foregroundColor : NetworkNodeConfiguration.backgroundColor),
                      ),
                    ),
                  ),
                ),
              if (widget.isEasyMeshController)
                Positioned(
                  top: circleSize + easyMeshControllerCircleOffset / 2,
                  right: (circleSize + easyMeshControllerCircleOffset) / 2,
                  child: Container(
                    width: circleSize - easyMeshControllerCircleOffset,
                    height: circleSize - easyMeshControllerCircleOffset,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: widget.showSpeeds ? NetworkNodeConfiguration.backgroundColor : (_getColorForDeviceState(widget.isOffline)), width: 2)
                    ),
                  ),
                ),
              Positioned(
                top: circleSize*2,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      widget.name!.isNotEmpty ? Text(
                          widget.name!,
                          style: NetworkNodeConfiguration.bodyTextStyle.copyWith(color: _getColorForDeviceState(widget.isOffline), backgroundColor: NetworkNodeConfiguration.backgroundColor),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: MediaQuery.of(context).textScaleFactor > NetworkNodeConfiguration.maxTextScaleFactor ? NetworkNodeConfiguration.maxTextScaleFactor : MediaQuery.of(context).textScaleFactor,
                      ) : SizedBox.shrink(),
                      Text(
                        widget.productName,
                        style: NetworkNodeConfiguration.bodySecondaryTextStyle.copyWith(color: _getColorForDeviceState(widget.isOffline), backgroundColor: NetworkNodeConfiguration.backgroundColor,),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor > NetworkNodeConfiguration.maxTextScaleFactor ? NetworkNodeConfiguration.maxTextScaleFactor : MediaQuery.of(context).textScaleFactor,
                      ),
                    ],
                  ),
                ),
              ),
              if (shouldShowClients)...[
                Positioned(
                  left: circleSize*2 - 5 - 2.5,
                  top: 0.5 * circleSize*3 - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                        border: Border.all(color: Colors.white, width: 1.0)
                    ),
                  ),
                ),
                Positioned(
                  left: circleSize - 5,
                  top: 0.5 * circleSize*3 - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                        border: Border.all(color: Colors.white, width: 1.0)
                    ),
                  ),
                ),
                Positioned(
                  right: circleSize * 1.5 - 5 - 2.5,
                  bottom: circleSize - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                        border: Border.all(color: Colors.white, width: 1.0)
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForDeviceState(bool isOffline) {
    return isOffline ? NetworkNodeConfiguration.offlineForegroundColor : NetworkNodeConfiguration.foregroundColor;
  }

  Widget _getInternetWidget() {
    return Container(
      width: circleSize,
      height: internetIconSize,
      padding: EdgeInsets.all(textPadding * 0.25),
      margin: EdgeInsets.symmetric(horizontal: 48.0),
      decoration: BoxDecoration(
          color: NetworkNodeConfiguration.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent, width: 0)
      ),
      child: Center(child: Icon(Icons.language_rounded, size: internetIconSize, color: _getColorForDeviceState(widget.isOffline),)),
    );
  }
}

Widget ClientNode() {
  return Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black,
    ),
  );
}
