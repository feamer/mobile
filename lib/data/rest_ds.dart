import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mobile/utils/network_util.dart';
import 'package:mobile/models/user.dart';
import 'package:crypto/crypto.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://51.144.0.67";
  static final LOGIN_URL = BASE_URL + "/login";

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
}