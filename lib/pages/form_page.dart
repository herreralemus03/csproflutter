import 'package:flutter/material.dart';
import 'package:boletas_app/models/dictionary.dart';
import 'package:flutter/services.dart';

class FormPage extends StatefulWidget {
  final Dictionary dictionary;

  FormPage({this.dictionary});
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<String> recordLabels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dictionary.name)),
      drawer: Drawer(
        child: ListView(
          children: buildDrawerItems(widget.dictionary),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 10,
        ),
        child: buildRecordsSections(
          widget.dictionary,
        ),
      ),
    );
  }

  PageController pageController = PageController();
  List<Widget> buildDrawerItems(Dictionary dictionary) {
    return dictionary.level.records
        .asMap()
        .map((k, v) => MapEntry(
            k,
            ListTile(
              title: Text(v.label),
              onTap: () => pageController.jumpToPage(k),
            )))
        .values
        .toList();
  }

  Widget buildRecordsSections(Dictionary dictionary) {
    return buildPages(dictionary);
  }

  Widget buildPages(Dictionary dictionary) {
    final pages = dictionary.level.records
        .map((record) => buildFieldsByRecord(record))
        .where((element) => element.isNotEmpty)
        .map((e) => ListView(children: e.toList()))
        .toList();

    return PageView(
      controller: pageController,
      children: pages,
    );
  }

  Map<String, TextEditingController> textControllers = Map();
  Map<String, String> values = Map();
  List<Widget> buildFieldsByRecord(Record record) {
    final items = record.items.where((element) => !element.zeroFill).toList();
    final fields = items.map((item) {
      if (item.valueSet != null) {
        if (item.label.length > 20) {
          return buildRadio(item);
        }
        return buildDropDown(item);
      }
      return buildTextField(item);
    }).toList();
    return fields;
  }

  Widget buildRadio(Item item) {
    final radioList = item.valueSet.values
        .map(
          (e) => RadioListTile(
              value: e.key,
              groupValue: values[item.name],
              title: Text("${e.value}"),
              onChanged: (value) => setState(() => values[e.key] = value)),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Column(
        children: [
          Text(
            "${item.label}",
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          ...radioList,
        ],
      ),
    );
  }

  Widget buildDropDown(Item item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: DropdownButtonFormField(
        isExpanded: true,
        hint: Text(
          item.label,
          overflow: TextOverflow.ellipsis,
        ),
        isDense: true,
        value: values[item.name],
        items: item.valueSet.values
            .map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: Text(
                  "${e.value}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (val) {
          setState(() {
            values[item.name] = val;
          });
        },
      ),
    );
  }

  Widget buildTextField(Item item) {
    if (textControllers["${item.name}"] == null) {
      textControllers["${item.name}"] = TextEditingController();
      textControllers["${item.name}"].addListener(() {
        setState(() {
          textControllers["${item.name}"].text;
        });
      });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: TextFormField(
        controller: textControllers["${item.name}"],
        decoration: InputDecoration(
          labelText: item.label,
          counter: Text(
              "${textControllers['${item.name}'].text.length} / ${item.len}"),
          counterText: "longitud",
        ),
        keyboardType: item.dataType.toLowerCase() == "alpha"
            ? TextInputType.text
            : TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(item.len),
          item.dataType.toLowerCase() == "alpha"
              ? FilteringTextInputFormatter.deny("")
              : FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
