import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_members.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contcats_list.dart';

import '../../../../locator.dart';

class ChatMembersScreen extends StatelessWidget {
  
  static Route route(int id, GetChatDetails getChatDetails) {
    return MaterialPageRoute<void>(builder: (_) => ChatMembersScreen(id: id, getChatDetails: getChatDetails));
  }

  final int id;
  final GetChatDetails getChatDetails;

  ChatMembersScreen({
    @required this.id,
    @required this.getChatDetails
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
            repository: getChatDetails.repository
          )
        )..add(ContactFetched()),
        child: ContactsList()
      ),
    );
  }
}