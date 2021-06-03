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

  ClustersPageData clustersPageData = ClustersPageData(number: 0, content: {});
  ClustersPageData filteredClustersPageData =
      ClustersPageData(number: 0, content: {});
  bool isLoading = false;
  Future<ClustersPageData> getClusters(
      {Map<String, String> params = const {},
      bool loadNextPage = false}) async {
    bool filtered = (params["keyword"] ?? "").isNotEmpty;
    ClustersPageData clustersPageData =
        filtered ? this.filteredClustersPageData : this.clustersPageData;
    if (isLoading) {
      return await Future.delayed(Duration(seconds: 3), () {
        isLoading = false;
        return clustersPageData;
      });
    }
    isLoading = true;
    final map = {
      "keyword": params["keyword"] ?? "",
      "page": "${loadNextPage ? clustersPageData.number + 1 : 0}",
      "size": params["size"] ?? "15",
    };
    final response = await doGet("get/all", map);
    final decodedData = json.decode(utf8.decode(response.bodyBytes));
    this.clustersPageData =
        syncData(loadNextPage, decodedData, clustersPageData);
    return clustersPageData;
  }

  ClustersPageData syncData(bool loadNextPage, Map<String, dynamic> decodedData,
      ClustersPageData clustersPageData) {
    if (!loadNextPage) {
      clustersPageData = ClustersPageData.fromJson(decodedData);
      dataSink(clustersPageData);
      isLoading = false;
      return clustersPageData;
    }
    Map<String, Cluster> clusterListTmp = Map();
    clusterListTmp.addAll(Map.from(clustersPageData.content));
    clustersPageData = ClustersPageData.fromJson(decodedData);
    clusterListTmp.addAll(Map.from(clustersPageData.content));
    clustersPageData.content = clusterListTmp;
    dataSink(clustersPageData);
    isLoading = false;
    return clustersPageData;
  }

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
