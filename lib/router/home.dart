import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "../components/object.dart";
import '../components/const.dart';

class Manga extends StatelessWidget {
  Manga({this.copertina, this.json, this.nome, this.context});
  final String copertina;
  final String json;
  final String nome;
  final BuildContext context;
  void changeroute(MangaOBJ manga) {
    Navigator.pushNamed(
      context,
      '/book',
      arguments: manga,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeroute(MangaOBJ(copertina, nome, json));
      }, // handle your image tap here
      child: Image.network(
        url + copertina,
        fit: BoxFit.cover, // this is the solution for border
        width: MediaQuery.of(context).size.width / 2.4,
        height: 300.0,
      ),
    );
  }
}

class Home extends StatelessWidget {
  @protected
  void onPressed() {
    print("premuto");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: MangaList(),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.access_alarms),
      ),
    );
  }
}

class MangaList extends StatefulWidget {
  MangaList({Key key}) : super(key: key);

  @override
  _MangalistState createState() => _MangalistState();
}

class _MangalistState extends State<MangaList> {
  var mangas = <MangaOBJ>[];
  void load() async {
    var response = await http.get(url + "master.json");
    var jsonlist = List.from(jsonDecode(response.body));
    List<MangaOBJ> list = [];
    jsonlist.forEach((element) {
      list.add(
          MangaOBJ(element["copertina"], element["nome"], element["json"]));
    });
    setState(() {
      mangas = list;
    });
  }

  @override
  void initState() {
    super.initState();
    this.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        Wrap(
            spacing: 20.0, // gap between adjacent chips
            runSpacing: 20.0, // gap between lines
            direction: Axis.horizontal,
            children: [
              SizedBox(
                height: 50.0,
                width: 500,
                child: RaisedButton(
                  onPressed: load,
                  child: Text("Cliccami :D"),
                ),
              ),
              ...mangas
                  .map((manga) => Manga(
                        copertina: manga.copertina,
                        json: manga.json,
                        nome: manga.nome,
                        context: context,
                      ))
                  .toList(),
            ])
      ],
    );
  }
}
