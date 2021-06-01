import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boletas_app/config/server_config.dart';

class RecordProvider {
  Future<http.Response> doGet(String unencodedPath) async {
    try {
      final uri = Uri.parse("http://$host:$port/$unencodedPath");
      final response = await http.get(uri);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<dynamic>> getRecords(String uuid) async {
    final response = await doGet("records/get/$uuid");
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }
}
