import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/add_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/leave_chat.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/update_chat_settings.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_appbar.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_screen.dart';

import '../../../../../locator.dart';
import '../../../../../main.dart';

class ChatDetailPage extends StatefulWidget {

  static Route route(ChatEntity chatEntity) {
    return MaterialPageRoute<void>(builder: (_) => ChatDetailPage(chatEntity: chatEntity));
  }

  final ChatEntity chatEntity;

  const ChatDetailPage({
    @required this.chatEntity,
    Key key, 
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  NavigatorState get _navigator => navigatorKey.currentState;

  GetChatDetails getChatDetails;
  AddMembers addMembers;
  LeaveChat leaveChat;
  UpdateChatSettings updateChatSettings;

  @override
  void initState() {
    ChatRepositoryImpl chatRepositoryImpl = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.chatEntity.chatId, 
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
      body: BlocProvider(
        create: (context) => ChatDetailsCubit(
          getChatDetails: getChatDetails,
          addMembers: addMembers,
          leaveChat: leaveChat,
          updateChatSettings: updateChatSettings
        ),
        child: Scaffold(
          body: Stack(
            children: [
              ChatDetailScreen(
                chatEntity: widget.chatEntity, 
                getChatDetails: getChatDetails
              ),
              ChildDetailAppBar(
                onPressRightIcon: () {
                  _navigator.push(CreateGroupPage.route(
                    mode: CreateGroupScreenMode.edit,
                    chatEntity: widget.chatEntity
                  ));
                },
              ),
           ]
          )
        ),
      ),
    );
  }
}