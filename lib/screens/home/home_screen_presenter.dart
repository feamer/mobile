import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:feamer/data/database_helper.dart';
import 'package:feamer/data/rest_ds.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcodescanner/barcodescanner.dart';

abstract class HomeScreenContract {
  onUploadSuccess(String uuid);

  onUploadFailure(String error);

  onDownloadReceived(File file);
}

class HomeScreenPresenter {
  HomeScreenContract _view;
  var api = new RestDatasource();
  var db = new DatabaseHelper();
  IOWebSocketChannel connection;
  static const platform = const MethodChannel('app.channel.shared.data');

  HomeScreenPresenter(this._view) {
    startWebSocket();
  }

  doUpload(File file) {
    api.upload(file).then((uuid) {
      _view.onUploadSuccess(uuid);
    }).catchError((Exception error) => _view.onUploadFailure(error.toString()));
  }

  startWebSocket() async {
    var token = await db.selectToken();

    print(token);

    connection = new IOWebSocketChannel.connect("ws://51.144.0.67:80/ws",
        headers: {"Authorization": token});

    connection.stream.listen((res) {
      _showNotification(json.decode(res));
    }, onError: (error) => print(error.toString()));
  }

  _showNotification(dynamic data) async {
    print(data);
    var name = data["name"];
    await ScheduledNotifications.scheduleNotification(
        new DateTime.now().millisecondsSinceEpoch,
        "",
        "Received File!!",
        name);

    await downloadFile(data);
  }

  downloadFile(dynamic data) async {
    final dir = (await getExternalStorageDirectory()).path + "/Download/${data["name"]}";
    var file = new File(dir);
    var bytes = await api.download(data["endpoint"]);
    await file.writeAsBytes(bytes);

    _view.onDownloadReceived(file);
  }

  addFriend() async {
    String friendId = await _scanBarcode();
    print(friendId);
    api.addFriend(friendId);
  }

  Future<String> _scanBarcode() async {
    Map<String, dynamic> barcodeData;
    try {
      //barcodeData is a JSON (Map<String,dynamic>) like this:
      //{barcode: '12345', barcodeFormat: 'ean-13'}
      barcodeData = await Barcodescanner.scanBarcode;
    } on PlatformException {
      barcodeData = {'barcode': 'Could not scan barcode'};
    }

    return barcodeData['barcode'];
  }

  logout() {
    db.deleteUsers();
  }
}
