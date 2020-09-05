import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './router/home.dart';
import 'router/book.dart';
import './router/viewer.dart';
import './components/global.dart' as globals;

const url = "http://192.168.1.5:8080/";
void main() => runApp(App());

// ignore: must_be_immutable
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getApplicationDocumentsDirectory()
        .then((value) => globals.path = value.path);
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
