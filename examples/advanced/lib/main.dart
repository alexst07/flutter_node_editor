import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

import 'nodes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NodeEditorController controller = NodeEditorController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    controller.addSelectListener((Connection conn) {
      debugPrint("ON SELECT inNode: ${conn.inNode}, inPort: ${conn.inPort}");
    });

    controller.addNode(
      componentNode('node_1_1'),
      NodePosition.afterLast,
    );
    controller.addNode(
      componentNode('node_1_2'),
      NodePosition.afterLast,
    );
    controller.addNode(
      componentNode('node_1_3'),
      NodePosition.afterLast,
    );
    controller.addNode(
      receiverNode('node_2_1', _focusNode2, _controller),
      NodePosition.afterLast,
    );
    controller.addNode(
      binaryNode('node_3_1'),
      NodePosition.afterLast,
    );
    controller.addNode(
      sinkNode('node_4_1'),
      NodePosition.afterLast,
    );
    super.initState();
  }

  void _addNewNode() {
    controller.addNode(
      componentNode('new_node'),
      NodePosition.afterLast,
    );
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('controller.toMap(): ${controller.toJson()}');
              },
              icon: Icon(Icons.abc))
        ],
      ),
      body: NodeEditor(
        focusNode: _focusNode,
        controller: controller,
        background: const GridBackground(
          backgroundColor: Color(0xfdfffd),
          lineColor: Color.fromARGB(255, 255, 255, 255),
          strokeWidth: 1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNode,
        child: Icon(Icons.add),
      ),
    );
  }
}