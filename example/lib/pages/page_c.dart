import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation_example/pages/page_child.dart';

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
