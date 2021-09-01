import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

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
    return WillPopScope(
      onWillPop: () async => controller.back(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Smart Page Navigation Example"),
        ),
        body: SmartPageNavigation(
          controller: controller,
        ),
        bottomNavigationBar: SmartPageBottomNavigationBar(
          controller: controller,
          children: [
            BottomIcon(icon: Icons.home),
            BottomIcon(icon: Icons.shopping_cart),
            BottomIcon(icon: Icons.settings),
          ],
        ),
      ),
    );
  }
}

class PageA extends StatefulWidget {
  PageA({Key? key}) : super(key: key);

  @override
  _PageAState createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  late SmartPageController controller;

  @override
  Widget build(BuildContext context) {
    controller = SmartPageController.of(context);
    return Center(
      child: Column(
        children: [
          Text(
            "Page A",
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              controller.insertPage(PageChild(title: "Page A"));
            },
            child: Text("Open Page"),
          ),
        ],
      ),
    );
  }
}

class PageB extends StatefulWidget {
  PageB({Key? key}) : super(key: key);

  @override
  _PageBState createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  late SmartPageController controller;

  @override
  Widget build(BuildContext context) {
    controller = SmartPageController.of(context);
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: Column(
          children: [
            Text(
              "Page B",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                controller.insertPage(PageChild(title: "Page B"));
              },
              child: Text("Open Page"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageC extends StatefulWidget {
  PageC({Key? key}) : super(key: key);

  @override
  _PageCState createState() => _PageCState();
}

class _PageCState extends State<PageC> {
  late SmartPageController controller;

  @override
  Widget build(BuildContext context) {
    controller = SmartPageController.of(context);
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          children: [
            Text(
              "Page C",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                controller.insertPage(PageChild(title: "Page C"));
              },
              child: Text("Open Page"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageChild extends StatefulWidget {
  final String title;
  PageChild({Key? key, required this.title}) : super(key: key);

  @override
  _PageChildState createState() => _PageChildState();
}

class _PageChildState extends State<PageChild> {
  late SmartPageController controller;
  @override
  Widget build(BuildContext context) {
    controller = SmartPageController.of(context);
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Column(
          children: [
            Flexible(
              child: Text(
                "Child Page: ${widget.title}",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.insertPage(
                    PageChild(title: "Child Page: ${widget.title}"));
              },
              child: Text("Open Page"),
            ),
          ],
        ),
      ),
    );
  }
}
