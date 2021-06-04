import 'package:boletas_app/providers/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

class RecordFilesPage extends StatefulWidget {
  final List<dynamic> records;
  RecordFilesPage({
    this.records,
  });
  @override
  _RecordFilesPageState createState() => _RecordFilesPageState();
}

class _RecordFilesPageState extends State<RecordFilesPage> {
  final provider = RecordProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diccionarios")),
      body: Container(
        child: ListView.builder(
          itemCount: widget.records.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.file_copy_sharp),
              title: Text("${widget.records[index]['name']}"),
              subtitle: Text("${widget.records[index]['sha256']}"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return FutureBuilder(
                    future: provider.getRecords(widget.records[index]['uuid']),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Scaffold(
                          appBar: AppBar(title: Text("Error")),
                          body: buildErrorContent(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Container(
                            child: SingleChildScrollView(
                                child: JsonArrayViewerWidget(snapshot.data)),
                          ),
                        );
                      } else {
                        return Scaffold(
                          appBar: AppBar(title: Text("Cargando...")),
                          body: buildLoadingContent(),
                        );
                      }
                    },
                  );
                }));
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildLoadingContent() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Center(child: CircularProgressIndicator())),
          SizedBox(
            height: 20,
          ),
          Text("Cargando..."),
        ],
      ),
    );
  }

  Widget buildErrorContent(String message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          Divider(),
          Icon(
            Icons.error,
            color: Colors.deepOrange,
            size: 40,
          ),
        ],
      )),
    );
  }
}
