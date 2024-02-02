import 'package:http/http.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void test() async {
  // var client = HttpClient();
  // String baseUrl = dotenv.env["API_URL"]!;
  // String userPath = dotenv.env["API_URL"]!;
  // // String host = dotenv.env["API_URL"]!;
  // print("testing");
  // try {
  //   HttpClientRequest request = await client.get(host, 8080, '/user/greeting');
  //   // Optionally set up headers...
  //   // Optionally write to the request object...
  //   HttpClientResponse response = await request.close();
  //   // Process the response
  //   final stringData = await response.transform(utf8.decoder).join();
  //   print(stringData);
  // } finally {
  //   client.close();
  // }
}

Future<Map<String, dynamic>> getUserTransactionHistory(
    String groupId, String userId) async {
  var client = HttpClient();
  String baseUrl = dotenv.env["API_URL"]!;
  String transactionAPIPath = dotenv.env["TRANSACTION_API_PATH"]!;
  String groupAPIPath = dotenv.env["GROUP_API_PATH"]!;
  try {
    Response response = await get(Uri.parse(
        '$baseUrl/$groupAPIPath/$groupId/$transactionAPIPath/$userId'));
    return jsonDecode(response.body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}

Future<Map<String, dynamic>> getUserTransactionDetail(String id) async {
  var client = HttpClient();
  String baseUrl = dotenv.env["API_URL"]!;
  String transactionAPIPath = dotenv.env["TRANSACTION_API_PATH"]!;
  try {
    Response response =
        await get(Uri.parse('$baseUrl/$transactionAPIPath/$id'));
    return jsonDecode(response.body) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}
