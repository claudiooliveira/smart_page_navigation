import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

void main() {
  runApp(MyApp());
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

    controller = SmartPageController.newInstance(
      initialPages: pages,
      context: context,
    );

    //Recommended if you want to check which page is open to perform some
    //specific action such as showing/hiding widgets.
    controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
          options: SmartPageBottomNavigationOptions(),
          children: [
            BottomIcon(icon: Icons.home, title: "Home"),
            BottomIcon(
              icon: Icons.shopping_cart,
              title: "Cart",
              badge: Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeColor: Colors.redAccent,
            ),
            BottomIcon(
              icon: Icons.settings,
              title: "Settings",
              //hideBottomNavigationBar: true,
            ),
          ],
          onTap: (int index) {
            print("Clicked at index $index");
            return true;
          },
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
  late SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
  late SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Page B",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExternalPage(),
                  ),
                );
              },
              child: Text("Open External Page"),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                controller.selectBottomTab(2);
              },
              child: Text("Go To Config"),
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
  late SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
  late SmartPageController controller = SmartPageController.getInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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

class ExternalPage extends StatefulWidget {
  ExternalPage({Key? key}) : super(key: key);

  @override
  _ExternalPageState createState() => _ExternalPageState();
}

class _ExternalPageState extends State<ExternalPage> {
  late SmartPageController controller = SmartPageController.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("External Page"),
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "External Page",
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                    (route) => false,
                  );
                },
                child: Text("Go to Home and reset navigation stack"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
