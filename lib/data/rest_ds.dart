import 'dart:async';
import 'dart:convert';
import 'package:mobile/utils/network_util.dart';
import 'package:mobile/models/user.dart';
import 'package:crypto/crypto.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://192.168.111.38:9876";
  static final LOGIN_URL = BASE_URL + "/login";

  Future<User> login(String username, String password) {
    final _hashUsername = sha1.convert(new Utf8Encoder().convert(username)).toString();
    final _hashPassword = sha1.convert(new Utf8Encoder().convert(password)).toString();

    return _netUtil.post(LOGIN_URL, body: {
      "username": _hashUsername,
      "password": _hashPassword
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(_hashUsername, _hashPassword, res["user"]);
    });
  }
}