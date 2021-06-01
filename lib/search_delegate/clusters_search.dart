import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:flutter/material.dart';

class ClustersSearch extends SearchDelegate {
  String text;
  ClusterProvider provider;
  ClustersSearch({this.text, this.provider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    provider.getFilteredClusters(params: {"code": query});
    return StreamBuilder<Map<String, Cluster>>(
      stream: provider.filteredDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.account_tree),
                title: Text(snapshot.data.values.toList()[index].commune.name),
                subtitle: Text("${snapshot.data.values.toList()[index].code}"),
                onTap: () {
                  Navigator.of(context)
                      .pop(snapshot.data.values.toList()[index].uuid);
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
