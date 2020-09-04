import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/const.dart';
import "../components/object.dart";

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
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                url + args.copertina,
                height: 300,
                width: 150,
              ),
              Text(args.nome),
            ],
          ),
          Libro(args.json),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.access_alarms),
      ),
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

  LibroOBJ libro = LibroOBJ("", "", [], [], "", 0);
  Future<void> getHttpdata() async {
    var response = await http.get(url + widget.jsonpath);
    var jsondata = response.body;
    var json = jsonDecode(jsondata);
    setState(() {
      libro = LibroOBJ.fromJson(json);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: libro.volumi
          .asMap()
          .entries
          .map((volume) => new Volumi(
                volume: volume.value,
                libro: libro,
                volindex: volume.key,
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
                (cap) => GestureDetector(
                  onTap: () => goToReader(cap.key),
                  child: Text(
                    cap.value.name,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )
      ],
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
