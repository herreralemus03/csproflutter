import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:boletas_app/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:selectable_circle/selectable_circle.dart';

class IntentPage extends StatefulWidget {
  final Map<String, dynamic> args;
  const IntentPage({Key key, this.args = const {}}) : super(key: key);

  @override
  _IntentPageState createState() => _IntentPageState();
}

class _IntentPageState extends State<IntentPage> {
  @override
  void initState() {
    super.initState();
    askStoragePerssion();
  }

  Future<void> askStoragePerssion() async {
    if (Platform.isAndroid) {
      final permission = Permission.storage;
      if (!await permission.isGranted) {
        await permission.request();
      }
    }
  }

  Map<String, bool> tilesValues = Map();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Center(
            child: FutureBuilder<Directory>(
              future: getExternalStorageDirectory(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorPage(message: snapshot.error);
                } else if (snapshot.hasData) {
                  final directory =
                      io.Directory("/mnt/sdcard/csentry/Entry").listSync();
                  return Column(
                    children: directory
                        .where(
                      (element) =>
                          element.path
                              .split("/")
                              .last
                              .split(".")
                              .last
                              .toLowerCase() ==
                          "pff",
                    )
                        .map(
                      (e) {
                        final stats = e.statSync();
                        final s = SelectableCircle(
                          isSelected: tilesValues[e.path],
                          selectMode: SelectMode.simple,
                          selectedBorderColor: Colors.deepOrangeAccent,
                          borderColor: Colors.white,
                          width: 70.0,
                          child: CircleAvatar(
                            radius: 25,
                            child: Icon(
                              Icons.app_registration,
                              size: 25.0,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              tilesValues[e.path] =
                                  !(tilesValues[e.path] ?? false);
                            });
                          },
                        );
                        return buildTile(
                          leading: s,
                          title: Text("${e.path.split("/").last}"),
                          subtitle: Text("${stats.accessed}"),
                          onTap: () {
                            startCsEntry(pffFile: e.path);
                          },
                        );
                      },
                    ).toList(),
                  );
                } else {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTile(
      {Widget leading,
      Widget title,
      Widget subtitle,
      GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap?.call,
      child: Row(
        children: [
          leading,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                subtitle,
              ],
            ),
          )
        ],
      ),
    );
  }

  void startCsEntry({String pffFile}) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        componentName: 'gov.census.cspro.csentry.ui.EntryActivity',
        package: 'gov.census.cspro.csentry',
        arguments: {
          'PffFileName': pffFile,
          "StartMode": "add",
          "OperatorId": widget.args["OperatorId"] ?? "",
          "Key": widget.args["Key"] ?? "",
        }..removeWhere((key, value) => value.isEmpty),
      );
      await intent.launch();
    }
  }
}
