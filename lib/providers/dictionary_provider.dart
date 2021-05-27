import 'dart:convert';
import 'dart:io';

import 'package:boletas_app/models/dictionary.dart';
import 'package:boletas_app/models/household.dart';
import 'package:http/http.dart' as http;

class DictionaryProvider {
  String host = "172.16.204.81";
  String port = "8080";
  Future<http.Response> doGet(String unencodedPath) async {
    try {
      final uri = Uri.parse("http://$host:$port/$unencodedPath");
      final response = await http.get(uri);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Household>> getHouseHolds() async {
    final response = await doGet("households/get/all");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    final houseHolds =
        (decodedData as List).map((e) => Household.fromJson(e)).toList();
    return houseHolds;
  }

  Future<List<dynamic>> getRecords(String uuid) async {
    final response = await doGet("dictionaries/$uuid/get/records");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<List<dynamic>> getDictionaries() async {
    final response = await doGet("dictionaries/get/all");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<Dictionary> getDictionary(String uuid) async {
    final response = await doGet("dictionaries/get/$uuid");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    final dictionary = Dictionary.fromJson(decodedData);
    return dictionary;
  }

  Future<Map<String, dynamic>> getRawDictionary(String uuid) async {
    final response = await doGet("dictionaries/raw/$uuid");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }
}
