import 'dart:async';
import 'dart:convert';

import 'package:boletas_app/models/household.dart';
import 'package:http/http.dart' as http;
import 'package:boletas_app/config/server_config.dart';

class ClusterProvider {
  StreamController<ClustersPageData> streamController =
      StreamController.broadcast();
  Function(ClustersPageData) get dataSink => streamController.sink.add;
  Stream<ClustersPageData> get dataStream => streamController.stream;

  StreamController<Map<String, Cluster>> filteredStreamController =
      StreamController.broadcast();
  Function(Map<String, Cluster>) get filteredDataSink =>
      filteredStreamController.sink.add;
  Stream<Map<String, Cluster>> get filteredDataStream =>
      filteredStreamController.stream;

  StreamController<HouseHoldsPageData> houseHoldStreamController =
      StreamController.broadcast();
  Function(HouseHoldsPageData) get houseHoldDataSink =>
      houseHoldStreamController.sink.add;
  Stream<HouseHoldsPageData> get houseHoldDataStream =>
      houseHoldStreamController.stream;

  void disposeStreams() {
    streamController.close();
    filteredStreamController.close();
    houseHoldStreamController.close();
  }

  Future<http.Response> doGet(String unencodedPath,
      [Map<String, String> params]) async {
    final uri = Uri.http("$host:$port", "clusters/$unencodedPath", params);
    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "",
    });
    return response;
  }

  Future<ClustersPageData> getClusters(
      {Map<String, String> params = const {}}) async {
    final response = await doGet("get/all", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    final clustersPage = ClustersPageData.fromJson(decodedData);

    return clustersPage;
  }

  Future<Map<String, Cluster>> getFilteredClusters(
      {Map<String, String> params = const {}}) async {
    final response = await doGet("get/filter", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    final clusters = Map<String, Cluster>.fromEntries(
        (decodedData["content"] as List)
            .map((e) => MapEntry(e["uuid"], Cluster.fromJson(e))));
    filteredDataSink(clusters);
    return clusters;
  }

  int houseHoldPage = 0;
  bool isLoading = false;
  Future<HouseHoldsPageData> getClusterHouseHolds(
      {Map<String, String> params = const {}}) async {
    if (isLoading) return houseHoldDataStream.first;
    isLoading = true;
    params["page"] =
        ("${(int.parse(params["page"]) > 0) ? int.parse(params["page"]) + 1 : int.parse(params["page"]) + 0}" ??
            "0");
    final response = await doGet("get/households", params);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    final houseHolds = HouseHoldsPageData.fromJson(decodedData);
    if (!houseHolds.first) {
      var houseHoldsTmp = await houseHoldDataStream.first;
      var houseHoldsContentTmp = houseHoldsTmp.content;
      houseHolds.content.addAll(houseHoldsContentTmp);
      houseHoldDataSink(houseHolds);
    } else {
      houseHoldDataSink(houseHolds);
    }
    isLoading = false;
    return houseHolds;
  }
}
