import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../locator.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../domain/usecases/add_members.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../../domain/usecases/leave_chat.dart';
import '../../../domain/usecases/update_chat_settings.dart';
import '../cubit/chat_details_cubit.dart';
import 'chat_detail_screen.dart';

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