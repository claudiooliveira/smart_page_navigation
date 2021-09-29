# smart_page_navigation

[pub package](https://pub.dartlang.org/packages/smart_page_navigation)

In this Flutter package you will have full navigation with bottom navigation bar exactly like the way Instagram works.

Created by Claudio Oliveira (https://twitter.com/cldlvr)

<img src="https://github.com/claudiooliveira/smart_page_navigation/blob/main/live_example.gif?raw=true" alt="Live Example" width="300"/>

### Add dependency

```yaml
dependencies:
  smart_page_navigation: ^1.1.1 #latest version
```

### Easy to use

```dart
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
          onTap: (int index, BuildContext context) {
            print("Clicked at index $index");
            return true;
          },
        ),
      ),
    );
  }
}
```

## Controller Initialization

```dart
//Attention! It is recommended that .newInstance 
//be called only once during your application's lifecycle.
//To get the controller instance on other pages use .getInstance().

controller = SmartPageController.newInstance(
  initialPages: [
    PageA(),
    PageB(),
    PageC(),
  ],
  context: context,
);
```

`context`: BuildContext.\
`initialPages`: List of StatefulWidgets (pages of your app).\
`initialPage`: index of first page of initialPages. `Default: 0`

### Properties

`List<StatefulWidget> pages`: Stack of pages.\
`List<StatefulWidget> initialPages`: Initial page stack.\
`int currentBottomIndex`: Index of selected bottom navigation bar option.

### Methods

`newInstance(StatefulWidget newPage)`: Inserts a new page into the stack. By default the page is displayed, but you can prevent this by setting goToNewPage equal to false.\
`insertPage(StatefulWidget newPage)`: Inserts a new page into the stack. By default the page is displayed, but you can prevent this by setting goToNewPage equal to false.\
`goToPage(int index)`: Navigate to index page.\
`selectBottomTab(int index)`: This method navigates to the screen configured in the index position of the bottom navigation bar.\
`resetNavigation()`: Clears all navigation.\
`showBottomNavigationBar()`: Show bottom navigation.\
`hideBottomNavigationBar()`: Hide bottom navigation.\
`refreshViews()`: Update widget state.\
`back()`: Return to previous page.

## Listeners

`addListener(Function listener)`: Method that listens when any changes occur.\
`addOnBackPageListener(Function listener)`: Method that listens when the .back() method is called.\
`addOnBottomNavigationBarChanged(Function(int index) listener)`: Method that listens for changes in the bottom navigation bar.\
`addOnBottomOptionSelected(Function(int index) listener)`: Method that listens when one of the options in the lower navigation bar is selected.\
`addOnInsertPageListener(Function(StatefulWidget page, int newPageIndex) listener)`: Method that listens when a new page is added to the stack.\
`addOnPageChangedListener(Function(int index) listener)`: Method that listens when the current page index changes.\
`addOnResetNavigation(Function listener)`: Method that listens when navigation is reset.

## SmartPageBottomNavigationBar

`SmartPageController controller`: Instance of SmartPageController.\
`List<BottomIcon> children`: List of BottomIcon.\
`bool onTap(int index)?`: Callback method when a bottom bar button is pressed. Return false if you want to block browsing.\
`SmartPageBottomNavigationOptions? options`: SmartPageBottomNavigationOptions instance with styling options.

### BottomIcon

`String? title`: Text displayed below option icon (if any).\
`TextStyle? textStyle`: Title text style.\
`IconData? icon`: Option icon.\
`bool? hideBottomNavigationBar`: Hides the bottom navigation bar when the option is selected.\
`Widget? badge`: Display a widget as a badge.\
`Color? badgeColor`: Badge color.\
`Widget? selectedWidget`: If you want to customize the content of the option, you can add the selectedWidget, then you will have to configure the unselectedWidget as well. `Warning: You must obligatorily use selectedWidget/unselectedWidget OR title for the option content to be displayed.`\
`Widget? unselectedWidget`: Widget displayed when the option is not selected.

### SmartPageBottomNavigationOptions

`height`: (double) Widget height.\
`showIndicator`: (bool) Show/hide top indicator of selected option.\
`indicatorColor`: (Color) Top indicator color.\
`backgroundColor`: (Color) Widget background color.\
`showBorder`: (bool) Show/hide border.\
`borderColor`: (Color) Border color.\
`selectedColor`: (Color) Icon and text color when option is selected.\
`unselectedColor`: (Color) Icon and text color when the option is not selected.