import 'dart:io';

import 'package:feamer/screens/home/home_screen_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<HomeScreen> implements HomeScreenContract {
  static const platform = const MethodChannel('app.channel.shared.data');
  File fileShared;
  bool uploadSuccessful;
  String downloadedFile = "";

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  HomeScreenPresenter _presenter;

  HomeState() {
    _presenter = new HomeScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    uploadSuccessful = false;
    getSharedFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Feamer"),
          actions: [
            new IconButton(
                icon: new Icon(Icons.code), onPressed: () => addFriend()),
            new IconButton(
                icon: new Icon(Icons.exit_to_app), onPressed: () => logout()),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed: () => Navigator.of(context).pushNamed("/friends"),
            child: const Icon(Icons.face)
        ),
        body: new Column(children: [
          new Center(
            child: uploadSuccessful
                ? new Container(
                    child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Icon(Icons.check,
                          color: Colors.green[500], size: 100.0),
                      new Text("Successful uploaded!!"),
                    ],
                  ))
                : fileShared != null
                    ? new CircularProgressIndicator()
                    : new Text(""),
          ),
          new Center(
              child: downloadedFile != ""
                  ? new Container(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          new Icon(Icons.attach_file,
                              color: Colors.grey[500], size: 100.0),
                          new Text("Stored download file at $downloadedFile"),
                        ]))
                  : new Text(""))
        ]));
  }

  getSharedFile() async {
    var sharedFilePath = await platform.invokeMethod("getSharedFilePath");
    if (sharedFilePath != null) {
      setState(() {
        fileShared = new File(sharedFilePath);
        uploadSuccessful = false;
      });
      _presenter.doUpload(fileShared);
    }
  }

  logout() async {
    _presenter.logout();
    Navigator.of(context).pushNamed("/login");
  }

  addFriend() async {
    _presenter.addFriend();
  }

  @override
  onUploadFailure(String error) {
    print(error);
  }

  @override
  onUploadSuccess(String uuid) {
    print(uuid);
    setState(() {
      uploadSuccessful = true;
    });
  }

  @override
  onDownloadReceived(File file) {
    print("Downloaded File");
    setState(() {
      downloadedFile = file.path;
    });
  }
}
