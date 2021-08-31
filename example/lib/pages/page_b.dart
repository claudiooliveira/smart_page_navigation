import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation_example/pages/page_child.dart';

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
