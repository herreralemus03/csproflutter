import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/pages/households_page.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:boletas_app/search_delegate/clusters_search.dart';
import 'package:flutter/material.dart';

class ClustersPage extends StatefulWidget {
  @override
  _ClustersPageState createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  ClusterProvider clusterProvider = ClusterProvider();

  @override
  void initState() {
    super.initState();
    clusterProvider.getFilteredClusters();
  }

  String _query = "";
  set query(value) {
    _query = value;
    clusterProvider.getFilteredClusters(params: {"code": value});
  }

  get query => _query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clusters"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClustersSearch(provider: clusterProvider),
                query: _query,
              ).then(
                (uuid) => navigateToHouseHoldsPage(uuid),
              );
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FutureBuilder<ClustersPageData>(
      future: clusterProvider.getClusters(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: snapshot.data.content.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.account_tree),
                title: Text(
                    snapshot.data.content.values.toList()[index].commune.name),
                subtitle: Text(
                    "${snapshot.data.content.values.toList()[index].code}"),
                onTap: () {
                  navigateToHouseHoldsPage(
                      snapshot.data.content.values.toList()[index].uuid);
                },
              );
            },
          );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void navigateToHouseHoldsPage(String uuid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HouseHoldsPage(
            clusterProvider: clusterProvider,
            uuid: uuid,
          );
        },
      ),
    );
  }
}
