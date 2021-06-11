import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/pages/intent_page.dart';
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
              final houseHold = snapshot.data.content.values.toList()[index];
              return ListTile(
                title: Text(snapshot.data.content.values
                    .toList()[index]
                    .householdHeadFirstName),
                subtitle: Text(houseHold.address),
                onTap: () {
                  String key = (buildString(houseHold.houseHoldNumber, 4) +
                      buildString(houseHold.cluster.code, 3));
                  print(key);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          content: IntentPage(
                            args: {
                              "OperatorId": "MICS6",
                              "Key": "$key",
                            },
                          ),
                        );
                      });
                },
              );
            },
          );
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  String buildString(String code, int size) {
    final arrayCode = code.runes.map((e) => String.fromCharCode(e)).toList();
    final left = (size - 1) - (arrayCode.length - 1);
    print(left);
    arrayCode.insertAll(0, List.generate(left, (i) => "0"));
    return arrayCode.join("");
  }
}
