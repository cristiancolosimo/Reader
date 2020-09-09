import 'dart:convert';
import 'dart:io' as IO;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reader/components/object.dart';

import 'global.dart';

Future downloadImg(String url, String server) async {
  var response = await http.get(server + url);
  var filename = getsha1path(url);
  IO.File file = new IO.File(path + filename);
  file.writeAsBytes(response.bodyBytes);
}

void downloadCap(CapitoloOBJ cap, String server, Function redraw) {
  var counter = 0;
  var tot = cap.lengthpag;
  cap.image.forEach((element) async {
    await downloadImg(element, server);
    counter++;
    if (counter == tot) redraw();
  });
}

void deleteCap(CapitoloOBJ cap, Function redraw) {
  cap.image.forEach((element) {
    deleteImg(element);
  });
  redraw();
}

void deleteImg(String url) {
  var filename = getsha1path(url);
  IO.File file = new IO.File(path + filename);
  file.deleteSync();
}

String getsha1path(url) =>
    "/" + sha1.convert(utf8.encode(url)).toString() + ".jpg";

ImageProvider getImageProvider(String urlimg, path, server) {
  var file = IO.File(path + getsha1path(urlimg));
  if (file.existsSync()) {
    return FileImage(file);
  } else {
    downloadImg(urlimg, server);
    return NetworkImage(server + urlimg);
  }
}

ImageProvider getImageProviderViewer(String urlimg, path, server) {
  var file = IO.File(path + getsha1path(urlimg));
  if (file.existsSync()) {
    return FileImage(file);
  } else {
    return NetworkImage(server + urlimg);
  }
}

bool checkImage(String urlimg) {
  var file = IO.File(path + getsha1path(urlimg));
  if (file.existsSync()) {
    return true;
  } else {
    return false;
  }
}
/**
 * /cartella/cartella2/file.jpg
 * 
 * 
 * 
 * 
 * 
 */
