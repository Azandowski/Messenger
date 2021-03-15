import 'package:flutter/material.dart';

import '../../../domain/entities/chat_actions.dart';

class ChatActionView extends StatelessWidget {
  
  final ChatActions chatActions;

  ChatActionView({
    @required this.chatActions
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(
        'Action', 
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}