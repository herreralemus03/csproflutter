import 'dart:async';
import 'dart:convert';
import 'package:boletas_app/models/household.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:boletas_app/config/server_config.dart';
import 'package:boletas_app/repository/db_repository.dart';
import 'package:path_provider/path_provider.dart';

class DeviceProvider {
  StreamController<Map<String, dynamic>> streamController =
      StreamController.broadcast();
  Function(Map<String, dynamic>) get dataSink => streamController.sink.add;
  Stream<Map<String, dynamic>> get dataStream => streamController.stream;

  Future<http.Response> doGet(String unencodedPath,
      [Map<String, String> params]) async {
    final uri = Uri.http("$host:$port", "devices/$unencodedPath", params);
    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "",
    });
    return response;
  }

  Future<http.Response> doPost(String unencodedPath,
      [Map<String, String> params]) async {
    final uri = Uri.http("$host:$port", "devices/$unencodedPath", params);
    final response = await http.post(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "",
    });
    return response;
  }

  Future<Map<String, dynamic>> getAllDevices({
    String keyword = "",
    int page = 0,
    int size = 25,
  }) async {
    final response = await doPost("get/all");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    dataSink(decodedData);
    return decodedData;
  }
}
