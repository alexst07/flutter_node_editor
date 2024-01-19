import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

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
  NodeEditorController controller = NodeEditorController();
  @override
  void initState() {
    controller.addSelectListener((Connection conn) {
      debugPrint("ON SELECT inNode: ${conn.inNode}, inPort: ${conn.inPort}");
    });
    DefaultNode node = DefaultNode(
      name: 'test_1',
      typeName: 'test',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('teste'),
              OutPortWidget(
                name: 'PortOut',
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.red,
                ),
                multiConnections: false,
                connectionTheme:
                    ConnectionTheme(color: Colors.red, strokeWidth: 1),
              ),
            ],
          ),
          Row(
            children: [CheckBoxProperty(name: 'check'), Text('my check')],
          ),
          Row(
            children: [
              Flexible(
                child: DropdownMenuProperty<int>(
                  name: 'select',
                  items: const [
                    DropdownMenuItem(
                      child: Text('Teste1'),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Teste2'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Teste3'),
                      value: 2,
                    ),
                  ],
                  onChanged: (int? v) {},
                ),
              ),
            ],
          )
        ],
      ),
      title: Text('teste'),
      icon: Icon(Icons.add),
    );

    DefaultNode node2 = DefaultNode(
      name: 'test_i_1',
      typeName: 'test_i',
      initPosition: NodePosition.afterLast,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InPortWidget(
            name: 'PortIn',
            onConnect: (String nodeName, String portName) => true,
            icon: Icon(Icons.circle),
            multiConnections: false,
          )
        ],
      ),
      title: Text('teste'),
      icon: Icon(Icons.add),
    );
    controller.addNode(node);
    controller.addNode(node2);
    super.initState();
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
        controller: controller,
        background: const GridBackground(),
      ),
    );
  }
}
