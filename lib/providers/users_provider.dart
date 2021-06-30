import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:boletas_app/config/server_config.dart';

class UsersProvider {
  StreamController<Map<String, dynamic>> streamController =
      StreamController.broadcast();
  Function(Map<String, dynamic>) get dataSink => streamController.sink.add;
  Stream<Map<String, dynamic>> get dataStream => streamController.stream;

  void disposeStreams() {
    streamController.close();
  }

  Future<http.Response> doGet(String unencodedPath,
      [Map<String, String> params]) async {
    final uri = Uri.http("$host:$port", "users/$unencodedPath", params);
    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "",
    });
    return response;
  }

  Future<http.Response> doPost(String unencodedPath,
      [Map<String, String> params]) async {
    final uri = Uri.http("$host:$port", "users/$unencodedPath", params);
    final response = await http.post(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "",
    });
    return response;
  }

  Future<Map<String, dynamic>> getUsers({Map<String, dynamic> params}) async {
    final response = await doPost("supervisores", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<Map<String, dynamic>> getAllocatedClusters(
      {String uuid, Map<String, dynamic> params}) async {
    final response = await doGet("clusters/unallocated", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<Map<String, dynamic>> getUserDevices(
      {String uuid, Map<String, dynamic> params}) async {
    final response = await doGet("$uuid/devices", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<void> removeUserDevice(
      {String uuid, String device, Map<String, dynamic> params}) async {
    await doGet("$uuid/deallocate/device/$device", params);
  }

  Future<void> addUserDevice(
      {String uuid, String device, Map<String, dynamic> params}) async {
    await doGet("$uuid/allocate/device/$device", params);
  }

  Future<Map<String, dynamic>> getUserClusters(
      {String uuid, Map<String, dynamic> params}) async {
    final response = await doGet("$uuid/clusters", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }

  Future<void> removeUserCluster(
      {String uuid, String cluster, Map<String, dynamic> params}) async {
    await doGet("$uuid/deallocate/cluster/$cluster", params);
  }

  Future<void> addUserCluster(
      {String uuid, String cluster, Map<String, dynamic> params}) async {
    await doGet("$uuid/allocate/cluster/$cluster", params);
  }

  Future<Map<String, dynamic>> getUnallocatedClusters(
      {Map<String, String> params}) async {
    final response = await doGet("clusters/unallocated", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    return decodedData;
  }
}
