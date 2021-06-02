import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final double size;
  EmptyContainer({
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_tree,
                  color: Colors.amber,
                  size: this.size,
                ),
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue,
                  size: this.size,
                ),
                Icon(
                  Icons.dock,
                  color: Colors.green,
                  size: this.size,
                ),
                Icon(
                  Icons.person,
                  color: Colors.deepPurpleAccent,
                  size: this.size,
                ),
              ],
            ),
            Positioned(
              height: 20,
              child: Icon(
                Icons.search_off,
                size: size * 2.0,
                color: Colors.redAccent,
              ),
            )
          ],
        ),
        SizedBox(
          height: 60,
        ),
        Text("Ningun elemento alojado")
      ],
    );
  }
}
