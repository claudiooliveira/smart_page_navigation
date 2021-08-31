import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation_example/pages/page_a.dart';
import 'package:smart_page_navigation_example/pages/page_b.dart';
import 'package:smart_page_navigation_example/pages/page_c.dart';

void main() {
  runApp(
    SmartPageController(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Page Navigation Example",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SmartPageController controller;
  List<StatefulWidget> pages = [
    PageA(),
    PageB(),
    PageC(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = SmartPageController.of(context).init(
      initialPages: pages,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Page Navigation Example"),
      ),
      body: SmartPageNavigation(
        controller: controller,
      ),
    );
  }
}
