import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../components/object.dart";
import '../components/download.dart';
import '../components/global.dart' as globals;
import 'package:http/http.dart' as http;

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

  void fallback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var jsondata = prefs.getString(widget.jsonpath) ?? "";
    if (jsondata != "") {
      var json = jsonDecode(jsondata);
      setState(() {
        libro = LibroOBJ.fromJson(json);
      });
    }
  }

  LibroOBJ libro = LibroOBJ("", "", [], [], "", 0);
  void getHttpdata() async {
    try {
      var response = await http.get(globals.url + widget.jsonpath).timeout(
        Duration(seconds: 1),
        onTimeout: () {
          return null;
        },
      );
      if (response != null) {
        String jsondata = response.body;
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString(widget.jsonpath, jsondata);
        var json = jsonDecode(jsondata);
        setState(() {
          libro = LibroOBJ.fromJson(json);
        });
      } else {
        fallback();
      }
    } catch (e) {}
    /*Dio dio = new Dio();
    dio.options.connectTimeout = 1000;
    dio.options.receiveTimeout = 1000;
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) => {},
        onResponse: (Response response) => print(response.data),
        onError: (DioError dioError) => {fallback()}));
    try {
      Response response = await dio.get(globals.url + widget.jsonpath);
      print(response.data);
      if (response.data["nome"] == null) return;

      String jsondata = response.data.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
//
      prefs.setString(widget.jsonpath, jsondata);
      var json = jsonDecode(jsondata);
      setState(() {
        libro = LibroOBJ.fromJson(json);
      });
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        print("error 404");
      }
    }*/
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
