import 'package:boletas_app/pages/intent_page.dart';
import 'package:flutter/material.dart';

class DffPage extends StatelessWidget {
  const DffPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DFF"),
      ),
      body: IntentPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No action default for this button"),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
