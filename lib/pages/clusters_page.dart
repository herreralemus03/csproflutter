import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:boletas_app/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClustersPage extends StatefulWidget {
  final bool selectionMode;
  ClustersPage({this.selectionMode = false});
  @override
  _ClustersPageState createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  ClusterProvider clusterProvider = ClusterProvider();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    clusterProvider.getClusters();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        clusterProvider.getClusters(loadNextPage: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearchBox(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.of(context).popAndPushNamed("/clusters");
        },
        child: SafeArea(
          child: buildBody(),
        ),
      ),
    );
  }

  TextEditingController textEditingController = TextEditingController();
  Widget buildSearchBox() {
    return TextField(
      autofocus: false,
      controller: textEditingController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "CODE",
        suffixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      keyboardType: TextInputType.number,
      onSubmitted: (keyword) {
        clusterProvider.getClusters(params: {"keyword": keyword});
      },
    );
  }

  final scrollPhysics = AlwaysScrollableScrollPhysics();
  Widget buildBody() {
    return StreamBuilder<ClustersPageData>(
      stream: clusterProvider.dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          final clusters = snapshot.data.content.values.toList();
          if (snapshot.data.empty) {
            return EmptyContainer();
          }
          return ListView.separated(
            controller: scrollController,
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 2.0,
              );
            },
            itemCount: clusters.length,
            itemBuilder: (context, index) {
              final cluster = clusters[index];
              return buildItem(cluster);
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

  Widget buildItem(Cluster cluster) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'AGREGAR\nHOUSEHOLD',
          color: Colors.blueAccent,
          icon: Icons.add,
        ),
        IconSlideAction(
          caption: 'CERRAR',
          color: Colors.grey.shade600,
          icon: Icons.close,
        ),
      ],
      child: ListTile(
        leading: Icon(Icons.account_tree),
        title: Text(
          "${cluster?.commune?.name}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: [
            Divider(),
            buildSubtitle("CODE", "${cluster?.code}"),
            Divider(),
            buildSubtitle("REGION", "${cluster?.region?.name}"),
            Divider(),
            buildSubtitle("AREA", "${cluster?.area?.name}"),
            Divider(),
            buildSubtitle("PROVINCE", "${cluster?.province?.name}"),
            Divider(),
            buildSubtitle("DISTRICT", "${cluster?.district?.name}"),
          ],
        ),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          if (widget.selectionMode) {
            Navigator.of(context).pop(cluster);
          } else {
            navigateToHouseHoldsPage(cluster.uuid, cluster.code);
          }
        },
      ),
    );
  }

  Widget buildSubtitle(String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label + ":",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 40),
        Flexible(
            child: Text(
          text.trim().isEmpty ? "-" : text,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.end,
        )),
      ],
    );
  }

  void navigateToHouseHoldsPage(String uuid, String code) {
    Navigator.of(context).pushNamed("/households", arguments: <String, dynamic>{
      "uuid": uuid,
      "provider": clusterProvider,
      "clusterCode": code,
    });
  }
}
