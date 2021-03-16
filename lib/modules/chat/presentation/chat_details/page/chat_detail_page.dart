import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/app/application.dart';
import 'package:messenger_mobile/core/blocs/chat/bloc/bloc/chat_cubit.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/kick_member.dart';
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

  NavigatorState get _navigator => sl<Application>().navKey.currentState;

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
      child: BlocConsumer<ChatDetailsCubit, ChatDetailsState>(
        listener: (context, state) {
          _handleListener(state);
        },
        builder: (context, state) {
          return Scaffold(
            body: ChatDetailScreen(
              chatEntity: widget.chatEntity, 
              getChatDetails: getChatDetails
            ),
          );
        },
      ),
    );
  }

  void _handleListener (ChatDetailsState state) {
    if (state is ChatDetailsError) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message)));
    } else if (state is ChatDetailsProccessing) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: LinearProgressIndicator(), duration: Duration(days: 2),)
        );
    } else {
      if (state is ChatDetailsLeave) {
        context.read<ChatGlobalCubit>().leaveFromChat(id: widget.chatEntity.chatId);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}