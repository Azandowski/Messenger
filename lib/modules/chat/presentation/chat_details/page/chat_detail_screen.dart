import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/widgets/independent/buttons/icon_text_button.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_detail_header.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_media_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_members_block.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/divider_wrapper.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_members/chat_members_screen.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/profile/presentation/widgets/profile_item.dart';

import '../../../../../main.dart';

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

  NavigatorState get _navigator => navigatorKey.currentState;

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
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatDetailHeader(chatDetailed: state.chatDetailed),
                DividerWrapper(
                  children: ChatSettings.values.map((e) => ChatSettingItem(
                    chatSetting: e,
                    isOn: e.getValue(state.chatDetailed?.settings),
                    onToggle: (value) {
                      _chatDetailsCubit.toggleChatSetting(e, value);
                    },
                  )).toList(),
                ),
                _buildSeparator(),
                ChatMediaBlock(
                  media: state.chatDetailed.media
                ),
                _buildSeparator(),
                IconTextButton(
                  imageAssetPath: 'assets/icons/create.png',
                  onPress: () {
                    // TODO: Implement it 
                  },
                  title: 'Добавить участников',
                ),
                _buildSeparator(),
                ChatMembersBlock(
                  members: state.chatDetailed.members, 
                  membersCount: state.chatDetailed.membersCount, 
                  onShowMoreClick: () {
                    _navigator.push(ChatMembersScreen.route(state.chatDetailed.chat.chatId));
                  }
                ),
                _buildSeparator(),
                ProfileItem(
                  profileItemData: ProfileItemData(
                    icon: Icons.exit_to_app,
                    title: 'Выйти',
                    isRed: true,
                  ),
                  onTap: () {
                    // TODO: Implement it
                  },
                ),
                _buildSeparator(height: 200)
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSeparator ({double height}) {
    return Container(
      height: height ?? 20,
      color: Colors.grey[200],
    );
  }
}
