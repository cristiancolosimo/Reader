import 'package:flutter/material.dart';
import './router/home.dart';
import 'router/book.dart';
import './router/viewer.dart';

const url = "http://192.168.1.5:8080/";
void main() => runApp(App());

// ignore: must_be_immutable
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Home(),
        "/book": (context) => BookRoute(),
        "/read": (context) => ViewerRoute()
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
    );
  }
}
