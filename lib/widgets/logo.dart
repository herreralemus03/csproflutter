import 'package:flutter/material.dart';

class DigestycLogo extends StatelessWidget {
  final double size;
  DigestycLogo({this.size = 180});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Container(
        constraints: constrains,
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              color: Colors.white,
              size: this.size,
            ),
            Padding(
              padding: EdgeInsets.only(top: size / 2, right: size * 0.75),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 10),
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                child: Icon(
                  Icons.insert_chart,
                  color: Colors.white,
                  size: this.size / 2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
