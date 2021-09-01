# smart_page_navigation

[pub package](https://pub.dartlang.org/packages/smart_page_navigation)

In this Flutter package you will have full navigation with bottom navigation bar exactly like the way Instagram works.

Created by Claudio Oliveira (https://twitter.com/cldlvr)

![Gif](https://github.com/claudiooliveira/smart_page_navigation/blob/main/live_example.gif "Fancy Gif")

### Add dependency

```yaml
dependencies:
  smart_page_navigation: ^1.0.0 #latest version
```

### Easy to use

```dart
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
          onTap: (int index) {
            print("Clicked at index $index");
          },
        ),
      ),
    );
  }
}
```

### Controller Initialization

`initialPages`: List of StatefulWidgets (pages of your app)\
`initialPage`: index of first page of initialPages

### Bottom Navigation Bar

`controller`: Instance of SmartPageController\
`children`: List of BottomIcon\
`onTap(int index)`: Callback method when a bottom bar button is pressed\