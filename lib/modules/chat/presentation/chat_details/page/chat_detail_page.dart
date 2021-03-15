import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/kick_member.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_appbar.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_page.dart';
import 'package:messenger_mobile/modules/groupChat/presentation/create_group/create_group_screen.dart';

import '../../../../../locator.dart';
import '../../../../../main.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../domain/usecases/add_members.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../../domain/usecases/leave_chat.dart';
import '../../../domain/usecases/update_chat_settings.dart';
import '../cubit/chat_details_cubit.dart';
import 'chat_detail_screen.dart';

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
  KickMembers kickMembers;

  ChatDetailsCubit _chatDetailsCubit;

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

    kickMembers = KickMembers(repository: chatRepositoryImpl);

    _chatDetailsCubit = ChatDetailsCubit(
      getChatDetails: getChatDetails,
      addMembers: addMembers,
      leaveChat: leaveChat,
      updateChatSettings: updateChatSettings,
      kickMembers: kickMembers
    );
    super.initState();
  }


  @override
  void dispose() {
    _chatDetailsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatDetailsCubit,
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
              onPressLeftIcon: () {
                _chatDetailsCubit.onFinish(
                  id: widget.chatEntity.chatId, 
                  callback: (newPermissions) {
                    navigatorKey.currentContext.read<ChatGlobalCubit>().updateChatSettings(
                      chatPermissions: newPermissions, id: widget.chatEntity.chatId
                    );
                  }
                );

                Navigator.of(context).pop();
              },
            ),
          ]
        )
      ),
    );
  }
}