import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/pages/intent_page.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:boletas_app/widgets/error_page.dart';
import 'package:flutter/material.dart';

class HouseHoldsPage extends StatefulWidget {
  @override
  _HouseHoldsPageState createState() => _HouseHoldsPageState();
}

class _HouseHoldsPageState extends State<HouseHoldsPage> {
  int page = 0;
  ClusterProvider provider;
  String uuid;
  String clusterCode;
  Map<String, dynamic> arguments;
  @override
  void initState() {
    super.initState();
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    arguments =
        (ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    provider = arguments["provider"];
    uuid = arguments["uuid"];
    clusterCode = arguments["clusterCode"];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("CLUSTER:"),
            Text("$clusterCode"),
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () => Navigator.of(context)
              .popAndPushNamed("/households", arguments: arguments),
          child: buildBody()),
    );
  }

  Widget buildBody() {
    return FutureBuilder<HouseHoldsPageData>(
      future: provider.getClusterHouseHolds(params: {"uuid": uuid}),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage(message: "${snapshot.error}");
        } else if (snapshot.hasData) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20),
            controller: scrollController,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: snapshot.data.content.length,
            itemBuilder: (context, index) {
              final houseHold = snapshot.data.content.values.toList()[index];
              final titles = houseHold.householdHeadFirstName.split("]");
              return ListTile(
                leading: buildLeading(houseHold),
                title: buildRowPairData(
                  "${titles[1]}",
                  "${titles[0]}]",
                  overflow: TextOverflow.ellipsis,
                  paddingBetween: 0,
                ),
                subtitle: buildSubtitle(houseHold),
                onTap: () =>
                    showOptions(clusterCode, houseHold.houseHoldNumber),
              );
            },
          );
        }
        return Container(child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void showOptions(String clusterNode, String houseHoldNumber) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Nueva encuesta"),
              onTap: () {
                Navigator.of(context).pop();
                showApps(clusterNode, houseHoldNumber);
              },
            ),
          ],
        );
      },
    );
  }

  String buildString([String code = "", int size = 3]) {
    final arrayCode = code.runes.map((e) => String.fromCharCode(e)).toList();
    final left = (size - 1) - (arrayCode.length - 1);
    arrayCode.insertAll(
      0,
      List.generate(left, (i) => "0"),
    );
    return arrayCode.join("");
  }

  Widget buildLeading(HouseHold houseHold, {double size = 8.0}) {
    return Icon(
      Icons.house,
    );
  }

  Widget buildSubtitle(HouseHold houseHold) {
    return Column(
      children: [
        Divider(),
        buildRowPairData("CODE", "${houseHold.code}"),
        Divider(),
        buildRowPairData("HOUSEHOLD NUMBER", "${houseHold.houseHoldNumber}"),
        Divider(),
        buildRowPairData("DWELLING NUMBER", "${houseHold.dwellingNumber}"),
        Divider(),
        buildRowPairData("STRUCTURE NUMBER", "${houseHold.structureNumber}"),
        Divider(),
        buildRowPairData("ADRESS", "${houseHold.address}"),
      ],
    );
  }

  Widget buildRowPairData(String label, String text,
      {double paddingBetween = 90, TextOverflow overflow = TextOverflow.fade}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.trim().isEmpty ? "-" : label + ":",
          overflow: overflow,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: paddingBetween,
        ),
        Flexible(
            child: Text(
          text.trim().isEmpty ? "-" : text,
          overflow: overflow,
          textAlign: TextAlign.end,
        )),
      ],
    );
  }

  void showApps(clusterCode, houseHoldNumber) {
    String key =
        (buildString(houseHoldNumber, 4) + buildString(clusterCode, 3));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("STARTING CASE ID: "),
              Text("$key"),
            ],
          ),
          scrollable: true,
          content: IntentPage(
            args: {
              "OperatorId": "MICS6",
              "Key": "$key",
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("CERRAR"),
            )
          ],
        );
      },
    );
  }
}
