import 'package:flutter/material.dart';

class RawPage extends StatefulWidget {
  final String raw;
  final String title;

  RawPage({
    this.raw,
    this.title,
  });

  @override
  _RawPageState createState() => _RawPageState();
}

class _RawPageState extends State<RawPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("${widget.raw}"),
        ),
      ),
    );
  }
}
