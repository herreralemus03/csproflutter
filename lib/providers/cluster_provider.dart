import 'dart:async';
import 'dart:convert';
import 'package:boletas_app/models/household.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:boletas_app/config/server_config.dart';
import 'package:boletas_app/repository/db_repository.dart';
import 'package:path_provider/path_provider.dart';

class ClusterProvider {
  ClusterProvider() {
    if (!kIsWeb) setupDb();
  }
  setupDb() async {
    final directory = await getExternalStorageDirectory();
    DbHelper.initialize(directory.path + "/sqlite2.db");
  }

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
    syncStreamController.close();
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
      "page": "${loadNextPage ? clustersPageData.number++ : 0}",
      "size": params["size"] ?? "15",
    };
    if (kIsWeb) {
      await setupDb();
      final decodedJson = await DbHelper.instance.buildPage(
          "clusters",
          PageRequest.page(
            page: int.parse(map["page"]),
            size: int.parse(map["size"]),
          ),
          buildNestedChild: true,
          where: map["keyword"].isEmpty
              ? ""
              : "where code like '${map["keyword"]}'");
      this.clustersPageData =
          syncData(loadNextPage, decodedJson, clustersPageData);
      isLoading = false;

      return this.clustersPageData;
    } else {
      final response = await doGet("get/all", map);
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      clustersPageData = syncData(loadNextPage, decodedData, clustersPageData);
      isLoading = false;
      return this.clustersPageData;
    }
  }

  StreamController<ClustersPageData> syncStreamController =
      StreamController.broadcast();
  Function(ClustersPageData) get syncDataSink => syncStreamController.sink.add;
  Stream<ClustersPageData> get syncDataStream => syncStreamController.stream;
  Future<ClustersPageData> getSyncData() async {
    await syncPage(page: currentSyncPage, sync: false);
    while (currentSyncPage < this.syncPageData.totalPages ?? 100) {
      await syncPage(page: currentSyncPage++, sync: true);
    }
    return this.syncPageData;
  }

  Future<ClustersPageData> syncPage({
    int page = 0,
    int size = 25,
    String keyword = "",
    bool sync = true,
  }) async {
    try {
      final response = await doGet("get/all", {
        "page": "$page",
        "size": "$size",
      });
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      this.syncPageData = ClustersPageData.fromJson(decodedData);
      syncDataSink(this.syncPageData);
      return this.syncPageData;
    } catch (e) {
      syncStreamController.addError(e);
      return this.syncPageData;
    }
  }

  int currentSyncPage = 0;
  ClustersPageData syncPageData =
      ClustersPageData(pageable: Pageable(pageNumber: 0));

  ClustersPageData syncData(bool loadNextPage, Map<String, dynamic> decodedData,
      ClustersPageData clustersPageData) {
    if (!loadNextPage) {
      clustersPageData = ClustersPageData.fromJson(decodedData);
      dataSink(clustersPageData);
      isLoading = false;
      return clustersPageData;
    }
    Map<String, Cluster> clusterListTmp = Map();
    clusterListTmp.addAll(Map.of(clustersPageData.content));
    clustersPageData = ClustersPageData.fromJson(decodedData);
    clusterListTmp.addAll(Map.of(clustersPageData.content));
    clustersPageData.content = clusterListTmp;
    dataSink(clustersPageData);
    isLoading = false;
    return clustersPageData;
  }

  Future<HouseHoldsPageData> getClusterHouseHolds(
      {Map<String, String> params = const {}}) async {
    if (!kIsWeb) {
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
      return houseHolds;
    } else {
      await setupDb();
      final decodedData = await DbHelper.instance.buildPage(
          "households", PageRequest.page(page: 0, size: 20),
          where: "where cluster_uuid like '${params['uuid']}'");

      final houseHolds = HouseHoldsPageData.fromJson(decodedData);
      if (!houseHolds.first) {
        var houseHoldsTmp = await houseHoldDataStream.first;
        var houseHoldsContentTmp = houseHoldsTmp.content;
        houseHolds.content.addAll(houseHoldsContentTmp);
        houseHoldDataSink(houseHolds);
      } else {
        houseHoldDataSink(houseHolds);
      }
      return houseHolds;
    }
  }

  Cluster getCluster({String code}) {}
}
