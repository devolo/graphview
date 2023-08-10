import 'dart:convert';
import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphview/GraphView.dart';
import 'package:graphview/NetworkGraphViewWrapper.dart';
import 'package:graphview/networkgraph/NetworkNodeConfiguration.dart';
import 'package:graphview/networkgraph/NetworkNodeWidget.dart';
import 'package:webview/shared_prefs.dart';

import 'file_browser_container.dart';

class NetworkGraphPage extends StatefulWidget {
  @override
  _NetworkGraphPageState createState() => _NetworkGraphPageState();
}

class _NetworkGraphPageState extends State<NetworkGraphPage> {
  Graph graph = Graph();
  List<NetworkNodeObj> networkNodes = [];

  @override
  void initState() {
    readJSON();
    super.initState();
  }

  Future<bool> readJSON({dynamic jsonContents}) async {
    dynamic networkConfig;

    if (jsonContents != null) {
      networkConfig = jsonContents;
      SharedPrefs().networkConfig = json.encode(networkConfig);
    } else {
      if (SharedPrefs().networkConfig.isNotEmpty) {
        networkConfig = json.decode(SharedPrefs().networkConfig);
      } else {
        // Or do something else
        final response = await rootBundle.loadString('assets/sample_network_configurations/sample_network_configuration_1.json');
        networkConfig = await json.decode(response);
      }
    }

    var nodes = <Node>[];
    graph = Graph();
    networkNodes = [];

    // Add nodes
    networkConfig.forEach((_node) { nodes.add(Node.Id(_node['id'])); });

    // Add edges
    networkConfig.forEach((_node) {
      _node['connected_to'].forEach((_nodeId) {
        setState(() {
          graph.addEdge(nodes[int.parse(_node['id'].toString())-1], nodes[int.parse(_nodeId.toString())-1]);
        });
      });
    });

    // Add NetworkNode widget
    networkConfig.forEach((_node) {
      setState(() {
        networkNodes.add(NetworkNodeObj(
          name: _node['user_name'].toString(),
          icon: 'assets/network_overview/${getSVGAssetFromProductName(_node['product_name'].toString())}.svg',
          id: _node['id'].toString(),
          productName: _node['product_name'].toString(),
          type: 'unused',
          uplinkSpeedInMbps: int.tryParse(_node['upload_speed'].toString()) ?? 0,
          downlinkSpeedInMbps: int.tryParse(_node['download_speed'].toString()) ?? 0,
          showSpeeds: _node['show_speed'] ?? false,
          isConnectedToCurrentClient: _node['is_connected_to_client'] ?? false,
          isOffline: !_node['live'] ?? true,
          isEasyMeshController: _node['is_easymesh_controller'] ?? false,
          onDeviceTap: (node) {},
        ));
      });
    });
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    NetworkGraphConfiguration.backgroundColor = Color(0xFF0072B4);
    NetworkGraphConfiguration.foregroundColor = Colors.white;
    NetworkGraphConfiguration.heightOffset = 100;

    NetworkNodeConfiguration.foregroundColor = NetworkGraphConfiguration.foregroundColor;
    NetworkNodeConfiguration.backgroundColor = NetworkGraphConfiguration.backgroundColor;
    NetworkNodeConfiguration.offlineForegroundColor = NetworkGraphConfiguration.foregroundColor.withAlpha(128);

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: NetworkGraphViewWrapper(graph: graph, networkNodes: networkNodes,)),
          FileBrowserContainer(
            onPressed: () async {
              var uploadConfig = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                  dialogTitle: 'Select a network configuration',
                  allowMultiple: false
              );

              if (uploadConfig != null && uploadConfig.files.isNotEmpty) {
                final fileBytes = uploadConfig.files.first.bytes!;
                dynamic jsonContents = json.decode(utf8.decode(await fileBytes.toList()));
                await readJSON(jsonContents: jsonContents);
              }
            },
          ),
        ],
      )
    );
  }

  String getSVGAssetFromProductName(String productName) {
    if (productName.toLowerCase().contains('lan')) {
      if (productName.toLowerCase().contains('mini')) {
        return 'devolo_adapter_lan_mini';
      } else {
        return 'devolo_adapter_lan';
      }
    } else if (productName.toLowerCase().contains('repeater')) {
      return 'devolo_adapter_repeater';
    } else if (productName.toLowerCase().contains('wifi')) {
      if (productName.toLowerCase().contains('mini')) {
        return 'devolo_adapter_wifi_mini';
      } else {
        return 'devolo_adapter_wifi';
      }
    } else if (productName.toLowerCase().contains('router')) {
      return 'Router';
    }

    return 'devolo_generic_lan';
  }
}
