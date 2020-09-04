import 'package:flutter/material.dart';
import '../components/const.dart';
import "../components/object.dart";
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class ViewerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ViewerData args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Read"),
      ),
      body: Viewer(args),
      floatingActionButton: null,
    );
  }
}

class Viewer extends StatefulWidget {
  Viewer(this.data, {Key key}) : super(key: key);
  final ViewerData data;
  @override
  State<StatefulWidget> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  int pagina;
  int capitolo;
  int volume;
  LibroOBJ libro;

  int pickervolume;
  int pickercapitolo;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    var capitolotemp = widget.data.capitolo;
    var paginatemp = widget.data.pagina;
    var volumetemp = widget.data.volume;
    var librotemp = widget.data;
    setState(() {
      pickervolume = volumetemp;
      pickercapitolo = capitolotemp;
      capitolo = capitolotemp;
      pagina = paginatemp;
      volume = volumetemp;
      libro = librotemp.libro;
    });
  }

  void next() {
    if (volume - 1 == -1 &&
        pagina + 1 == libro.volumi[volume].capitoli[capitolo].image.length &&
        capitolo - 1 == -1) return;
    if (pagina + 1 == libro.volumi[volume].capitoli[capitolo].image.length &&
        capitolo - 1 == -1) {
      var volumetemp = volume - 1;
      var capitolotemp = libro.volumi[volumetemp].capitoli.length - 1;
      setState(() {
        pagina = 0;
        capitolo = capitolotemp;
        volume = volumetemp;
        pickercapitolo = capitolotemp;
        pickervolume = volumetemp;
      });
    } else if (pagina + 1 ==
        libro.volumi[volume].capitoli[capitolo].image.length) {
      var capitolotemp = capitolo - 1;
      setState(() {
        pagina = 0;
        capitolo = capitolotemp;
        pickercapitolo = capitolotemp;
      });
    } else {
      var paginatemp = pagina + 1;

      setState(() {
        pagina = paginatemp;
      });
    }
  }

  void prev() {
    if (pagina == 0 &&
        capitolo + 1 == libro.volumi[volume].capitoli.length &&
        volume + 1 == libro.volumi.length) {
      return;
    }
    if (pagina == 0 && capitolo + 1 == libro.volumi[volume].capitoli.length) {
      var capitolotemp = 0;
      var volumetemp = volume + 1;
      var paginatemp =
          libro.volumi[volumetemp].capitoli[capitolotemp].image.length - 1;
      setState(() {
        capitolo = capitolotemp;
        pagina = paginatemp;
        volume = volumetemp;
        pickercapitolo = capitolotemp;
        pickervolume = volumetemp;
      });
    } else if (pagina == 0) {
      var capitolotemp = capitolo + 1;
      var paginatemp =
          libro.volumi[volume].capitoli[capitolotemp].image.length - 1;
      setState(() {
        pagina = paginatemp;
        capitolo = capitolotemp;
        pickercapitolo = capitolotemp;
        pickervolume = volume;
      });
    } else {
      var paginatemp = pagina - 1;
      setState(() {
        pagina = paginatemp;
        pickercapitolo = capitolo;
        pickervolume = volume;
      });
    }
  }

  Widget sceglicapitolo() {
    return GestureDetector(
      onTap: () {
        print("premuto");
        showMaterialScrollPicker(
          context: context,
          title: "Scegli capitolo",
          items: <String>[
            ...libro.volumi[pickervolume].capitoli.map((cap) {
              return cap.name;
            }).toList()
          ],
          selectedItem:
              libro.volumi[pickervolume].capitoli[pickercapitolo].name,
          onChanged: (value) {
            List<String> captemp = [
              ...libro.volumi[pickervolume].capitoli.map((cap) {
                return cap.name;
              }).toList()
            ];
            var capitolotemp = captemp.indexOf(value);
            setState(() {
              pickercapitolo = capitolotemp;
              volume = pickervolume;
              capitolo = capitolotemp;
              pagina = 0;
            });
          },
        );
      },
      child: Text(libro.volumi[pickervolume].capitoli[pickercapitolo].name,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          )),
    );
  }

  Widget sceglivolume() {
    return GestureDetector(
      onTap: () {
        print("premuto");
        showMaterialScrollPicker(
          context: context,
          title: "Scegli volume",
          items: <String>[
            ...libro.volumi.map((vol) {
              return vol.nome;
            }).toList()
          ],
          selectedItem: libro.volumi[pickervolume].nome,
          onChanged: (value) {
            List<String> volumitemp = libro.volumi.map((vol) {
              return vol.nome;
            }).toList();

            setState(() {
              pickervolume = volumitemp.indexOf(value);
              pickercapitolo = 0;
            });
          },
        );
      },
      child: Text(libro.volumi[pickervolume].nome,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 20,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
        onSwipeLeft: () {
          print("avanti");
          next();
        },
        onSwipeRight: () {
          print("indietro");
          prev();
        },
        child: ListView(
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: 40,
              children: [
                sceglivolume(),
                sceglicapitolo(),
                Text(
                    (pagina + 1).toString() +
                        "/" +
                        libro.volumi[volume].capitoli[capitolo].lengthpag
                            .toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ))
              ],
            ),
            Image.network(
              url + libro.volumi[volume].capitoli[capitolo].image[pagina],
              width: MediaQuery.of(context).size.width,
            )
          ],
        ));
  }
}
