import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/chat/data/datasources/local_chat_datasource.dart';

import '../../../../../app/application.dart';
import '../../../../../core/blocs/chat/bloc/bloc/chat_cubit.dart';
import '../../../../../core/services/network/Endpoints.dart';
import '../../../../../core/utils/snackbar_util.dart';
import '../../../../../locator.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../domain/usecases/add_members.dart';
import '../../../domain/usecases/block_user.dart';
import '../../../domain/usecases/get_chat_details.dart';
import '../../../domain/usecases/kick_member.dart';
import '../../../domain/usecases/leave_chat.dart';
import '../../../domain/usecases/set_social_media.dart';
import '../../../domain/usecases/update_chat_settings.dart';
import '../cubit/chat_details_cubit.dart';
import 'chat_detail_screen.dart';

class ChatDetailPage extends StatefulWidget {

  static Route route(int id, ProfileMode mode) {
    return MaterialPageRoute<void>(builder: (_) => ChatDetailPage(
      id: id,
      mode: mode ?? ProfileMode.chat
    ));
  }

  final int id;
  final ProfileMode mode;

  const ChatDetailPage({
    @required this.id,
    this.mode = ProfileMode.chat,
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
  BlockUser blockUser;
  SetSocialMedia setSocialMedia;

  ChatDetailsCubit _chatDetailsCubit;

  @override
  void initState() {
    ChatRepositoryImpl chatRepositoryImpl = ChatRepositoryImpl(
      networkInfo: sl(),
      chatDataSource: ChatDataSourceImpl(
        id: widget.id, 
        multipartRequest: http.MultipartRequest(
          'POST', Endpoints.sendMessages.buildURL(
            urlParams: ['${widget.id}']
          )
        ),
        client: sl(), 
        socketService: sl()
      ),
      localChatDataSource: LocalChatDataSourceImpl()
    );

    addMembers = AddMembers(repository: chatRepositoryImpl);

    getChatDetails = GetChatDetails(
      repository: chatRepositoryImpl
    );

    leaveChat = LeaveChat(repository: chatRepositoryImpl);

    updateChatSettings = UpdateChatSettings(repository: chatRepositoryImpl);

    kickMembers = KickMembers(repository: chatRepositoryImpl);

    blockUser = BlockUser(repository: chatRepositoryImpl);

    setSocialMedia = SetSocialMedia(repository: chatRepositoryImpl);

    _chatDetailsCubit = ChatDetailsCubit(
      getChatDetails: getChatDetails,
      addMembers: addMembers,
      leaveChat: leaveChat,
      updateChatSettings: updateChatSettings,
      kickMembers: kickMembers,
      blockUser: blockUser,
      setSocialMedia: setSocialMedia
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
              id: widget.id, 
              getChatDetails: getChatDetails,
              mode: widget.mode,
            ),
          );
        },
      ),
    );
  }

  void _handleListener (ChatDetailsState state) {
    if (state is ChatDetailsError) {
      SnackUtil.showError(context: context, message: state.message);
    } else if (state is ChatDetailsProccessing) {
      SnackUtil.showLoading(context: context);
    } else {
      if (state is ChatDetailsLeave) {
        context.read<ChatGlobalCubit>().leaveFromChat(id: widget.id);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}