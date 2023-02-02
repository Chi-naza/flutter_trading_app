import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

upload(File imageFile, String fileName, MediaType imageMediaType, uploadURL,
    Map fieldsMap) async {
  try {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL);

    var request = http.MultipartRequest("POST", uri);

    var instancePref = await SharedPreferences.getInstance();
    var userVerified = instancePref.getString('userVerified');

    request.headers.addAll({'Cookie': 'userVerified=${userVerified}'});
    for (var key in fieldsMap.keys) {
      request.fields[key] = fieldsMap[key];
    }

    var multipartFile = http.MultipartFile(fileName, stream, length,
        filename: basename(imageFile.path), contentType: imageMediaType);

    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  } catch (e) {
    print('failed upload' + e.toString());
  }
}
