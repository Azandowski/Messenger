import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_members.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contcats_list.dart';

import '../../../../locator.dart';

class ChatMembersScreen extends StatelessWidget {
  
  static Route route(int id) {
    return MaterialPageRoute<void>(builder: (_) => ChatMembersScreen(id: id));
  }

  final int id;

  ChatMembersScreen({
    @required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Участники'),
      ),
      body: BlocProvider(
        create: (context) => ContactBloc(
          mode: GetChatMembersMode(id),
          getChatMembers: GetChatMembers(
            repository: sl()
          )
        )..add(ContactFetched()),
        child: ContactsList()
      ),
    );
  }
}