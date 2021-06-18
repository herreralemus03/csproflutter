import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:flutter/material.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({Key key}) : super(key: key);

  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage>
    with SingleTickerProviderStateMixin {
  ClusterProvider provider = ClusterProvider();
  @override
  void initState() {
    provider.syncPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PRUEBAS DE SINCRONIZACION"),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              provider.currentSyncPage = 0;
              provider.getSyncData();
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  double loadPercentage = 0;
  int counter = 0;

  @override
  void dispose() {
    provider.disposeStreams();
    super.dispose();
  }

  Widget buildBody() {
    return Container(
      child: StreamBuilder<ClustersPageData>(
        stream: provider.syncDataStream,
        builder: (context, snapshot) {
          Widget child = Text("LISTO");
          if (snapshot.connectionState == ConnectionState.active) {
            loadPercentage =
                provider.currentSyncPage / (snapshot.data?.totalPages ?? 100);
            if (snapshot.hasError) {
              Text("ALGO MALO OCURRIO :(");
            } else {
              if (loadPercentage <= 0) {
                child = Text("PREPARADOS");
              } else if (loadPercentage >= 1) {
                child = Text("COMPLETADO");
              } else {
                child = Text(
                  "PROCESANDO\n${(loadPercentage * 100).toInt()}%",
                  textAlign: TextAlign.center,
                );
              }
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            print("WAITING");
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              child,
              Container(
                child: Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: CircularProgressIndicator(
                      strokeWidth: 60,
                      value: loadPercentage,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
