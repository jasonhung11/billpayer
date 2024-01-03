// import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void test() async {
  var client = HttpClient();
  String host = dotenv.env["API_URL"]!;
  print("testing");
  try {
    HttpClientRequest request = await client.get(host, 8080, '/user/greeting');
    // Optionally set up headers...
    // Optionally write to the request object...
    HttpClientResponse response = await request.close();
    // Process the response
    final stringData = await response.transform(utf8.decoder).join();
    print(stringData);
  } finally {
    client.close();
  }
}
