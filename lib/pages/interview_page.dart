import 'package:boletas_app/models/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

class InterViewPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  InterViewPage({
    this.arguments,
  });

  @override
  _InterViewPageState createState() => _InterViewPageState();
}

class _InterViewPageState extends State<InterViewPage> {
  Dictionary interview;
  @override
  void initState() {
    super.initState();
    this.interview = Dictionary.fromJson(widget.arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: JsonViewerWidget(widget.arguments),
        ),
      ),
    );
  }
}
