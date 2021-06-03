import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_fix_normal,
                  size: 80,
                  color: Colors.grey.shade700,
                ),
                Divider(
                  height: 30,
                ),
                Text(
                  "Nada por aqui, nada por alla",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
