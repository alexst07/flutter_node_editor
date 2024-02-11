import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

NodeWidgetBase componentNode(String name) {
  return DefaultNode(
    name: name,
    typeName: 'node_1',
    backgroundColor: Colors.black87,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Output 1'),
            OutPortWidget(
              name: 'PortOut1',
              icon: Icon(
                Icons.play_arrow_outlined,
                color: Colors.red,
                size: 24,
              ),
              iconConnected: Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 24,
              ),
              multiConnections: false,
              connectionTheme:
                  ConnectionTheme(color: Colors.red, strokeWidth: 2),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Output 2'),
            SizedBox(
              width: 24,
              height: 24,
              child: OutPortWidget(
                name: 'PortOut2',
                icon: Icon(
                  Icons.circle_outlined,
                  color: Colors.yellowAccent,
                  size: 20,
                ),
                iconConnected: Icon(
                  Icons.circle,
                  color: Colors.yellowAccent,
                  size: 20,
                ),
                multiConnections: false,
                connectionTheme:
                    ConnectionTheme(color: Colors.yellowAccent, strokeWidth: 2),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CheckBoxProperty(name: 'check_port'),
            Text('Output 3'),
            OutPortWidget(
              name: 'PortOut3',
              icon: Icon(
                Icons.play_arrow_outlined,
                color: Colors.green,
                size: 24,
              ),
              iconConnected: Icon(
                Icons.play_arrow,
                color: Colors.green,
                size: 24,
              ),
              multiConnections: false,
              connectionTheme:
                  ConnectionTheme(color: Colors.green, strokeWidth: 2),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 30,
                padding: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.white10, // Container color
                  borderRadius:
                      BorderRadius.all(Radius.circular(10)), // Rounded corners
                ),
                child: Builder(builder: (context) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.black,
                    ),
                    child: DropdownMenuProperty<int>(
                      underline: SizedBox(),
                      name: 'select',
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          child: Text(
                            'Item1',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Item2',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Item3',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 2,
                        ),
                      ],
                      onChanged: (int? v) {},
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('check 1:'),
            CheckBoxProperty(name: 'check_prop1'),
          ],
        ),
      ],
    ),
    title: Text('Components'),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient: LinearGradient(
        colors: [Color.fromRGBO(0, 23, 135, 1.0), Colors.lightBlue]),
    icon: Icon(
      Icons.rectangle_outlined,
      color: Colors.white,
    ),
    width: 200,
  );
}

NodeWidgetBase receiverNode(
    String name, FocusNode focusNode, TextEditingController controller) {
  return DefaultNode(
    name: name,
    typeName: 'node_2',
    backgroundColor: Colors.black87,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InPortWidget(
                  name: 'PortIn1',
                  onConnect: (String name, String port) => true,
                  icon: Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  iconConnected: Icon(
                    Icons.play_arrow,
                    color: Colors.red,
                    size: 24,
                  ),
                  multiConnections: false,
                  connectionTheme:
                      ConnectionTheme(color: Colors.red, strokeWidth: 2),
                ),
                Text('Input 1'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Output 3'),
                OutPortWidget(
                  name: 'PortOut3',
                  icon: Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.blue,
                    size: 24,
                  ),
                  iconConnected: Icon(
                    Icons.play_arrow,
                    color: Colors.blue,
                    size: 24,
                  ),
                  multiConnections: false,
                  connectionTheme:
                      ConnectionTheme(color: Colors.blue, strokeWidth: 2),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InPortWidget(
              name: 'PortIn2',
              onConnect: (String name, String port) => true,
              icon: Icon(
                Icons.play_arrow_outlined,
                color: Colors.red,
                size: 24,
              ),
              iconConnected: Icon(
                Icons.play_arrow,
                color: Colors.red,
                size: 24,
              ),
              multiConnections: false,
              connectionTheme:
                  ConnectionTheme(color: Colors.red, strokeWidth: 2),
            ),
            Text('Input 2'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Value: '),
            SizedBox(
              width: 50,
              height: 25,
              child: TextEditProperty(
                name: 'text_prop',
                focusNode: focusNode,
                controller: controller,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
          ],
        ),
        Text('end')
      ],
    ),
    title: Text('Receiver'),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient: LinearGradient(
        colors: [Color.fromRGBO(12, 100, 6, 1.0), Colors.greenAccent]),
    icon: Icon(
      Icons.receipt_rounded,
      color: Colors.white,
    ),
    width: 200,
  );
}

NodeWidgetBase binaryNode(String name) {
  return BinaryOperationNode(
    name: name,
    typeName: 'node_3',
    backgroundColor: Colors.blue.shade800,
    radius: 10,
    width: 200,
    inputPort1: InPortWidget(
      name: 'PortIn1',
      onConnect: (String name, String port) => true,
      icon: Icon(
        Icons.circle_outlined,
        color: Colors.yellowAccent,
        size: 20,
      ),
      iconConnected: Icon(
        Icons.circle,
        color: Colors.yellowAccent,
        size: 20,
      ),
      multiConnections: false,
      connectionTheme:
          ConnectionTheme(color: Colors.yellowAccent, strokeWidth: 2),
    ),
    inputPort2: InPortWidget(
      name: 'PortIn2',
      onConnect: (String name, String port) => true,
      icon: Icon(
        Icons.circle_outlined,
        color: Colors.yellowAccent,
        size: 20,
      ),
      iconConnected: Icon(
        Icons.circle,
        color: Colors.yellowAccent,
        size: 20,
      ),
      multiConnections: false,
      connectionTheme:
          ConnectionTheme(color: Colors.yellowAccent, strokeWidth: 2),
    ),
    outputPort: OutPortWidget(
      name: 'PortOut1',
      icon: Icon(
        Icons.pause_circle_outline,
        color: Colors.deepOrange,
        size: 24,
      ),
      iconConnected: Icon(
        Icons.pause_circle,
        color: Colors.deepOrange,
        size: 24,
      ),
      multiConnections: false,
      connectionTheme:
          ConnectionTheme(color: Colors.deepOrange, strokeWidth: 2),
    ),
    label: Icon(Icons.safety_divider),
  );
}

NodeWidgetBase sinkNode(String name) {
  return DefaultNode(
    name: name,
    typeName: 'node_4',
    backgroundColor: Colors.black87,
    radius: 10,
    selectedBorder: Border.all(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InPortWidget(
                    name: 'PortIn1',
                    onConnect: (String name, String port) => true,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    iconConnected: Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    multiConnections: false,
                    connectionTheme: ConnectionTheme(
                        color: Colors.blueAccent, strokeWidth: 2),
                  ),
                  Text('Input 2'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
    title: Text(
      'Sinker',
      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
    ),
    iconTileSpacing: 5,
    titleBarPadding: const EdgeInsets.all(4.0),
    titleBarGradient:
        LinearGradient(colors: [Colors.yellowAccent, Colors.yellow]),
    icon: Icon(
      Icons.calculate_rounded,
      color: Colors.deepOrange,
    ),
    width: 200,
  );
}
