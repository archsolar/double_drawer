import 'package:custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      leftDrawer: yourLeftDrawer(),
      mainPage: yourMainPage(),
    );
  }

  Center yourMainPage() {
    return const Center(
      child: Text(
        "Main Page",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Center yourLeftDrawer() {
    return const Center(
      child: Text(
        "Side",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
