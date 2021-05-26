import 'package:boletas_app/pages/form_page.dart';
import 'package:boletas_app/pages/raw_page.dart';
import 'package:boletas_app/providers/dictionary_provider.dart';
import 'package:flutter/material.dart';
import "dart:math" as math;

import 'package:flutter_json_widget/flutter_json_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => TestPage(
              title: "Home page",
              prefix: "code",
            ),
      },
    );
  }
}

class TestPage extends StatefulWidget {
  TestPage({Key key, this.title, this.prefix = "", this.length = 100})
      : super(key: key);
  final String title;
  final String prefix;
  final int length;
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  DictionaryProvider dictionaryProvider = DictionaryProvider();
  List<int> indexes = [];
  math.Random randomInstance = math.Random();
  @override
  void initState() {
    super.initState();
    indexes =
        List.generate(widget.length, (index) => randomInstance.nextInt(99));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh), onPressed: () => setState(() {}))
        ],
      ),
      body: FutureBuilder(
          future: dictionaryProvider.getDictionaries(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return buildErrorContent(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.book),
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      title: Text(snapshot.data[index]["name"]),
                      subtitle: Text(snapshot.data[index]["sha256"]),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  scrollable: true,
                                  content:
                                      buildDialogContent(snapshot.data[index]));
                            });
                      });
                },
              );
            } else {
              return buildLoadingContent();
            }
          }),
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

  Widget buildDialogContent(Map<String, dynamic> element) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.file_present),
          title: Text("RAW"),
          subtitle: Text("Muestra el diccionario en RAW"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return FutureBuilder(
                  future: dictionaryProvider.getRawDictionary(element["uuid"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Scaffold(body: buildErrorContent(snapshot.error));
                    } else if (snapshot.hasData) {
                      return RawPage(
                        title: "${snapshot.data["name"]}",
                        raw: "${snapshot.data["lines"]}",
                      );
                    } else {
                      return Scaffold(body: buildLoadingContent());
                    }
                  },
                );
              },
            ));
          },
        ),
        ListTile(
          leading: Icon(Icons.code),
          title: Text("JSON"),
          subtitle: Text("Muestra el diccionario en JSON"),
          onTap: () {
            final title = Text(element["name"]);
            final body = FutureBuilder(
              future: dictionaryProvider.getDictionary(element["uuid"]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return buildErrorContent(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: JsonViewerWidget(
                        snapshot.data.toJson(),
                        notRoot: false,
                      ),
                    ),
                  );
                } else {
                  return buildLoadingContent();
                }
              },
            );
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: title,
                ),
                body: body,
              );
            }));
          },
        ),
        ListTile(
          leading: Icon(Icons.read_more),
          title: Text("READ"),
          subtitle: Text("Muestra los registros asociados al diccionario"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.build),
          title: Text("BUILD"),
          subtitle: Text("Construye un nuevo formulario para agregar datos"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                future: dictionaryProvider.getDictionary(element["uuid"]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                        body: buildErrorContent(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return FormPage(dictionary: snapshot.data);
                  } else {
                    return Scaffold(body: buildLoadingContent());
                  }
                },
              );
            }));
          },
        ),
      ],
    );
  }
}
