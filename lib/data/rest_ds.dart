import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mobile/utils/network_util.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/data/database_helper.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  var db = new DatabaseHelper();
  static final BASE_URL = "http://51.144.0.67";
  static final LOGIN_URL = BASE_URL + "/login";
  static final FILE_URL = BASE_URL + "/rest/upload";

  Future<User> login(String username, String password) {
    final _hashPassword = sha1.convert(new Utf8Encoder().convert(password)).toString();

    print(_hashPassword);

    return _netUtil.post(LOGIN_URL, body: json.encode({
      "username": username,
      "password": _hashPassword
    })).then((dynamic res) {
      print(res.toString());
      return new User(username, _hashPassword, res.toString());
    });
  }

  Future<List<int>> download(String url) async {
    var token = await db.selectToken();
    var fileUrl = BASE_URL + url;
    return _netUtil.getBytes(fileUrl, headers: {
      "Authorization": token
    }).then((dynamic res) {
      return res;
    });
  }

  Future<User> loginHashed(String username, String _hashPassword) {
    return _netUtil.post(LOGIN_URL, body: json.encode({
      "username": username,
      "password": _hashPassword
    })).then((dynamic res) {
      print(res.toString());
      return new User(username, _hashPassword, res.toString());
    });
  }

  Future<String> upload(File file) async {
    var token = await db.selectToken();
    return _netUtil.post(FILE_URL, headers: {
      "Authorization": token,
      "Filename": basename(file.path)
    }, body: file.readAsBytesSync()).then((dynamic res) {
      return res.toString();
    });
  }
}