import 'package:boletas_app/providers/device_provider.dart';
import 'package:boletas_app/widgets/empty_page.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatefulWidget {
  final bool isSelectable;
  const DevicesPage({Key key, this.isSelectable = false}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  DeviceProvider deviceProvider = DeviceProvider();

  @override
  void initState() {
    deviceProvider.getAllDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dispositivos"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: deviceProvider.dataStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          if (snapshot.data.isEmpty || snapshot.data["content"].isEmpty) {
            return EmptyPage();
          } else {
            return ListView.builder(
              itemCount: snapshot.data["content"].length,
              itemBuilder: (context, index) {
                final device = snapshot.data["content"][index];
                return ListTile(
                  title: Text(
                    "${device["modelId"]} - ${device["bluetoothMacAddress"]}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${device["brand"]["brand"]}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (widget.isSelectable) {
                      Navigator.of(context).pop("${device["uuid"]}");
                    }
                  },
                  leading: Icon(Icons.phone_android),
                  trailing: !widget.isSelectable
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        )
                      : null,
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
