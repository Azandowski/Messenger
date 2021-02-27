import 'package:flutter/material.dart';

class CellHeaderView extends StatelessWidget {
  final String title;

  const CellHeaderView({
    @required this.title,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(
        vertical: 4, horizontal: 16
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
        )
      )
    );
  }
}