import 'package:flutter/material.dart';
import 'package:boletas_app/models/dictionary.dart';

class FormPage extends StatefulWidget {
  final Dictionary dictionary;

  FormPage({this.dictionary});
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dictionary.name)),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: buildRecordsSections(widget.dictionary),
      ),
    );
  }

  Widget buildRecordsSections(Dictionary dictionary) {
    return ListView.builder(
        itemBuilder: (context, index) =>
            buildFieldsByRecord(dictionary.level.records[index]),
        itemCount: dictionary.level.records.length);
  }

  Widget buildFieldsByRecord(Record record) {
    final items = record.items.where((element) => !element.zeroFill).toList();
    final fields = List<Widget>.generate(
        items.length,
        (index) => TextFormField(
              decoration: InputDecoration(
                labelText: items[index].label,
                icon: CircleAvatar(
                  child: Text(
                    "${items[index].name}",
                    style: TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ))
      ..insert(
        0,
        Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: Column(
            children: [
              Text(record.label),
              Divider(),
            ],
          ),
        ),
      );
    return Column(children: fields);
  }
}
