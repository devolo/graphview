import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphview/GraphView.dart';
import 'package:graphview/NetworkGraphViewWrapper.dart';
import 'package:graphview/networkgraph/NetworkNodeConfiguration.dart';
import 'package:graphview/networkgraph/NetworkNodeWidget.dart';

class NetworkGraphPage extends StatefulWidget {
  @override
  _NetworkGraphPageState createState() => _NetworkGraphPageState();
}

class _NetworkGraphPageState extends State<NetworkGraphPage> {
  final Graph graph = Graph();
  List<NetworkNode> networkNodes = [];

  @override
  void initState() {
    readJSON();
    super.initState();
  }

  Future<bool> readJSON() async {
    final String response = await rootBundle.loadString('sample_network_configurations/sample_network_configuration_1.json');
    final networkConfig = await json.decode(response);
    
    List<Node> nodes = [];
    // Add nodes
    networkConfig.forEach((_node) { nodes.add(Node.Id(_node['id'])); });
    
    // Add edges
    networkConfig.forEach((_node) { 
      _node['connected_to'].forEach((_nodeId) {
        graph.addEdge(nodes[_node['id']-1], nodes[_nodeId-1]);
      });
    });
    
    // Add NetworkNode widget
    networkConfig.forEach((_node) {
      networkNodes.add(NetworkNode(
          name: _node['user_name'],
          icon: 'network_overview/${getSVGAssetFromProductName(_node['product_name'])}.svg',
          id: _node['id'].toString(),
          productName: _node['product_name'],
          type: 'unused',
          uplinkSpeedInMbps: int.parse(_node['upload_speed'] ?? '0'),
          downlinkSpeedInMbps: int.parse(_node['download_speed'] ?? '0'),
          showSpeeds: _node['show_speed'] ?? false,
          isConnectedToCurrentClient: _node['is_connected_to_client'] ?? false,
          isOffline: !_node['live'] ?? true,
          isEasyMeshController: _node['is_easymesh_controller'] ?? false,
          onDeviceTap: (node) {}
      ));
    });
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    NetworkGraphConfiguration.backgroundColor = Colors.grey.shade200;
    NetworkGraphConfiguration.foregroundColor = Colors.purple;

    NetworkNodeConfiguration.foregroundColor = NetworkGraphConfiguration.foregroundColor;
    NetworkNodeConfiguration.backgroundColor = NetworkGraphConfiguration.backgroundColor;
    NetworkNodeConfiguration.offlineForegroundColor = NetworkGraphConfiguration.foregroundColor.withAlpha(128);

    return Scaffold(
        body: FutureBuilder<bool>(
          future: readJSON(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return NetworkGraphViewWrapper(graph: graph, networkNodes: networkNodes,);
            } else {
              return Center(child: Text('Fetching data ...'),);
            }
          },
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
