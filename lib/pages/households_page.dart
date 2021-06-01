import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:flutter/material.dart';

class HouseHoldsPage extends StatefulWidget {
  final ClusterProvider clusterProvider;
  final String uuid;
  HouseHoldsPage({
    this.clusterProvider,
    this.uuid,
  });
  @override
  _HouseHoldsPageState createState() => _HouseHoldsPageState();
}

class _HouseHoldsPageState extends State<HouseHoldsPage> {
  int page = 0;
  @override
  void initState() {
    super.initState();
    widget.clusterProvider.getClusterHouseHolds(params: {
      "page": "$page",
      "uuid": "${widget.uuid}",
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.clusterProvider.getClusterHouseHolds(params: {
          "page": "$page",
          "uuid": "${widget.uuid}",
        });
      }
    });
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<HouseHoldsPageData>(
      stream: widget.clusterProvider.houseHoldDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            controller: scrollController,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: snapshot.data.content.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data.content.values
                    .toList()[index]
                    .householdHeadFirstName),
                subtitle:
                    Text(snapshot.data.content.values.toList()[index].address),
              );
            },
          );
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
