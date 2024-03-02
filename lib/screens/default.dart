import 'package:flutter/material.dart';

class DefaultScreen extends StatelessWidget {
  static String route = "/default";
  const DefaultScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("This is Default screen"),
      alignment: Alignment.center,
    );
  }
}