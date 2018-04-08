import 'package:feamer/screens/friends/friends_screen.dart';
import 'package:flutter/material.dart';
import 'package:feamer/screens/login/login_screen.dart';
import 'package:feamer/screens/home/home_screen.dart';

final routes = {
  '/friends': (BuildContext context) => new FriendsScreen(),
  '/login': (BuildContext context) => new LoginScreen(),
  '/home': (BuildContext context) => new HomeScreen(),
  '/': (BuildContext context) => new LoginScreen(),
};