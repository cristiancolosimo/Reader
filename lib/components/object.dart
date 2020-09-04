class CapitoloOBJ {
  List<String> image; //array di pagine
  String name; //nome del capitolo
  int lengthpag;
  CapitoloOBJ(this.image, this.name, this.lengthpag);
  factory CapitoloOBJ.fromJson(dynamic json) {
    List<String> capImg = [
      ...json["image"].map((img) => img.toString()).toList()
    ];
    return CapitoloOBJ(capImg, json["name"], capImg.length);
  }
}

class VolumeOBJ {
  String nome;
  List<CapitoloOBJ> capitoli;
  int lengthcap;
  VolumeOBJ(this.nome, this.capitoli, this.lengthcap);
  factory VolumeOBJ.fromJson(dynamic json) {
    List<CapitoloOBJ> voltemp = [
      ...json["capitoli"].map((capitolo) {
        return CapitoloOBJ.fromJson(capitolo);
      })
    ];
    return VolumeOBJ(json["nome"], voltemp, voltemp.length);
  }
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
  factory LibroOBJ.fromJson(dynamic json) {
    List<VolumeOBJ> volumi = [
      ...json["volumi"].map((volume) {
        return VolumeOBJ.fromJson(volume);
      })
    ];
    List<String> generi = [
      ...json["generi"].map((img) => img.toString()).toList()
    ];
    return LibroOBJ(json["nome"], json["anno"], volumi, generi,
        json["copertina"], volumi.length);
  }
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
