import 'package:flutter/material.dart';

class PageChild extends StatefulWidget {
  String title;
  PageChild({Key? key, required this.title}) : super(key: key);

  @override
  _PageChildState createState() => _PageChildState();
}

class _PageChildState extends State<PageChild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Center(
        child: Column(
          children: [
            Text(
              "Child Page: ${widget.title}",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
