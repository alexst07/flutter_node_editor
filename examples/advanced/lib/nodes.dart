import 'package:flutter/material.dart';
import 'package:node_editor/node_editor.dart';

NodeWidgetBase componentNode(String name) {
  return DefaultNode(
    name: name,
    typeName: 'node_1',
    backgroundColor: Colors.black87,
    radius: 10,
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
