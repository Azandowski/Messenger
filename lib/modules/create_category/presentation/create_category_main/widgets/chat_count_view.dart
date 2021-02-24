import 'package:flutter/material.dart';

class ChatCountView extends StatelessWidget {
  final int count;

  const ChatCountView({
    @required this.count,
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
          'Чаты: $count',
          textAlign: TextAlign.center,
        )
      )
    );
  }
}