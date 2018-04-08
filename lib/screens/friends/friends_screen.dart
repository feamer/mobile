import 'package:feamer/screens/friends/friends_screen_presenter.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new FriendsState();
}

class FriendsState extends State<FriendsScreen>
    implements FriendsScreenContract {

  List<String> friends = new List();

  FriendsScreenPresenter _presenter;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  FriendsState() {
    _presenter = new FriendsScreenPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    final tiles = friends.map((name) {
      return new ListTile(
        title: new Text(name, style: _biggerFont),
      );
    });

    final divided = ListTile.divideTiles(tiles: tiles, context: context)
        .toList();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friends"),
        ),
        body: new ListView(
          children: divided,
        )
    );
  }

  @override
  onFriendsSuccess(List<String> friends) {
    setState(() {
      this.friends = friends;
    });
  }
}