import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

import 'Blueprint/blueprint.dart';
import 'joystick/flutter_joystick.dart';
import 'dart:io' show Platform;

//hardcoded
String bp =
    '{"nodes":[{"name":"adder_1720696047881054","type":"adder","value":70.0,"pos":"Offset(217.1, 14.7)","ports":{"adder_inPort_1720696047881718":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696047881719":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696047881720":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"int_1720695994049152","type":"integer","value":"50","pos":"Offset(9.2, 18.6)","ports":{"int_outPort_1720695994054281":{"type":"output","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696047881054","type":"adder","value":70.0,"pos":"Offset(217.1, 14.7)","ports":{"adder_inPort_1720696047881718":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696047881719":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696047881720":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"int_1720696012552220","type":"integer","value":"20","pos":"Offset(8.9, 68.2)","ports":{"int_outPort_1720696012552244":{"type":"output","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696066246650","type":"adder","value":90.0,"pos":"Offset(22.3, 197.7)","ports":{"adder_inPort_1720696066246671":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696066246673":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696066246675":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696047881054","type":"adder","value":70.0,"pos":"Offset(217.1, 14.7)","ports":{"adder_inPort_1720696047881718":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696047881719":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696047881720":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696066246650","type":"adder","value":90.0,"pos":"Offset(22.3, 197.7)","ports":{"adder_inPort_1720696066246671":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696066246673":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696066246675":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"int_1720696012552220","type":"integer","value":"20","pos":"Offset(8.9, 68.2)","ports":{"int_outPort_1720696012552244":{"type":"output","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696129323395","type":"adder","value":160.0,"pos":"Offset(220.4, 240.0)","ports":{"adder_inPort_1720696129323414":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696129323416":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696129323417":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696066246650","type":"adder","value":90.0,"pos":"Offset(22.3, 197.7)","ports":{"adder_inPort_1720696066246671":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696066246673":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696066246675":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696129323395","type":"adder","value":160.0,"pos":"Offset(220.4, 240.0)","ports":{"adder_inPort_1720696129323414":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696129323416":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696129323417":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696047881054","type":"adder","value":70.0,"pos":"Offset(217.1, 14.7)","ports":{"adder_inPort_1720696047881718":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696047881719":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696047881720":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"print_1720696147104722","type":"print","value":"160.0","pos":"Offset(20.7, 360.4)","ports":{"print_inPort_1720696147104758":{"type":"input","multiConnections":false,"maxConnections":null}}},{"name":"adder_1720696129323395","type":"adder","value":160.0,"pos":"Offset(220.4, 240.0)","ports":{"adder_inPort_1720696129323414":{"type":"input","multiConnections":false,"maxConnections":null},"adder_outPort_1720696129323416":{"type":"output","multiConnections":false,"maxConnections":null},"adder_inPort2_1720696129323417":{"type":"input","multiConnections":false,"maxConnections":null}}}],"connections":[{"outPort":"int_outPort_1720695994054281","inPort":"adder_inPort_1720696047881718"},{"outPort":"int_outPort_1720696012552244","inPort":"adder_inPort2_1720696047881720"},{"outPort":"adder_outPort_1720696047881719","inPort":"adder_inPort_1720696066246671"},{"outPort":"int_outPort_1720696012552244","inPort":"adder_inPort2_1720696066246675"},{"outPort":"adder_outPort_1720696066246673","inPort":"adder_inPort_1720696129323414"},{"outPort":"adder_outPort_1720696047881719","inPort":"adder_inPort2_1720696129323417"},{"outPort":"adder_outPort_1720696129323416","inPort":"print_inPort_1720696147104758"}]}';
//
//start from here
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chains',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BlueprintController controller = BlueprintController();
  final JoystickController stickCtrl = JoystickController();

  final FocusNode _focusNode = FocusNode();

  bool assetsLoaded = false;

  @override
  void initState() {
    controller.joystick = stickCtrl;
    controller.context = context;
    controller.needUpdate.addListener(() {
      setState(() {});
    });
    super.initState();
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
          actions: [
            //mount asset
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  assetsLoaded ? const Text("Eject") : const Text("Mount"),
                  assetsLoaded
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.eject_rounded))
                      : IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.sd_storage_rounded))
                ],
              ),
            ),
            Expanded(child: Container()),
            // select all
            IconButton(
                onPressed: () {
                  controller.selectAll();
                },
                icon: const Icon(Icons.select_all_rounded)),
            //mapping
            IconButton(
                onPressed: () {
                  var tree = controller.saveBlueprint();
                  String jsonTree = jsonEncode(tree);
                  debugPrint(jsonTree);
                  // like a tree
                },
                icon: const Icon(Icons.map_rounded)),
            //sideload
            IconButton(
                onPressed: () {
                  controller.cleanBlueprint();
                  controller.loadBlueprint(bp);
                },
                icon: const Icon(Icons.upload_file_rounded)),
            //run
            IconButton(
                onPressed: () {
                  debugPrint("Running nodes!");
                  controller.runNodes();
                },
                icon: const Icon(Icons.play_circle_outline_rounded))
          ],
        ),
        body: NodeEditor(
          focusNode: _focusNode,
          controller: controller,
          background: const GridBackground(),
          infiniteCanvasSize: 5000,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !(Platform.isWindows || Platform.isMacOS)
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: Joystick(
                        stick: const JoystickStick(
                          decoration: null,
                        ),
                        controller: stickCtrl,
                        listener: (details) {
                          for (var name in controller.selecteds) {
                            controller.moveNodePosition(
                                name, Offset(details.x * 12, details.y * 12));
                          }
                        },
                      ),
                    )
                  : Container(),
              ValueListenableBuilder(
                valueListenable: controller.selectedAny,
                builder: (context, selectedAny, child) {
                  return selectedAny
                      ? FloatingActionButton(
                          onPressed: () {
                            controller.deleteSelectedNodes();
                          },
                          child: const Icon(Icons.delete_outline_rounded),
                        )
                      : Container();
                },
              ),
            ],
          ),
        ));
  }
}
