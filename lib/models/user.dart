class User {
  String _username;
  String _password;
  String _token;

  User(this._username, this._password, this._token);

  User.map(Map<String, dynamic> user) {
   this._username = user["username"];
   this._password = user["password"];
   this._token = user["token"];
  }

  String get username => _username;
  String get password => _password;
  String get token => _token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["token"] = _token;

    return map;
  }
}