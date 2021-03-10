import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailsCubit(
        getChatDetails: GetChatDetails(
          
        )
      ),
      child: Scaffold(
        body: ChatDetailScreen(id: widget.id,),
      ),
    );
  }
}