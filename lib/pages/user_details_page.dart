import 'package:boletas_app/models/household.dart';
import 'package:boletas_app/pages/devices_page.dart';
import 'package:boletas_app/providers/cluster_provider.dart';
import 'package:boletas_app/providers/users_provider.dart';
import 'package:flutter/material.dart';

import 'clusters_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String uuid;
  final String fullName;
  final UsersProvider provider;
  const UserDetailsPage(
      {Key key, this.fullName, @required this.uuid, @required this.provider})
      : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  ClusterProvider clusterProvider = ClusterProvider();
  TextEditingController clusterSearchController = TextEditingController();
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget buildTab({IconData icon, String title}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "$title".toUpperCase(),
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.fullName}"),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              child: buildTab(
                icon: Icons.account_tree,
                title: "segmentos",
              ),
            ),
            Tab(
              child: buildTab(
                icon: Icons.person,
                title: "encuestadores",
              ),
            ),
            Tab(
              child: buildTab(
                icon: Icons.phone_android,
                title: "dispositivos",
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Scaffold(
            body: Center(child: buildClusterList()),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push<String>(MaterialPageRoute(builder: (context) {
                  return ClustersPage(selectionMode: true);
                })).then((value) => value != null
                        ? widget.provider
                            .addUserCluster(uuid: widget.uuid, cluster: value)
                            .then((value) => setState(() {}))
                        : () {});
              },
            ),
          ),
          Scaffold(
            body: Center(child: buildDevicesList()),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push<String>(MaterialPageRoute(builder: (context) {
                  return DevicesPage(isSelectable: true);
                })).then((value) => value != null
                        ? widget.provider
                            .addUserDevice(uuid: widget.uuid, device: value)
                            .then((value) => setState(() {}))
                        : () {});
              },
            ),
          ),
          Scaffold(
            body: Center(child: buildDevicesList()),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push<String>(MaterialPageRoute(builder: (context) {
                  return DevicesPage(isSelectable: true);
                })).then((value) => value != null
                        ? widget.provider
                            .addUserDevice(uuid: widget.uuid, device: value)
                            .then((value) => setState(() {}))
                        : () {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDevicesContent(String uuid) {
    return Column(
      children: [
        ListTile(
          title: Text("DISPOSITIVOS"),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push<String>(MaterialPageRoute(builder: (context) {
                return DevicesPage(isSelectable: true);
              })).then((value) => value != null
                      ? widget.provider
                          .addUserDevice(uuid: widget.uuid, device: value)
                          .then((value) => setState(() {}))
                      : () {});
            },
          ),
        ),
        Divider(),
        Expanded(child: buildDevicesList()),
      ],
    );
  }

  Widget buildDevicesList() {
    return FutureBuilder<Map<String, dynamic>>(
      initialData: Map(),
      future: widget.provider.getUserDevices(uuid: widget.uuid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.isEmpty || snapshot.data["content"].isEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              child: Text(
                "NO HAY DISPOSITIVOS ASIGNADOS PARA ESTE USUARIO".toLowerCase(),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data["content"].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${snapshot.data["content"][index]["modelId"]} - ${snapshot.data["content"][index]["bluetoothMacAddress"]}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${snapshot.data["content"][index]["brand"]["brand"]}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      widget.provider.removeUserDevice(
                          uuid: widget.uuid,
                          device: snapshot.data["contet"][index]["uuid"]);
                    },
                  ),
                  leading: Icon(Icons.phone_android),
                );
              },
            );
          }
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildClustersContent() {
    return Column(
      children: [
        ListTile(
          title: Text("SEGMENTOS"),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push<Cluster>(
                  MaterialPageRoute(builder: (context) {
                return ClustersPage(selectionMode: true);
              })).then((value) => value != null
                  ? widget.provider
                      .addUserCluster(uuid: widget.uuid, cluster: value.uuid)
                      .then((value) => setState(() {}))
                  : () {});
            },
          ),
        ),
        Divider(),
        Expanded(child: buildClusterList()),
      ],
    );
  }

  Widget buildClusterList() {
    return FutureBuilder<Map<String, dynamic>>(
      initialData: Map(),
      future: widget.provider.getUserClusters(uuid: widget.uuid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.isEmpty || snapshot.data["content"].isEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
              child: Text(
                "NO HAY SEGMENTOS ASIGNADOS PARA ESTE USUARIO".toLowerCase(),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data["content"].length,
              itemBuilder: (context, index) {
                final cluster =
                    Cluster.fromJson(snapshot.data["content"][index]);
                return ListTile(
                  title: Text(
                    "${cluster?.commune?.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${cluster?.code}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/households",
                      arguments: {
                        "uuid": cluster.uuid,
                        "provider": ClusterProvider(),
                        "clusterCode": cluster.code,
                      },
                    );
                  },
                  leading: Icon(Icons.account_tree),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      widget.provider
                          .removeUserCluster(
                              uuid: widget.uuid, cluster: cluster.uuid)
                          .then((value) => setState(() {}));
                    },
                  ),
                );
              },
            );
          }
        }
        return Container();
      },
    );
  }
}
