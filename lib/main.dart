import 'package:flutter/material.dart';
import 'package:mobile/routes.dart';

void main() => runApp(new Feamer());

class Feamer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Feamer',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
