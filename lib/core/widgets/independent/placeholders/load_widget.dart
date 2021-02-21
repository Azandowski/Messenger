import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black,
      ),
    );
  }
}
