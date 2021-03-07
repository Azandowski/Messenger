import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';

class ChatDetailScreen extends StatefulWidget {
  final int id;

  ChatDetailScreen({
    @required this.id
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  
  ChatDetailsCubit _chatDetailsCubit;

  @override
  void initState() {
    super.initState();
    _chatDetailsCubit = context.read<ChatDetailsCubit>();
    _chatDetailsCubit.loadDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailsCubit, ChatDetailsState>(
      listener: (context, state) {
        if (state is ChatDetailsError) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (!(state is ChatDetailsLoading)) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.red,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 115,
                              child: Image(
                                image: state.chatDetailed?.chat?.imageUrl == null ? AssetImage('assets/images/logo.png') : 
                                  NetworkImage(state.chatDetailed?.chat?.imageUrl),
                                width: MediaQuery.of(context).size.width,
                                height: 286,
                              )
                            ),
                            Positioned(
                              bottom: 20,
                              child: Container(
                                width: 200,
                                height: 140,
                                color: Colors.green,
                              )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}