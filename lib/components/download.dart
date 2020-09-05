import 'dart:convert';
import 'dart:io' as IO;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void downloadImg(String url, String server) async {
  var appDocDir = await getApplicationDocumentsDirectory();
  var response = await http.get(server + url);
  var filename = getmd5path(url);
  IO.File file = new IO.File(appDocDir.path + filename);
  file.writeAsBytes(response.bodyBytes);
}

String getmd5path(url) {
  return "/" + md5.convert(utf8.encode(url)).toString() + ".jpg";
}

ImageProvider getImageProvider(String urlimg, path, server) {
  var file = IO.File(path + getmd5path(urlimg));
  if (file.existsSync()) {
    return FileImage(file);
  } else {
    downloadImg(urlimg, server);
    return NetworkImage(server + urlimg);
  }
}

ImageProvider getImageProviderViewer(String urlimg, path, server) {
  var file = IO.File(path + getmd5path(urlimg));
  if (file.existsSync()) {
    return FileImage(file);
  } else {
    return NetworkImage(server + urlimg);
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
