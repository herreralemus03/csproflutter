import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/pages/households_page.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:boletas_app/search_delegate/clusters_search.dart';
import 'package:boletas_app/widgets/empty_widget.dart';
import 'package:flutter/material.dart';

class ClustersPage extends StatefulWidget {
  @override
  _ClustersPageState createState() => _ClustersPageState();
}

class _ClustersPageState extends State<ClustersPage> {
  ClusterProvider clusterProvider = ClusterProvider();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    clusterProvider.getFilteredClusters();
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              buildAppBar(),
              SliverFillRemaining(
                hasScrollBody: true,
                child: buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      title: buildSearchBox(),
      backgroundColor: Colors.grey.shade900,
      automaticallyImplyLeading: false,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Container(
          color: Colors.grey.shade900,
          child: Center(
            child: ListTile(
              leading: Icon(
                Icons.person,
                size: 75,
                color: Colors.white,
              ),
              title: Text(
                "FERNANDO HERRERA",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "SUPERVISOR",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        /* IconButton(
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
        ), */
      ],
    );
    return AppBar(
      title: Text("Clusters"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ClustersSearch(provider: clusterProvider),
            ).then(
              (uuid) => navigateToHouseHoldsPage(uuid),
            );
          },
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            minRadius: 40,
            maxRadius: 40,
            child: Icon(Icons.person, size: 45),
          ),
        ),
        Text(
          "SUPERVISOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        buildSearchBox(),
      ],
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
        prefixIcon: Icon(
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
              return ListTile(
                leading: Icon(Icons.account_tree),
                title: Text(cluster.commune.name),
                subtitle: Column(
                  children: [
                    Divider(),
                    buildSubtitle("CODE", "${cluster.code}"),
                    Divider(),
                    buildSubtitle("REGION", "${cluster.region.name}"),
                    Divider(),
                    buildSubtitle("AREA", "${cluster.area.name}"),
                    Divider(),
                    buildSubtitle("PROVINCE", "${cluster.province.name}"),
                    Divider(),
                    buildSubtitle("DISTRICT", "${cluster.district.name}"),
                  ],
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  navigateToHouseHoldsPage(cluster.uuid);
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

  Widget buildSubtitle(String label, String text) {
    return Row(
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
