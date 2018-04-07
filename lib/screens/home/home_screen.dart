import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeScreen> {
  static const platform = const MethodChannel('app.channel.shared.data');
  File fileShared;

  @override
  void initState() {
    super.initState();
    getSharedFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Feamer"),
      ),
      body: new Center(
        child: new Text(fileShared != null ? fileShared.path : ""),
      ),
    );
  }

  getSharedFile() async {
    var sharedFilePath = await platform.invokeMethod("getSharedFilePath");
    if (sharedFilePath != null) {
      setState(() {
        fileShared = new File(sharedFilePath);
      });
    }
  }
}
