import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/add_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/leave_chat.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/update_chat_settings.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_skeleton_page.dart';

import '../../../../../locator.dart';

class ChatDetailPage extends StatefulWidget {

  static Route route(int id) {
    return MaterialPageRoute<void>(builder: (_) => ChatDetailPage(id: id));
  }

  final int id;

  const ChatDetailPage({
    @required this.id,
    Key key, 
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  GetChatDetails getChatDetails;
  AddMembers addMembers;
  LeaveChat leaveChat;
  UpdateChatSettings updateChatSettings;

  @override
  void initState() {
    ChatRepositoryImpl chatRepositoryImpl = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.id, 
        client: sl(), 
        socketService: sl()
      )
    );

    addMembers = AddMembers(repository: chatRepositoryImpl);

    getChatDetails = GetChatDetails(
      repository: chatRepositoryImpl
    );

    leaveChat = LeaveChat(repository: chatRepositoryImpl);

    updateChatSettings = UpdateChatSettings(repository: chatRepositoryImpl);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sd'),
      ),
      body: BlocProvider(
        create: (context) => ChatDetailsCubit(
          getChatDetails: getChatDetails,
          addMembers: addMembers,
          leaveChat: leaveChat,
          updateChatSettings: updateChatSettings
        ),
        child: Scaffold(
          body: ChatDetailScreen(id: widget.id, getChatDetails: getChatDetails),
        ),
      ),
    );
  }
}