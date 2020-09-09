import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/global.dart' as globals;

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void changeurl(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("url", value);
    globals.url = value;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) => {print(value)},
      decoration: InputDecoration(
          border: InputBorder.none, hintText: 'Enter a search term'),
    );
  }
}
