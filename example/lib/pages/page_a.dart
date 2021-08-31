import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation_example/pages/page_child.dart';

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
