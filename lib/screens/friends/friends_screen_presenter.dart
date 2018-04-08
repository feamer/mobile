import 'package:feamer/data/database_helper.dart';
import 'package:feamer/data/rest_ds.dart';

abstract class FriendsScreenContract {
  onFriendsSuccess(List<String> friends);
}

class FriendsScreenPresenter {

  FriendsScreenContract _view;
  var api = new RestDatasource();
  var db = new DatabaseHelper();

  FriendsScreenPresenter(this._view) {
    initFriends();
  }

  initFriends() async {
    var friends = await api.getFriends();
    _view.onFriendsSuccess(friends);
  }
}

