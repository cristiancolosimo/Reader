import 'dart:convert';
import 'dart:io' as IO;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void downloadCopertina(String url, String server) async {
  var appDocDir = await getApplicationDocumentsDirectory();
  var response = await http.get(server + url);
  var filename = md5.convert(utf8.encode(url)).toString() + ".jpg";
  print(filename);
  IO.File file = new IO.File(appDocDir.path + filename);
  file.writeAsBytes(response.bodyBytes);
}

/**
 * /cartella/cartella2/file.jpg
 * 
 * 
 * 
 * 
 * 
 */
