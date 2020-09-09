import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "../components/object.dart";
import '../components/download.dart';
import '../components/global.dart' as globals;

class BookRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MangaOBJ args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Book"),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              Image(
                image:
                    getImageProvider(args.copertina, globals.path, globals.url),
                width: 150.0,
                height: 225.0,
              ),
              Text(args.nome),
            ],
          ),
          Libro(args.json),
        ],
      ),
      floatingActionButton: null,
    );
  }
}

class Libro extends StatefulWidget {
  Libro(this.jsonpath, {Key key}) : super(key: key);
  final String jsonpath;
  @override
  _LibroState createState() => _LibroState();
}

class _LibroState extends State<Libro> {
  @override
  void initState() {
    super.initState();
    this.getHttpdata();
  }

  bool connectionopen = false;
  var httpclient = http.Client();
  void fallback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsondata = prefs.getString(widget.jsonpath) ?? "{}";
    var json = jsonDecode(jsondata);
    setState(() {
      libro = LibroOBJ.fromJson(json);
    });
  }

  LibroOBJ libro = LibroOBJ("", "", [], [], "", 0);
  void getHttpdata() async {
    try {
      connectionopen = true;
      var response = await httpclient
          .get(
            //http.get
            globals.url + widget.jsonpath,
          )
          .timeout(Duration(seconds: 2))
          .catchError(fallback);

      if (response.statusCode == 200) {
        var jsondata = response.body;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(widget.jsonpath, jsondata);
        print("saved");
        var json = jsonDecode(jsondata);
        setState(() {
          libro = LibroOBJ.fromJson(json);
          connectionopen = false;
        });
      }
    } catch (e) {
      fallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: libro.volumi
          .asMap()
          .entries
          .map((volume) => Padding(
                padding: EdgeInsets.only(top: 5),
                child: Volumi(
                  volume: volume.value,
                  libro: libro,
                  volindex: volume.key,
                ),
              ))
          .toList(),
    );
  }
}

class Volumi extends StatefulWidget {
  Volumi({this.volume, this.libro, this.volindex, Key key}) : super(key: key);
  final VolumeOBJ volume;
  final int volindex;
  final LibroOBJ libro;
  @override
  _VolumiState createState() => _VolumiState();
}

class _VolumiState extends State<Volumi> {
  bool open = false;
  void tap() {
    setState(() {
      open = !open;
    });
  }

  void goToReader(int capitolo) {
    Navigator.pushNamed(
      context,
      '/read',
      arguments: ViewerData(widget.libro, widget.volindex, capitolo, 0),
    );
  }

  void redraw() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      children: [
        GestureDetector(
          onTap: tap,
          child: Text(
            widget.volume.nome,
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
        ),
        if (open)
          ...widget.volume.capitoli.asMap().entries.map(
                (cap) => Padding(
                  padding: EdgeInsets.only(bottom: 15, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => goToReader(cap.key),
                        child: Text(
                          cap.value.name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      if (checkImage(cap.value.image[0]))
                        GestureDetector(
                            onTap: () => deleteCap(cap.value, redraw),
                            child: Text(
                              "Scaricato",
                              style: TextStyle(fontSize: 18),
                            ))
                      else
                        GestureDetector(
                          onTap: () =>
                              downloadCap(cap.value, globals.url, redraw),
                          child: Text(
                            "Download",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                    ],
                  ),
                ),
              )
      ],
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
