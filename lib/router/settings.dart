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
  String urlsetting = "";
  void changeurl(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("url", value);
    globals.url = value;
    print(value);
  }

  @override
  void initState() {
    super.initState();
    initsettings();
  }

  void initsettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var urltemp = prefs.getString("url");
    print(urltemp);
    myController.text = urltemp;
  }

  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      onFieldSubmitted: changeurl,
      decoration: InputDecoration(
          border: InputBorder.none, hintText: 'Enter a search term'),
    );
  }
}
