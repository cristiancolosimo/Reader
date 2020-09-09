import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './router/home.dart';
import 'router/book.dart';
import './router/viewer.dart';
import './components/global.dart' as globals;
import './router/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(App());

// ignore: must_be_immutable
class App extends StatelessWidget {
  void setGlobals() async {
    var directory = await getApplicationDocumentsDirectory();
    globals.path = directory.path;
    var pref = await SharedPreferences.getInstance();
    var url = pref.getString("url") ?? globals.url;
    globals.url = url;
  }

  @override
  Widget build(BuildContext context) {
    setGlobals();
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Home(),
        "/book": (context) => BookRoute(),
        "/read": (context) => ViewerRoute(),
        "/settings": (context) => SettingsRoute()
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
    );
  }
}
