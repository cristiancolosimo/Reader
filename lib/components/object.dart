class CapitoloOBJ {
  List<String> image; //array di pagine
  String name; //nome del capitolo
  int lengthpag;
  CapitoloOBJ(this.image, this.name, this.lengthpag);
}

class VolumeOBJ {
  String nome;
  List<CapitoloOBJ> capitoli;
  int lengthcap;
  VolumeOBJ(this.nome, this.capitoli, this.lengthcap);
}

class LibroOBJ {
  String nome;
  String anno;
  List<VolumeOBJ> volumi;
  List<String> generi;
  String copertina;
  int lengthvol;
  LibroOBJ(this.nome, this.anno, this.volumi, this.generi, this.copertina,
      this.lengthvol);
}

class MangaOBJ {
  String copertina; //url assoluto della copertina
  String nome; //nome del manga
  String json; //url del file json
  MangaOBJ(this.copertina, this.nome, this.json);
  factory MangaOBJ.fromJson(dynamic json) {
    return MangaOBJ(json["copertina"], json["nome"], json["json"]);
  }
}

class ViewerData {
  LibroOBJ libro;
  int volume;
  int capitolo;
  int pagina;
  ViewerData(this.libro, this.volume, this.capitolo, this.pagina);
}
