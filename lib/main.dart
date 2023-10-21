import 'package:custom_drawer/custom_drawerr.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

void main() {
  log("main");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("logging started");
    return const MaterialApp(
      home: DraggableStackPage(),
    );
  }
}

class DraggableStackPage extends StatefulWidget {
  const DraggableStackPage({super.key});

  @override
  DraggableStackPageState createState() => DraggableStackPageState();
}

class DraggableStackPageState extends State<DraggableStackPage> {
  bool pageOneActive = true;
  @override
  Widget build(BuildContext context) {
    return DrawerStateful(
      leftDrawer: pageOne(),
      mainPage: const Text(
        "CHAT",
        style: TextStyle(fontSize: 24.0),
      ),
      drawerInfo: DrawerInfo(),
    );
  }

  Center pageOne() {
    return const Center(
      child: Text(
        "Page One",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
